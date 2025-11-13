# ISHE Group Platform - Google Cloud & Workspace Integration Guide

## Overview
This platform is designed to work seamlessly with Google's ecosystem, providing secure authentication and deep integration with Google Cloud Platform and Google Workspace services.

## Google Authentication Setup

### 1. Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click "Select a project" → "New Project"
3. Enter project name: **ISHE Group AI Platform**
4. Click "Create"

### 2. Enable Required APIs

Navigate to "APIs & Services" → "Library" and enable:

- ✅ **Google+ API** (for user authentication)
- ✅ **People API** (for profile information)
- ✅ **Gmail API** (for email integration)
- ✅ **Google Calendar API** (for calendar access)
- ✅ **Google Drive API** (for file storage)
- ✅ **Cloud Natural Language API** (for AI features)
- ✅ **Cloud Storage API** (for cloud storage)
- ✅ **Cloud Run API** (for deployment)

### 3. Configure OAuth Consent Screen

1. Go to "APIs & Services" → "OAuth consent screen"
2. Select **External** user type
3. Fill in application information:
   - **App name**: ISHE Group AI Platform
   - **User support email**: your-email@gmail.com
   - **Developer contact email**: your-email@gmail.com
4. Add scopes:
   ```
   openid
   .../auth/userinfo.email
   .../auth/userinfo.profile
   .../auth/calendar
   .../auth/drive.file
   .../auth/gmail.readonly
   .../auth/gmail.send
   .../auth/cloud-platform.read-only
   ```
5. Add test users (your Google account email)
6. Click "Save and Continue"

### 4. Create OAuth 2.0 Credentials

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. Select **Web application**
4. Configure:
   - **Name**: ISHE Group Web Client
   - **Authorized JavaScript origins**:
     ```
     http://localhost:3000
     https://your-domain.com
     https://your-app.railway.app
     ```
   - **Authorized redirect URIs**:
     ```
     http://localhost:3000/api/google/oauth-callback
     https://your-domain.com/api/google/oauth-callback
     https://your-app.railway.app/api/google/oauth-callback
     ```
5. Click "Create"
6. **IMPORTANT**: Copy your Client ID and Client Secret

### 5. Create Service Account (for Cloud APIs)

1. Go to "IAM & Admin" → "Service Accounts"
2. Click "Create Service Account"
3. Enter details:
   - **Name**: ishe-group-platform-sa
   - **Description**: Service account for ISHE Group AI Platform
4. Grant roles:
   - Cloud Storage Admin
   - Cloud Run Admin
   - Service Account User
5. Click "Done"
6. Click on the created service account
7. Go to "Keys" tab → "Add Key" → "Create new key"
8. Select **JSON** format
9. Download the key file (keep it secure!)

## Environment Configuration

### Local Development (.env or config.yaml)

```yaml
# Google OAuth (Required for user authentication)
GOOGLE_CLIENT_ID: your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET: your-client-secret
GOOGLE_REDIRECT_URI: "http://localhost:3000/api/google/oauth-callback"

# Google Cloud Platform
GOOGLE_CLOUD_PROJECT_ID: your-project-id
GOOGLE_APPLICATION_CREDENTIALS: /path/to/service-account-key.json

# Application Settings
FRONTEND_URL: "http://localhost:3000"
ENV: "DEV"

# Database (use Google Cloud SQL for production)
DB_NAME: ishe_group_db
DB_HOST: localhost  # or Cloud SQL instance connection
DB_USERNAME: postgres
DB_PASSWORD: your-password
DB_URL: postgresql://postgres:password@localhost:5432/ishe_group_db

# Redis (use Google Memorystore for production)
REDIS_URL: "localhost:6379"

# Storage (use Google Cloud Storage for production)
STORAGE_TYPE: "FILE"  # Change to "GCS" for Google Cloud Storage
# GCS_BUCKET_NAME: ishe-group-storage

# JWT Security
JWT_SECRET_KEY: generate-random-secret-key-here
ENCRYPTION_KEY: generate-32-character-key-here
```

### Railway Deployment Configuration

In Railway, add these environment variables:

```bash
# Google OAuth
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_REDIRECT_URI=https://your-app.railway.app/api/google/oauth-callback

# Google Cloud
GOOGLE_CLOUD_PROJECT_ID=your-project-id
GOOGLE_APPLICATION_CREDENTIALS=/app/credentials/google-cloud-key.json

# Application
FRONTEND_URL=https://your-app.railway.app
ENV=PROD

# Add service account JSON as secret file:
# Create a Railway secret: GCP_SERVICE_ACCOUNT_KEY
# Paste the entire JSON content of your service account key
```

## Testing Authentication

### 1. Start the Application

```bash
# Backend
uvicorn main:app --host 0.0.0.0 --port 8001 --reload

# Frontend (in gui directory)
npm run dev
```

### 2. Test Google Sign-In

1. Navigate to `http://localhost:3000`
2. Click "Sign in with Google"
3. You'll be redirected to Google's login page
4. Enter your Google credentials
5. Grant permissions to the application
6. You'll be redirected back with authentication complete

## Google Workspace Integration Features

### Gmail Integration
- Send emails on behalf of users
- Read and manage emails
- Create drafts
- Search emails

### Google Calendar
- Create, update, and delete events
- Check availability
- Send meeting invitations
- Sync calendars

### Google Drive
- Upload and download files
- Create folders
- Share documents
- Search files

### Google Cloud Storage
- Store application data
- Manage file uploads
- CDN integration
- Backup and archival

## Security Best Practices

1. **Never commit credentials** to version control
2. **Use environment variables** for all secrets
3. **Enable 2FA** on your Google account
4. **Rotate credentials** regularly
5. **Limit OAuth scopes** to only what's needed
6. **Use service accounts** for backend API calls
7. **Monitor API usage** in Google Cloud Console

## Production Deployment Checklist

- [ ] OAuth consent screen verified by Google
- [ ] Service account created with minimal required permissions
- [ ] Credentials stored securely (Railway secrets, not in code)
- [ ] Redirect URIs updated for production domain
- [ ] Cloud SQL or managed database configured
- [ ] Cloud Storage bucket created with proper IAM
- [ ] API quotas reviewed and increased if needed
- [ ] Error logging and monitoring configured
- [ ] Backup strategy implemented

## Troubleshooting

### "redirect_uri_mismatch" Error
- Ensure redirect URI in code matches Google Console exactly
- Include http:// or https:// protocol
- Don't forget trailing slashes if configured

### "Access Denied" Error
- Check OAuth consent screen configuration
- Verify user is added to test users (if not verified)
- Confirm required scopes are enabled

### "Invalid Client" Error
- Verify Client ID and Secret are correct
- Check they're properly set in environment variables
- Ensure no extra spaces or quotes

### Token Refresh Issues
- Ensure `access_type=offline` is set in auth request
- Verify `prompt=consent` to get refresh token
- Store refresh tokens securely in database

## Support

For Google Cloud Platform issues:
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Google Workspace APIs](https://developers.google.com/workspace)

For ISHE Group Platform issues:
- Check application logs
- Review Railway deployment logs
- Contact: support@ishegroup.com
