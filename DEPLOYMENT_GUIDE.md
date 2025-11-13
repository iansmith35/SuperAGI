# ISHE Group AI Platform - Complete Deployment Guide

## 🚀 Quick Start: Railway Deployment

This guide will help you deploy the ISHE Group AI Platform to Railway.com with Supabase integration in under 15 minutes.

---

## Prerequisites

Before you begin, ensure you have:

1. ✅ A [Railway.com](https://railway.app) account
2. ✅ A [Supabase](https://supabase.com) account
3. ✅ An [OpenAI API key](https://platform.openai.com/api-keys)
4. ✅ A GitHub account (for repository deployment)

---

## Step 1: Prepare Supabase

### 1.1 Create Supabase Project

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click **"New Project"**
3. Fill in:
   - **Name**: `ishe-group-ai`
   - **Database Password**: Generate a strong password (save it!)
   - **Region**: Choose closest to your location
4. Wait 2 minutes for project initialization

### 1.2 Get Connection Details

1. Go to **Settings → Database**
2. Copy the **Connection string** (URI format):
   ```
   postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```
3. Save this - you'll need it for Railway

4. Go to **Settings → API**
5. Copy:
   - **Project URL**: `https://[PROJECT-REF].supabase.co`
   - **service_role key** (secret key - keep it safe!)

📝 **Note**: Replace `[PASSWORD]` with your actual database password in the connection string.

---

## Step 2: Deploy to Railway

### 2.1 Fork or Clone Repository

1. Go to your repository: `https://github.com/iansmith35/SuperAGI`
2. Ensure all changes are committed (this guide assumes you're ready to deploy)

### 2.2 Create Railway Project

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your `SuperAGI` repository
5. Railway will detect the `Dockerfile` automatically

### 2.3 Add Railway Plugins

#### Add PostgreSQL Plugin (Optional - if not using Supabase for main DB)
1. In your Railway project, click **"New"**
2. Select **"Database" → "PostgreSQL"**
3. Railway will auto-provision and set `DATABASE_URL`

#### Add Redis Plugin (Required)
1. Click **"New"** again
2. Select **"Database" → "Redis"**
3. Railway will auto-provision and set `REDIS_URL`

### 2.4 Configure Environment Variables

1. In your Railway project, go to your service
2. Click **"Variables"** tab
3. Add the following variables:

```bash
# ===== RAILWAY TOKEN =====
RAILWAY_TOKEN=your_railway_api_token
# Get from: https://railway.app/account/tokens

# ===== SUPABASE CONFIGURATION =====
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_KEY=your_service_role_key_here
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

# ===== REDIS =====
# Automatically set by Railway Redis plugin
# Or set manually: redis://default:[PASSWORD]@[HOST]:[PORT]

# ===== AI CONFIGURATION =====
OPENAI_API_KEY=sk-...your-openai-api-key
MODEL_NAME=gpt-3.5-turbo-0301
OPENAI_API_BASE=https://api.openai.com/v1

# ===== SECURITY =====
JWT_SECRET_KEY=generate_random_32_char_string_here
ENCRYPTION_KEY=exactly_32_characters_required
# Generate with: openssl rand -hex 16

# ===== APPLICATION SETTINGS =====
ENVIRONMENT=production
PORT=8080
ENABLE_SUPABASE_MEMORY=True
ENABLE_CHATBOT=True

# ===== FRONTEND =====
# Railway auto-provides this, or set manually:
FRONTEND_URL=$RAILWAY_PUBLIC_DOMAIN
```

#### How to Generate Secure Keys:

**JWT Secret Key:**
```bash
openssl rand -hex 32
```

**Encryption Key (must be exactly 32 characters):**
```bash
openssl rand -hex 16
```

### 2.5 Deploy

1. Railway will automatically start deploying
2. Monitor the build logs in the **"Deployments"** tab
3. Wait for deployment to complete (~5-10 minutes)

---

## Step 3: Initialize Database & Agents

Once deployed, Railway will automatically run:
1. Database migrations (via `scripts/railway_release.sh`)
2. CRM agent initialization

To manually initialize agents:

```bash
# Connect to Railway shell
railway run bash

# Run agent initialization
python3 scripts/initialize_crm_agents.py
```

---

## Step 4: Access Your Platform

### 4.1 Get Your URL

1. In Railway project, click on your service
2. Go to **"Settings"** tab
3. Under **"Networking"**, you'll see your public domain:
   ```
   https://your-app.up.railway.app
   ```

### 4.2 First Login

1. Navigate to your Railway URL
2. The platform should be running!
3. Create your admin account

---

## Step 5: Configure CRM Agents

### 5.1 Access Agent Dashboard

Navigate to: `https://your-app.up.railway.app/dashboard/agents`

### 5.2 Verify Agents Created

You should see 11 CRM agents:

**Sales Department:**
- Marcus Williams (Sales Director)
- Sarah Chen (Sales Representative)

**Customer Support:**
- Rebecca Thompson (Support Manager)
- David Martinez (Technical Support)

**Marketing:**
- Emily Rodriguez (Marketing Director)
- James Patterson (Content Creator)

**Operations:**
- Olivia Johnson (Operations Manager)
- Ryan Cooper (Data Analyst)

**Finance:**
- Victoria Adams (Finance Manager)

**HR:**
- Michael Brown (HR Manager)

**Executive:**
- Alexandra Grant (Executive Assistant)

### 5.3 Customize Agents

For each agent, you can configure:
- Goals and objectives
- Available tools
- Autonomy level
- Memory settings
- Constraints

---

## Step 6: Optional Configurations

### 6.1 Enable Additional Tools

Add API keys for more functionality:

```bash
# Google Services
GOOGLE_API_KEY=your_google_api_key
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret

# Search
SERP_API_KEY=your_serp_api_key

# Social Media
SLACK_BOT_TOKEN=xoxb-your-slack-token

# Development
GITHUB_ACCESS_TOKEN=ghp_your_github_token
JIRA_API_TOKEN=your_jira_token

# Image Generation
STABILITY_API_KEY=sk-your-stability-key
```

### 6.2 Custom Domain

1. In Railway, go to **Settings → Networking**
2. Click **"Generate Domain"** or **"Custom Domain"**
3. Follow instructions to add your domain

### 6.3 Set Up Monitoring

Railway provides automatic monitoring:
- CPU usage
- Memory usage
- Request metrics
- Error logs

Access via: Railway Dashboard → Your Service → Metrics

---

## Step 7: Verify Everything Works

### 7.1 Health Check

Test the API:
```bash
curl https://your-app.up.railway.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "database": "connected",
  "redis": "connected"
}
```

### 7.2 Test Agent

1. Go to Agents dashboard
2. Select "Marcus Williams"
3. Give him a task: "Research 5 potential leads in the tech industry"
4. Watch him work autonomously!

---

## Troubleshooting

### Build Fails

**Problem**: Docker build fails
**Solution**: 
- Check Railway build logs
- Ensure Dockerfile is present
- Verify requirements.txt has all dependencies

### Database Connection Error

**Problem**: Can't connect to Supabase
**Solution**:
- Verify DATABASE_URL is correct
- Check Supabase project is active
- Ensure password doesn't have special characters (URL encode if needed)

### Redis Connection Error

**Problem**: Redis connection fails
**Solution**:
- Verify REDIS_URL is set
- Check Railway Redis plugin is active
- Format: `redis://default:[PASSWORD]@[HOST]:[PORT]`

### Migration Errors

**Problem**: Alembic migrations fail
**Solution**:
```bash
# Connect to Railway
railway run bash

# Run migrations manually
python3 scripts/run_migrations.py
```

### Agents Not Created

**Problem**: CRM agents don't appear
**Solution**:
```bash
# Run initialization script manually
railway run python3 scripts/initialize_crm_agents.py
```

---

## Maintenance & Updates

### Update Environment Variables

1. Railway Dashboard → Your Service → Variables
2. Add/modify variables
3. Railway will auto-redeploy

### Manual Deployment

```bash
# Using Railway CLI
railway up

# Or push to GitHub
git push origin main
# Railway will auto-deploy
```

### View Logs

```bash
# Using Railway CLI
railway logs

# Or in Dashboard
Railway → Your Service → Deployments → View Logs
```

### Database Backups

Supabase automatically backs up your database:
- Point-in-time recovery: 7 days (Pro plan)
- Daily backups: Available in Settings

---

## Cost Estimate

### Railway (Hobby Plan - $5/month)
- Free $5 credit included
- ~$0.000463/GB egress
- ~$0.001/minute for compute

### Supabase (Free Tier)
- 500 MB database
- 1 GB file storage
- 50,000 monthly active users
- Upgrade to Pro ($25/mo) for production

### OpenAI API
- GPT-3.5-turbo: ~$0.002/1K tokens
- Estimated: $20-50/month depending on usage

**Total Estimated**: ~$30-80/month

---

## Production Checklist

- [ ] Set strong JWT_SECRET_KEY
- [ ] Enable Supabase Row Level Security
- [ ] Configure custom domain
- [ ] Set up error monitoring
- [ ] Enable database backups
- [ ] Review agent permissions
- [ ] Configure rate limiting
- [ ] Set up logging/analytics
- [ ] Test all CRM agents
- [ ] Train team on platform usage

---

## Security Best Practices

1. **Never commit secrets** - Use Railway environment variables
2. **Rotate keys regularly** - Update API keys quarterly
3. **Enable RLS** - Row Level Security on Supabase
4. **Monitor usage** - Watch for unusual activity
5. **Backup data** - Regular Supabase backups
6. **Use HTTPS** - Railway provides SSL automatically
7. **Audit logs** - Review agent actions regularly

---

## Support & Resources

- **Documentation**: See `SUPABASE_SETUP.md` and `CRM_AGENTS.md`
- **Railway Docs**: https://docs.railway.app
- **Supabase Docs**: https://supabase.com/docs
- **Issues**: Create issue in GitHub repository

---

## Success! 🎉

Your ISHE Group AI Platform is now live with:
- ✅ 11 autonomous CRM agents
- ✅ Persistent Supabase memory
- ✅ Scalable Railway deployment
- ✅ Ready for production use

**Next Steps:**
1. Customize agent goals for your business
2. Integrate with your existing CRM
3. Train your team on agent usage
4. Monitor performance and optimize

---

**Platform**: ISHE Group AI Platform v1.0  
**Last Updated**: November 2025  
**Deployment Target**: Railway.com + Supabase
