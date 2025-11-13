# ISHE Group AI Platform - Environment Variables Reference

Complete reference for all environment variables used in the ISHE Group AI Platform.

---

## 🔑 Critical Variables (Required for Deployment)

### Railway Configuration
```bash
RAILWAY_TOKEN=
# Your Railway API token for autonomous operations
# Get from: https://railway.app/account/tokens
# Required for: Automated deployments, API access
```

### Database (Supabase/PostgreSQL)
```bash
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
# Primary database connection string
# Format: postgresql://[user]:[password]@[host]:[port]/[database]
# Get from: Supabase Dashboard → Settings → Database

SUPABASE_URL=https://[PROJECT-REF].supabase.co
# Supabase project URL
# Get from: Supabase Dashboard → Settings → API

SUPABASE_KEY=
# Supabase service role key (secret)
# Get from: Supabase Dashboard → Settings → API → service_role key
# ⚠️ Keep this secret! Use for server-side operations only
```

### Redis Cache
```bash
REDIS_URL=redis://default:[PASSWORD]@[HOST]:[PORT]
# Redis connection string for caching and session management
# Railway Redis plugin auto-provides this
# Alternative format: redis://:[PASSWORD]@[HOST]:[PORT]
```

### AI/LLM Configuration
```bash
OPENAI_API_KEY=sk-...
# OpenAI API key for GPT models
# Get from: https://platform.openai.com/api-keys
# Required for: Agent intelligence, text generation

MODEL_NAME=gpt-3.5-turbo-0301
# Default model for agents
# Options: gpt-3.5-turbo-0301, gpt-4, gpt-4-32k
# Cost: gpt-3.5 (~$0.002/1K tokens), gpt-4 (~$0.03/1K tokens)

OPENAI_API_BASE=https://api.openai.com/v1
# OpenAI API endpoint
# Change for: Azure OpenAI, local LLMs, proxy services
```

### Security
```bash
JWT_SECRET_KEY=
# Secret key for JWT token signing
# Generate: openssl rand -hex 32
# Must be: Strong random string (32+ characters)
# Used for: User authentication, API tokens

ENCRYPTION_KEY=
# Key for encrypting sensitive data
# Generate: openssl rand -hex 16
# Must be: Exactly 32 characters
# Used for: Database encryption, secure storage
```

---

## 🌐 Application Settings

### Runtime Configuration
```bash
ENVIRONMENT=production
# Application environment
# Options: development, production
# production = enables security features, disables debug

PORT=8080
# HTTP server port
# Railway auto-provides $PORT variable
# Default: 8080

HOST=0.0.0.0
# Server bind address
# 0.0.0.0 = listen on all interfaces
# Required for: Docker, Railway deployments

PYTHONPATH=.
# Python module search path
# Ensures imports work correctly
```

### Frontend Configuration
```bash
FRONTEND_URL=https://your-app.railway.app
# Frontend application URL
# Railway auto-provides: $RAILWAY_STATIC_URL
# Used for: CORS, OAuth redirects, email links
# Example: https://ishe-group-ai.up.railway.app
```

---

## 🤖 Agent Configuration

### CRM Agents
```bash
MASTER_AGENT_NAME=RebeccaHQ
# Name of the master/coordinator agent
# Default: RebeccaHQ
# Used for: Central coordination, fallback agent

DEFAULT_LANGUAGE=en-GB
# Default language for agents
# Options: en-US, en-GB, es-ES, fr-FR, de-DE, etc.
# Used for: Agent responses, date/time formatting

DEFAULT_VOICE=UK-Female-Free
# Default voice for speech synthesis
# Used when: ENABLE_SPEECH=True
```

### Agent Behavior
```bash
MAX_TOOL_TOKEN_LIMIT=800
# Maximum tokens for tool outputs
# Range: 100-2000
# Higher = more detailed tool results, higher cost

MAX_MODEL_TOKEN_LIMIT=4032
# Maximum tokens per agent iteration
# Model limits: gpt-3.5 (4096), gpt-4 (8192), gpt-4-32k (32768)
# Lower = cheaper, faster; Higher = more context

RESOURCES_SUMMARY_MODEL_NAME=gpt-3.5-turbo
# Model for summarizing agent resources
# Recommendation: gpt-3.5-turbo (cost-effective)
```

### Memory & Storage
```bash
ENABLE_SUPABASE_MEMORY=True
# Enable persistent memory in Supabase
# True = agents remember across sessions
# False = memory resets after each session

STORAGE_TYPE=FILE
# Storage backend for agent resources
# Options: FILE, S3
# FILE = local filesystem (for Railway/Docker)
# S3 = Amazon S3 or compatible (for scale)

RESOURCES_INPUT_ROOT_DIR=workspace/input/{agent_id}
# Directory for agent input files
# Variables: {agent_id}, {agent_execution_id}

RESOURCES_OUTPUT_ROOT_DIR=workspace/output/{agent_id}/{agent_execution_id}
# Directory for agent output files
# Organized by: agent and execution ID
```

---

## 🔧 Feature Toggles

```bash
ENABLE_CHATBOT=True
# Enable chatbot interface
# True = chat UI available
# False = disable chat features

ENABLE_SPEECH=True
# Enable text-to-speech
# Requires: TTS service configuration
# Used for: Voice agent responses

ENABLE_GOOGLE_CONNECTORS=True
# Enable Google Workspace integrations
# Requires: GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
# Enables: Gmail, Drive, Calendar, Sheets

WEAVIATE_USE_EMBEDDED=true
# Use embedded Weaviate vector DB
# true = in-process (easy setup)
# false = external Weaviate (production recommended)
```

---

## 🔌 Third-Party Integrations

### Google Services
```bash
GOOGLE_API_KEY=
# Google API key for Search, Maps, etc.
# Get from: https://console.cloud.google.com/apis/credentials
# Used for: Google Search, Places, Geocoding

GOOGLE_CLIENT_ID=
# OAuth 2.0 client ID
# Get from: Google Cloud Console → APIs & Services → Credentials
# Used for: Google Workspace authentication

GOOGLE_CLIENT_SECRET=
# OAuth 2.0 client secret
# Get from: Google Cloud Console (same as above)
# ⚠️ Keep secret!

GOOGLE_REFRESH_TOKEN=
# OAuth refresh token for long-term access
# Generate: Run OAuth flow once to get refresh token
# Used for: Accessing Google services on behalf of user

GEMINI_API_KEY=
# Google Gemini AI API key
# Get from: https://makersuite.google.com/app/apikey
# Used for: Gemini model access (alternative to OpenAI)
```

### Search Services
```bash
SERP_API_KEY=
# SerpAPI key for Google search results
# Get from: https://serpapi.com/
# Alternative to: Google Custom Search API
# Used for: Web search by agents

SEARCH_ENGINE_ID=
# Google Custom Search Engine ID
# Get from: https://programmablesearchengine.google.com/
# Used with: GOOGLE_API_KEY for search
```

### Social Media
```bash
SLACK_BOT_TOKEN=xoxb-...
# Slack bot token
# Get from: https://api.slack.com/apps → OAuth & Permissions
# Used for: Slack notifications, channel posting

# Twitter/X configuration
# (Add if using Twitter tools)
TWITTER_API_KEY=
TWITTER_API_SECRET=
TWITTER_ACCESS_TOKEN=
TWITTER_ACCESS_SECRET=
```

### Development Tools
```bash
GITHUB_ACCESS_TOKEN=ghp_...
# GitHub personal access token
# Get from: https://github.com/settings/tokens
# Scopes: repo, workflow
# Used for: Code analysis, repository operations

GITHUB_USERNAME=
# GitHub username for the access token
# Used with: GITHUB_ACCESS_TOKEN

JIRA_INSTANCE_URL=https://yourcompany.atlassian.net
# Jira instance URL
# Format: https://[your-domain].atlassian.net
# Used for: Issue tracking integration

JIRA_USERNAME=
# Jira account email
# Usually: your email address

JIRA_API_TOKEN=
# Jira API token
# Get from: https://id.atlassian.com/manage-profile/security/api-tokens
# Used for: Jira API authentication
```

### Image Generation
```bash
STABILITY_API_KEY=sk-...
# Stability AI API key (Stable Diffusion)
# Get from: https://platform.stability.ai/
# Used for: Image generation by agents

# Note: DALL-E uses OPENAI_API_KEY
```

### Email Configuration
```bash
EMAIL_ADDRESS=
# Email address for sending/receiving
# Example: agents@ishegroup.com

EMAIL_PASSWORD=
# Email app password (not regular password)
# Gmail: https://myaccount.google.com/apppasswords
# Used for: SMTP authentication

EMAIL_SMTP_HOST=smtp.gmail.com
# SMTP server hostname
# Gmail: smtp.gmail.com
# Outlook: smtp-mail.outlook.com

EMAIL_SMTP_PORT=587
# SMTP server port
# Standard: 587 (STARTTLS), 465 (SSL)

EMAIL_IMAP_SERVER=imap.gmail.com
# IMAP server for reading emails
# Gmail: imap.gmail.com

EMAIL_SIGNATURE=Email sent by ISHE Group AI Platform
# Default email signature for agent emails
```

---

## 📊 Database Configuration (Advanced)

Alternative to DATABASE_URL, use individual components:

```bash
DB_HOST=db.[PROJECT-REF].supabase.co
# Database hostname

DB_PORT=5432
# Database port (PostgreSQL default: 5432)

DB_NAME=postgres
# Database name (Supabase default: postgres)

DB_USERNAME=postgres
# Database username (Supabase default: postgres)

DB_PASSWORD=
# Database password
# Set when creating Supabase project

DB_URL=${DATABASE_URL}
# Alternative to above individual settings
# Constructed from: postgresql://[USER]:[PASS]@[HOST]:[PORT]/[NAME]
```

---

## 🗂️ Vector Database (Weaviate)

```bash
WEAVIATE_USE_EMBEDDED=true
# Use embedded Weaviate instance
# Recommended for: Development, small deployments
# For production: Use hosted Weaviate

WEAVIATE_URL=
# Weaviate instance URL (if not embedded)
# Example: https://your-cluster.weaviate.network
# Get from: Weaviate Cloud Console

WEAVIATE_API_KEY=
# Weaviate API key (if using hosted)
# Get from: Weaviate Cloud Console
```

---

## 🔒 Security Best Practices

1. **Never commit secrets to repository**
   - Use `.env` file locally (git-ignored)
   - Use Railway environment variables for production

2. **Rotate keys regularly**
   - JWT_SECRET_KEY: Every 3-6 months
   - API keys: When compromised or yearly

3. **Use service role keys carefully**
   - SUPABASE_KEY: Server-side only
   - Keep separate from client-side keys

4. **Strong encryption keys**
   - JWT_SECRET_KEY: 32+ random characters
   - ENCRYPTION_KEY: Exactly 32 characters

5. **Monitor API usage**
   - Set billing alerts on OpenAI, Google, etc.
   - Review Railway/Supabase usage monthly

---

## 🧪 Development vs Production

### Development (Local)
```bash
ENVIRONMENT=development
WEAVIATE_USE_EMBEDDED=true
FRONTEND_URL=http://localhost:3000
DB_URL=postgresql://postgres:password@localhost:5432/superagi_dev
REDIS_URL=redis://localhost:6379
```

### Production (Railway)
```bash
ENVIRONMENT=production
WEAVIATE_USE_EMBEDDED=false
FRONTEND_URL=$RAILWAY_STATIC_URL
DATABASE_URL=[Supabase connection string]
REDIS_URL=[Railway Redis plugin provides]
```

---

## 📋 Quick Setup Checklist

### Minimum Required Variables
```bash
✅ DATABASE_URL or (DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME)
✅ REDIS_URL
✅ OPENAI_API_KEY
✅ JWT_SECRET_KEY
✅ ENCRYPTION_KEY
✅ SUPABASE_URL
✅ SUPABASE_KEY
```

### Recommended for Full Features
```bash
✅ GOOGLE_API_KEY (for search)
✅ RAILWAY_TOKEN (for autonomous deployments)
✅ FRONTEND_URL (for CORS)
✅ ENABLE_SUPABASE_MEMORY=True
```

### Optional but Useful
```bash
⭕ SLACK_BOT_TOKEN (notifications)
⭕ GITHUB_ACCESS_TOKEN (code tools)
⭕ STABILITY_API_KEY (image generation)
⭕ SERP_API_KEY (enhanced search)
```

---

## 🆘 Troubleshooting

### "Missing DATABASE_URL"
- Ensure DATABASE_URL is set in Railway variables
- Or set individual DB_* variables
- Verify Supabase connection string format

### "Invalid JWT token"
- Regenerate JWT_SECRET_KEY
- Ensure no trailing spaces in variable value
- Update in Railway and restart service

### "OpenAI API Error"
- Verify OPENAI_API_KEY is valid
- Check API key has credits/billing enabled
- Ensure no rate limits exceeded

### "Redis connection failed"
- Verify REDIS_URL format
- Check Railway Redis plugin is active
- Ensure Redis is accessible from Railway service

---

## 📚 Related Documentation

- [Deployment Guide](DEPLOYMENT_GUIDE.md) - Full deployment walkthrough
- [Supabase Setup](SUPABASE_SETUP.md) - Database configuration
- [CRM Agents](CRM_AGENTS.md) - Agent configuration details
- [Railway Docs](https://docs.railway.app) - Railway platform docs
- [Supabase Docs](https://supabase.com/docs) - Database docs

---

**Platform**: ISHE Group AI Platform v1.0  
**Last Updated**: November 2025  
**Environment**: Railway.com + Supabase
