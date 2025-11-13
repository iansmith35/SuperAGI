#!/bin/bash

# ISHE Group AI Platform - Google Integration Setup Script
# This script helps configure your environment for Google authentication and cloud services

set -e  # Exit on error

echo "=========================================="
echo "ISHE Group AI Platform Setup"
echo "Google Cloud & Authentication Configuration"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running in interactive mode
if [ -t 0 ]; then
    INTERACTIVE=true
else
    INTERACTIVE=false
fi

# Function to prompt for input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    local default="$3"
    
    if [ "$INTERACTIVE" = true ]; then
        read -p "$prompt [$default]: " input
        eval "$var_name=\"\${input:-$default}\""
    else
        eval "$var_name=\"$default\""
    fi
}

echo -e "${YELLOW}Step 1: Google Cloud Project Setup${NC}"
echo "Before continuing, ensure you have:"
echo "  1. Created a Google Cloud Project"
echo "  2. Enabled required APIs (Gmail, Calendar, Drive, etc.)"
echo "  3. Created OAuth 2.0 credentials"
echo "  4. Downloaded service account key (JSON)"
echo ""
echo "📖 See GOOGLE_INTEGRATION_GUIDE.md for detailed instructions"
echo ""

if [ "$INTERACTIVE" = true ]; then
    read -p "Have you completed the Google Cloud setup? (yes/no): " setup_done
    if [ "$setup_done" != "yes" ]; then
        echo -e "${RED}Please complete Google Cloud setup first!${NC}"
        echo "Refer to: GOOGLE_INTEGRATION_GUIDE.md"
        exit 1
    fi
fi

echo ""
echo -e "${YELLOW}Step 2: Google OAuth Credentials${NC}"
echo "Enter your Google OAuth credentials from Google Cloud Console"
echo ""

# Prompt for Google OAuth credentials
prompt_input "Google Client ID" GOOGLE_CLIENT_ID ""
prompt_input "Google Client Secret" GOOGLE_CLIENT_SECRET ""
prompt_input "Google Project ID" GOOGLE_CLOUD_PROJECT_ID ""
prompt_input "Frontend URL" FRONTEND_URL "http://localhost:3000"

# Validate inputs
if [ -z "$GOOGLE_CLIENT_ID" ] || [ -z "$GOOGLE_CLIENT_SECRET" ]; then
    echo -e "${RED}Error: Google OAuth credentials are required!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Step 3: Database Configuration${NC}"
prompt_input "Database Name" DB_NAME "ishe_group_db"
prompt_input "Database Host" DB_HOST "localhost"
prompt_input "Database Username" DB_USERNAME "postgres"
prompt_input "Database Password" DB_PASSWORD "password"

echo ""
echo -e "${YELLOW}Step 4: Security Keys${NC}"
echo "Generating secure keys..."

# Generate JWT secret if not provided
JWT_SECRET_KEY=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
ENCRYPTION_KEY=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)

echo -e "${GREEN}✓ JWT Secret Key generated${NC}"
echo -e "${GREEN}✓ Encryption Key generated${NC}"

echo ""
echo -e "${YELLOW}Step 5: Service Account Key${NC}"
if [ "$INTERACTIVE" = true ]; then
    read -p "Path to Google service account JSON key: " SERVICE_ACCOUNT_PATH
    
    if [ -f "$SERVICE_ACCOUNT_PATH" ]; then
        # Create credentials directory
        mkdir -p ./credentials
        cp "$SERVICE_ACCOUNT_PATH" ./credentials/google-cloud-key.json
        chmod 600 ./credentials/google-cloud-key.json
        echo -e "${GREEN}✓ Service account key copied to ./credentials/${NC}"
    else
        echo -e "${YELLOW}⚠ Service account key not found. You'll need to add it manually.${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}Step 6: Creating Configuration File${NC}"

# Create config.yaml
cat > config.yaml << EOF
#####################------------------GOOGLE INTEGRATION-------------------------########################
# Primary Authentication via Google OAuth
GOOGLE_CLIENT_ID: $GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET: $GOOGLE_CLIENT_SECRET
GOOGLE_REDIRECT_URI: "$FRONTEND_URL/api/google/oauth-callback"

# Google Cloud Platform
GOOGLE_CLOUD_PROJECT_ID: $GOOGLE_CLOUD_PROJECT_ID
GOOGLE_APPLICATION_CREDENTIALS: ./credentials/google-cloud-key.json

#####################------------------SYSTEM CONFIGURATION-------------------------########################

# Application Settings
ENV: 'DEV'
FRONTEND_URL: "$FRONTEND_URL"

# Database Configuration
DB_NAME: $DB_NAME
DB_HOST: $DB_HOST
DB_USERNAME: $DB_USERNAME
DB_PASSWORD: $DB_PASSWORD
DB_URL: postgresql://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:5432/$DB_NAME

# Redis
REDIS_URL: "localhost:6379"

# Security
JWT_SECRET_KEY: '$JWT_SECRET_KEY'
ENCRYPTION_KEY: '$ENCRYPTION_KEY'
expiry_time_hours: 24

# Storage
STORAGE_TYPE: "FILE"
TOOLS_DIR: "superagi/tools"
RESOURCES_INPUT_ROOT_DIR: workspace/input/{agent_id}
RESOURCES_OUTPUT_ROOT_DIR: workspace/output/{agent_id}/{agent_execution_id}

# Vector Database
WEAVIATE_USE_EMBEDDED: true

#####################------------------AI MODELS-------------------------########################

# OpenAI Configuration (Optional - add your keys)
OPENAI_API_KEY: YOUR_OPENAI_API_KEY
OPENAI_API_BASE: https://api.openai.com/v1
MODEL_NAME: "gpt-3.5-turbo"
RESOURCES_SUMMARY_MODEL_NAME: "gpt-3.5-turbo"
MAX_TOOL_TOKEN_LIMIT: 800
MAX_MODEL_TOKEN_LIMIT: 4032

# Google PaLM (Optional)
PALM_API_KEY: YOUR_PALM_API_KEY

#####################------------------GOOGLE APIS-------------------------########################

# Google Search (Optional)
GOOGLE_API_KEY: YOUR_GOOGLE_API_KEY
SEARCH_ENGINE_ID: YOUR_SEARCH_ENGINE_ID

# Alternative: Serper.dev
SERP_API_KEY: YOUR_SERPER_API_KEY

#####################------------------EMAIL INTEGRATION-------------------------########################

# Gmail OAuth is automatically configured via Google OAuth
# Additional email settings (if using non-Gmail)
EMAIL_SMTP_HOST: smtp.gmail.com
EMAIL_SMTP_PORT: 587
EMAIL_IMAP_SERVER: imap.gmail.com
EMAIL_SIGNATURE: Sent via ISHE Group AI Platform

#####################------------------ADDITIONAL INTEGRATIONS-------------------------########################

# GitHub
GITHUB_USERNAME: YOUR_GITHUB_USERNAME
GITHUB_ACCESS_TOKEN: YOUR_GITHUB_ACCESS_TOKEN

# Jira
JIRA_INSTANCE_URL: YOUR_JIRA_INSTANCE_URL
JIRA_USERNAME: YOUR_JIRA_EMAIL
JIRA_API_TOKEN: YOUR_JIRA_API_TOKEN

# Slack
SLACK_BOT_TOKEN: YOUR_SLACK_BOT_TOKEN

# Stability AI
STABILITY_API_KEY: YOUR_STABILITY_API_KEY
ENGINE_ID: "stable-diffusion-xl-beta-v2-2-2"
EOF

echo -e "${GREEN}✓ Configuration file created: config.yaml${NC}"

# Create .env file for convenience
cat > .env << EOF
GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET
GOOGLE_CLOUD_PROJECT_ID=$GOOGLE_CLOUD_PROJECT_ID
FRONTEND_URL=$FRONTEND_URL
DB_NAME=$DB_NAME
DB_HOST=$DB_HOST
DB_USERNAME=$DB_USERNAME
DB_PASSWORD=$DB_PASSWORD
JWT_SECRET_KEY=$JWT_SECRET_KEY
ENCRYPTION_KEY=$ENCRYPTION_KEY
EOF

echo -e "${GREEN}✓ Environment file created: .env${NC}"

echo ""
echo -e "${GREEN}=========================================="
echo "✓ Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Review and update config.yaml with your API keys"
echo "  2. Ensure Google service account key is in ./credentials/google-cloud-key.json"
echo "  3. Update OAuth redirect URIs in Google Cloud Console:"
echo "     - $FRONTEND_URL/api/google/oauth-callback"
echo "  4. Start the application:"
echo "     - Backend: uvicorn main:app --host 0.0.0.0 --port 8001 --reload"
echo "     - Frontend: cd gui && npm install && npm run dev"
echo ""
echo "📖 Documentation:"
echo "  - Google Integration: GOOGLE_INTEGRATION_GUIDE.md"
echo "  - Railway Deployment: RAILWAY_DEPLOY.md"
echo ""
echo -e "${YELLOW}⚠ Security Reminder:${NC}"
echo "  - Never commit config.yaml or .env to version control"
echo "  - Keep your service account key secure"
echo "  - Use strong, unique passwords"
echo ""
