# ISHE Group AI Platform - Quick Start Guide

## 🚀 Getting Started with Google Authentication

This platform provides seamless integration with your Google account, giving you instant access to Gmail, Calendar, Drive, and Google Cloud services.

## Prerequisites

- Google Account (Gmail)
- Google Cloud Platform account (free tier available)
- Docker & Docker Compose (for easy setup) OR Python 3.10+
- Node.js 16+ (for frontend)

## Option 1: Quick Setup with Automated Script (Recommended)

### 1. Clone the Repository

```bash
git clone https://github.com/iansmith35/SuperAGI.git
cd SuperAGI
```

### 2. Set Up Google Cloud

Follow the detailed guide: [GOOGLE_INTEGRATION_GUIDE.md](GOOGLE_INTEGRATION_GUIDE.md)

**Quick checklist:**
- Create a Google Cloud Project
- Enable Gmail, Calendar, and Drive APIs
- Create OAuth 2.0 credentials
- Download service account key

### 3. Run Setup Script

```bash
./setup_google_auth.sh
```

This interactive script will:
- ✅ Prompt for your Google OAuth credentials
- ✅ Generate secure JWT and encryption keys
- ✅ Create configuration files
- ✅ Set up service account credentials
- ✅ Configure database settings

### 4. Start the Platform

```bash
# Start backend and database with Docker
docker-compose up

# In a new terminal, start frontend
cd gui
npm install
npm run dev
```

### 5. Sign In with Google

1. Open browser: `http://localhost:3000`
2. Click **"Sign in with Google"**
3. Enter your Google credentials
4. Grant permissions
5. You're in! 🎉

## Option 2: Manual Setup

### 1. Configure Environment

Copy template and edit:
```bash
cp config_template.yaml config.yaml
```

Edit `config.yaml` with your credentials:

```yaml
# Required: Google OAuth
GOOGLE_CLIENT_ID: your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET: your-client-secret
GOOGLE_REDIRECT_URI: "http://localhost:3000/api/google/oauth-callback"

# Required: Database
DB_NAME: ishe_group_db
DB_HOST: localhost
DB_USERNAME: postgres
DB_PASSWORD: your-secure-password
DB_URL: postgresql://postgres:your-secure-password@localhost:5432/ishe_group_db

# Required: Security
JWT_SECRET_KEY: 'generate-random-32-char-key'
ENCRYPTION_KEY: 'generate-random-32-char-key'

# Optional: AI Models
OPENAI_API_KEY: your-openai-key
```

### 2. Setup Database

```bash
# Start PostgreSQL and Redis
docker-compose up -d super__postgres super__redis

# Run migrations
alembic upgrade head
```

### 3. Install Dependencies

```bash
# Backend
pip install -r requirements.txt

# Frontend
cd gui
npm install
cd ..
```

### 4. Start Services

```bash
# Terminal 1: Backend
uvicorn main:app --host 0.0.0.0 --port 8001 --reload

# Terminal 2: Frontend
cd gui
npm run dev
```

### 5. Access Platform

Navigate to `http://localhost:3000` and sign in with Google!

## Option 3: Docker Compose (Full Stack)

The easiest way to run everything:

```bash
# Copy config template
cp config_template.yaml config.yaml

# Edit config.yaml with your Google OAuth credentials

# Start everything
docker-compose up

# Access at http://localhost:3000
```

## What You Get Out of the Box

### ✅ Google Authentication
- Secure OAuth 2.0 login
- No password management needed
- Automatic profile sync

### ✅ Gmail Integration
- Send and receive emails
- Search messages
- Create drafts
- Manage labels

### ✅ Google Calendar
- View events
- Create meetings
- Check availability
- Send invitations

### ✅ Google Drive
- Upload files
- Download documents
- Share with team
- Search content

### ✅ Google Cloud
- Cloud Storage integration
- AI/ML APIs access
- Serverless deployment
- Scalable infrastructure

## Configuration for Different Environments

### Development (Local)
```yaml
ENV: 'DEV'
FRONTEND_URL: "http://localhost:3000"
GOOGLE_REDIRECT_URI: "http://localhost:3000/api/google/oauth-callback"
```

### Production (Railway/Cloud)
```yaml
ENV: 'PROD'
FRONTEND_URL: "https://your-domain.com"
GOOGLE_REDIRECT_URI: "https://your-domain.com/api/google/oauth-callback"
```

**Important:** Update redirect URI in Google Cloud Console when changing environments!

## Troubleshooting

### "Google OAuth not configured" Error
- Verify `GOOGLE_CLIENT_ID` is set in config.yaml
- Check credentials are from Google Cloud Console
- Ensure no extra spaces or quotes

### "redirect_uri_mismatch" Error
- Go to Google Cloud Console → Credentials
- Add your redirect URI exactly as configured
- Include http:// or https://
- Match port numbers exactly (e.g., :3000)

### "Access Denied" Error
- Check OAuth consent screen is configured
- Add your email to test users
- Verify required scopes are enabled

### Database Connection Issues
```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Check connection
psql -h localhost -U postgres -d ishe_group_db
```

### Can't Access Frontend
```bash
# Check port 3000 is available
lsof -i :3000

# Restart frontend
cd gui
npm run dev
```

## Security Checklist

- ✅ Never commit `config.yaml` or `.env` files
- ✅ Keep service account keys secure
- ✅ Use strong database passwords
- ✅ Enable 2FA on your Google account
- ✅ Regularly rotate API keys
- ✅ Review OAuth permissions granted

## Next Steps

1. **Customize Your Workspace**
   - Create your first AI agent
   - Set up projects
   - Configure tools

2. **Deploy to Production**
   - See [RAILWAY_DEPLOY.md](RAILWAY_DEPLOY.md)
   - Configure production Google OAuth
   - Set up Cloud SQL and Memorystore

3. **Integrate More Google Services**
   - Google Sheets
   - Google Docs
   - Google Meet
   - Google Analytics

4. **Scale Your Infrastructure**
   - Use Google Cloud Run
   - Configure auto-scaling
   - Set up monitoring
   - Implement backups

## Support & Resources

- 📖 **Documentation**: [GOOGLE_INTEGRATION_GUIDE.md](GOOGLE_INTEGRATION_GUIDE.md)
- 🚀 **Deployment**: [RAILWAY_DEPLOY.md](RAILWAY_DEPLOY.md)
- 🔧 **Configuration**: [config_template.yaml](config_template.yaml)
- 🐛 **Issues**: [GitHub Issues](https://github.com/iansmith35/SuperAGI/issues)

## Advanced Configuration

### Using Google Cloud SQL
```yaml
DB_HOST: /cloudsql/project:region:instance
DB_URL: postgresql://user:pass@/dbname?host=/cloudsql/project:region:instance
```

### Using Google Cloud Storage
```yaml
STORAGE_TYPE: "GCS"
GCS_BUCKET_NAME: your-bucket-name
GOOGLE_APPLICATION_CREDENTIALS: /path/to/service-account.json
```

### Using Google Memorystore (Redis)
```yaml
REDIS_URL: "10.0.0.3:6379"  # Private IP from Memorystore
```

## Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `GOOGLE_CLIENT_ID` | ✅ Yes | OAuth 2.0 Client ID from Google Cloud |
| `GOOGLE_CLIENT_SECRET` | ✅ Yes | OAuth 2.0 Client Secret |
| `GOOGLE_REDIRECT_URI` | ✅ Yes | OAuth callback URL |
| `GOOGLE_CLOUD_PROJECT_ID` | ⚠️ Recommended | GCP Project ID |
| `GOOGLE_APPLICATION_CREDENTIALS` | ⚠️ Recommended | Service account key path |
| `DB_URL` | ✅ Yes | PostgreSQL connection string |
| `REDIS_URL` | ✅ Yes | Redis connection string |
| `JWT_SECRET_KEY` | ✅ Yes | JWT signing key (keep secret!) |
| `ENCRYPTION_KEY` | ✅ Yes | Data encryption key (32 chars) |
| `OPENAI_API_KEY` | ⚪ Optional | For AI features |

---

**Ready to get started?** Run `./setup_google_auth.sh` and sign in with your Google account! 🚀
