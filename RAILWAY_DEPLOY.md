# Railway Deployment Guide for ISHE Group AI Platform

## Prerequisites
- Railway account (https://railway.app)
- GitHub repository connected to Railway
- Google Cloud Platform account with OAuth credentials configured
- Required API keys for OpenAI, Pinecone, etc.

## Important: Google Authentication Setup

**This platform uses Google OAuth as the primary authentication method.**

Before deploying, you MUST:
1. Complete the Google Cloud setup in `GOOGLE_INTEGRATION_GUIDE.md`
2. Obtain your Google OAuth Client ID and Client Secret
3. Configure OAuth consent screen in Google Cloud Console
4. Add Railway redirect URIs to Google OAuth credentials

## Deployment Steps

### 1. Create a New Railway Project
1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your ISHE Group repository

### 2. Add Required Services
Your ISHE Group AI Platform needs the following services:

#### PostgreSQL Database
1. Click "New" → "Database" → "Add PostgreSQL"
2. Railway will automatically set: `DATABASE_URL`

#### Redis
1. Click "New" → "Database" → "Add Redis"
2. Railway will automatically set: `REDIS_URL`

### 3. Configure Environment Variables
Go to your main service and add these variables:

#### Required - Google OAuth (CRITICAL!)
```
# Get these from Google Cloud Console (see GOOGLE_INTEGRATION_GUIDE.md)
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_REDIRECT_URI=https://${{RAILWAY_PUBLIC_DOMAIN}}/api/google/oauth-callback
```

#### Required - Database Configuration
```
# Database (auto-set by Railway when you add PostgreSQL)
DB_NAME=railway
DB_USERNAME=${{ PGUSER }}
DB_PASSWORD=${{ PGPASSWORD }}
DB_HOST=${{ PGHOST }}
DB_URL=${{ DATABASE_URL }}

# Redis (auto-set when you add Redis)
REDIS_URL=${{ REDIS_URL }}

# OpenAI
OPENAI_API_KEY=your_openai_api_key
OPENAI_API_BASE=https://api.openai.com/v1
MODEL_NAME=gpt-3.5-turbo-0301
RESOURCES_SUMMARY_MODEL_NAME=gpt-3.5-turbo
MAX_TOOL_TOKEN_LIMIT=800
MAX_MODEL_TOKEN_LIMIT=4032

# Storage
STORAGE_TYPE=FILE
TOOLS_DIR=superagi/tools
RESOURCES_INPUT_ROOT_DIR=workspace/input/{agent_id}
RESOURCES_OUTPUT_ROOT_DIR=workspace/output/{agent_id}/{agent_execution_id}

# Auth & Security
ENV=PROD
JWT_SECRET_KEY=your_random_jwt_secret_key_here
JWT_EXPIRY=1
ENCRYPTION_KEY=your_32_character_encryption_key

# Frontend URL (use your Railway domain)
FRONTEND_URL=https://your-app.railway.app

# Vector Database
WEAVIATE_USE_EMBEDDED=true

# Optional: Pinecone (if not using embedded Weaviate)
# PINECONE_API_KEY=your_pinecone_api_key
# PINECONE_ENVIRONMENT=your_pinecone_environment

# Optional: Search APIs
# SERP_API_KEY=your_serper_api_key
# GOOGLE_API_KEY=your_google_api_key
# SEARCH_ENGINE_ID=your_search_engine_id

# Optional: GitHub OAuth
# GITHUB_CLIENT_ID=your_github_client_id
# GITHUB_CLIENT_SECRET=your_github_client_secret
```

### 4. Port Configuration
Railway automatically detects the PORT from your application. The app runs on port 8001 by default.

If Railway requires a specific PORT, update your entrypoint.sh to use `$PORT`:
```bash
exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8001} --reload
```

### 5. Deploy
1. Railway will automatically deploy after you push to your repository
2. Monitor the deployment logs in the Railway dashboard
3. Once deployed, Railway will provide a URL (e.g., `https://your-app.railway.app`)

### 6. Post-Deployment Setup
1. Access your app at the Railway-provided URL
2. Create your first user account
3. Configure your agents and tools

## Important Notes

### Database Migrations
- Alembic migrations run automatically on startup via `entrypoint.sh`
- The startup script runs: `alembic upgrade head`

### Storage
- Currently configured for FILE storage
- For production, consider using S3 with these additional variables:
  ```
  STORAGE_TYPE=S3
  BUCKET_NAME=your_bucket_name
  AWS_ACCESS_KEY_ID=your_aws_key
  AWS_SECRET_ACCESS_KEY=your_aws_secret
  ```

### Celery Workers
- The current setup is for the main backend service only
- For full functionality, you may need to add a separate Celery worker service
- Use the same Dockerfile but override the command to run celery

### GUI/Frontend
- If deploying the GUI, create a separate Railway service
- Point it to the `gui/` directory
- Set `NEXT_PUBLIC_API_BASE_URL` to your backend URL

## Troubleshooting

### Database Connection Issues
- Ensure PostgreSQL service is running
- Check that `DATABASE_URL` is correctly set
- Verify network connectivity between services

### Redis Connection Issues
- Ensure Redis service is running
- Check that `REDIS_URL` is correctly formatted

### Migration Errors
- Check logs for specific Alembic errors
- May need to manually run migrations: `railway run alembic upgrade head`

### Port Binding Issues
- Railway expects apps to bind to `0.0.0.0`
- Check that your app listens on the correct port

## Scaling
Railway allows you to:
- Scale memory and CPU
- Add multiple workers
- Enable auto-scaling based on traffic

## Monitoring
- Use Railway's built-in logging
- Set up health check endpoints
- Monitor resource usage in dashboard

## Support
- Railway Docs: https://docs.railway.app
- SuperAGI Docs: https://superagi.com/docs/
