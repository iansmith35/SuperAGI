# 🚀 ISHE Group AI Platform - Quick Deployment Checklist

Use this checklist to deploy your ISHE Group AI Platform to Railway.com.

---

## ✅ Pre-Deployment Checklist

### 1. Accounts Setup
- [ ] Railway.com account created
- [ ] Supabase account created
- [ ] OpenAI API account with billing enabled
- [ ] GitHub repository access confirmed

### 2. Get API Keys & Credentials
- [ ] Railway API token obtained (https://railway.app/account/tokens)
- [ ] OpenAI API key obtained (https://platform.openai.com/api-keys)
- [ ] Google API key (optional, for search features)
- [ ] Generate JWT secret: `openssl rand -hex 32`
- [ ] Generate encryption key: `openssl rand -hex 16`

---

## 🗄️ Supabase Setup

### 3. Create Supabase Project
- [ ] Navigate to https://supabase.com/dashboard
- [ ] Click "New Project"
- [ ] Name: `ishe-group-ai`
- [ ] Generate and save database password
- [ ] Choose region (same as Railway for best performance)
- [ ] Wait for project creation (~2 min)

### 4. Get Supabase Connection Details
- [ ] Go to Settings → Database
- [ ] Copy connection string (URI format)
- [ ] Go to Settings → API
- [ ] Copy Project URL
- [ ] Copy service_role key (keep secret!)

**Save these values:**
```
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_KEY=[service-role-key]
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
```

---

## 🚂 Railway Deployment

### 5. Create Railway Project
- [ ] Go to https://railway.app/dashboard
- [ ] Click "New Project"
- [ ] Select "Deploy from GitHub repo"
- [ ] Choose `iansmith35/SuperAGI` repository
- [ ] Railway detects Dockerfile automatically

### 6. Add Railway Redis Plugin
- [ ] In Railway project, click "New"
- [ ] Select "Database" → "Redis"
- [ ] Railway auto-configures REDIS_URL

### 7. Configure Environment Variables

In Railway → Your Service → Variables, add:

#### Core Configuration
- [ ] `RAILWAY_TOKEN` = [your Railway API token]
- [ ] `ENVIRONMENT` = `production`
- [ ] `PORT` = `8080` (or leave for Railway auto-config)

#### Database (Supabase)
- [ ] `DATABASE_URL` = [Supabase connection string]
- [ ] `SUPABASE_URL` = [Supabase project URL]
- [ ] `SUPABASE_KEY` = [Supabase service role key]

#### Redis
- [ ] `REDIS_URL` = [Auto-provided by Railway Redis plugin]

#### AI Configuration
- [ ] `OPENAI_API_KEY` = [Your OpenAI key]
- [ ] `MODEL_NAME` = `gpt-3.5-turbo-0301`
- [ ] `OPENAI_API_BASE` = `https://api.openai.com/v1`

#### Security
- [ ] `JWT_SECRET_KEY` = [Generated with openssl rand -hex 32]
- [ ] `ENCRYPTION_KEY` = [Generated with openssl rand -hex 16]

#### Features
- [ ] `ENABLE_SUPABASE_MEMORY` = `True`
- [ ] `ENABLE_CHATBOT` = `True`
- [ ] `FRONTEND_URL` = `$RAILWAY_STATIC_URL` (or your custom domain)

#### Optional (for enhanced features)
- [ ] `GOOGLE_API_KEY` = [Google API key]
- [ ] `SERP_API_KEY` = [SerpAPI key]
- [ ] `SLACK_BOT_TOKEN` = [Slack bot token]
- [ ] `GITHUB_ACCESS_TOKEN` = [GitHub PAT]
- [ ] `STABILITY_API_KEY` = [Stability AI key]

### 8. Deploy
- [ ] Railway starts automatic deployment
- [ ] Monitor build logs in "Deployments" tab
- [ ] Wait for deployment to complete (~5-10 min)
- [ ] Verify deployment status shows "Active"

---

## 🧪 Post-Deployment Verification

### 9. Test Basic Functionality
- [ ] Get your Railway URL (Settings → Networking)
- [ ] Access URL in browser: `https://your-app.up.railway.app`
- [ ] Verify homepage loads
- [ ] Check health endpoint: `/health`

### 10. Verify Database Connection
- [ ] Check Railway logs for "Database connected"
- [ ] No error messages about database connection
- [ ] Migrations completed successfully

### 11. Verify Agents Created
- [ ] Navigate to agents dashboard
- [ ] Verify 11 CRM agents exist:
  - [ ] Marcus Williams (Sales)
  - [ ] Sarah Chen (Sales)
  - [ ] Rebecca Thompson (Support)
  - [ ] David Martinez (Support)
  - [ ] Emily Rodriguez (Marketing)
  - [ ] James Patterson (Marketing)
  - [ ] Olivia Johnson (Operations)
  - [ ] Ryan Cooper (Operations)
  - [ ] Victoria Adams (Finance)
  - [ ] Michael Brown (HR)
  - [ ] Alexandra Grant (Executive)

### 12. Test Agent Functionality
- [ ] Select one agent (e.g., Marcus Williams)
- [ ] Assign a test task
- [ ] Verify agent executes task
- [ ] Check agent memory persistence
- [ ] Review execution logs

---

## 🔧 Optional Configuration

### 13. Custom Domain (Optional)
- [ ] In Railway: Settings → Networking → Custom Domain
- [ ] Add your domain
- [ ] Configure DNS records as instructed
- [ ] Update FRONTEND_URL environment variable

### 14. Enhanced Monitoring (Optional)
- [ ] Set up Supabase logging
- [ ] Configure Railway metrics alerts
- [ ] Enable OpenAI usage tracking
- [ ] Set billing alerts

### 15. Backup Strategy (Optional)
- [ ] Enable Supabase automatic backups
- [ ] Document backup restoration process
- [ ] Test backup/restore procedure
- [ ] Schedule regular backup verification

---

## 🔒 Security Hardening

### 16. Review Security Settings
- [ ] Verify all secrets are in Railway environment (not in code)
- [ ] Enable Supabase Row Level Security (RLS)
- [ ] Review agent permissions
- [ ] Set up IP allowlisting (if needed)
- [ ] Configure CORS properly
- [ ] Enable rate limiting

### 17. Key Rotation Plan
- [ ] Document key rotation schedule
- [ ] Set calendar reminders for rotations
- [ ] Test key rotation process
- [ ] Have backup keys ready

---

## 📊 Monitoring & Maintenance

### 18. Set Up Monitoring
- [ ] Railway dashboard bookmarked
- [ ] Supabase dashboard bookmarked
- [ ] OpenAI usage dashboard access
- [ ] Slack/email alerts configured

### 19. Regular Maintenance Schedule
- [ ] Weekly: Review agent logs
- [ ] Weekly: Check error rates
- [ ] Monthly: Review API usage & costs
- [ ] Monthly: Update dependencies
- [ ] Quarterly: Rotate API keys
- [ ] Quarterly: Review agent performance

---

## 📚 Documentation Review

### 20. Team Onboarding
- [ ] Share DEPLOYMENT_GUIDE.md with team
- [ ] Review CRM_AGENTS.md configuration
- [ ] Understand ENV_VARS_REFERENCE.md
- [ ] Bookmark SUPABASE_SETUP.md
- [ ] Read SETUP_SUMMARY.md

---

## 🎉 Deployment Complete!

### Final Verification
- [ ] Platform accessible via Railway URL
- [ ] All 11 agents created and functional
- [ ] Database connected and migrations complete
- [ ] Redis connected
- [ ] No errors in Railway logs
- [ ] Test agent completed sample task successfully
- [ ] Supabase memory persistence working
- [ ] Team has access to platform
- [ ] Documentation reviewed
- [ ] Monitoring set up

### Celebrate! 🎊
Your ISHE Group AI Platform is now live and ready for production use!

---

## 🆘 Troubleshooting

If any step fails, refer to:
- **DEPLOYMENT_GUIDE.md** - Complete troubleshooting section
- **Railway logs** - Check for error messages
- **Supabase logs** - Verify database operations
- **ENV_VARS_REFERENCE.md** - Verify all variables set correctly

---

## 📞 Support Resources

- **Documentation**: All *.md files in repository root
- **Railway Support**: https://railway.app/help
- **Supabase Support**: https://supabase.com/docs
- **GitHub Issues**: Create issue in repository

---

**Platform**: ISHE Group AI Platform v1.0  
**Last Updated**: November 13, 2025  
**Status**: Ready for Deployment ✅
