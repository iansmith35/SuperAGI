<p align="center">
  <h1 align="center">ISHE Group AI Platform</h1>
</p>

<p align="center"><i>Enterprise AI Agent Platform - Powered by Google Cloud & Workspace Integration</i></p>
    

<p align="center">
<a href="https://github.com/iansmith35/SuperAGI" target="blank">
<img src="https://img.shields.io/github/forks/iansmith35/SuperAGI?style=for-the-badge" alt="ISHE Group forks"/>
</a>
<a href="https://github.com/iansmith35/SuperAGI/stargazers" target="blank">
<img src="https://img.shields.io/github/stars/iansmith35/SuperAGI?style=for-the-badge" alt="ISHE Group stars"/>
</a>
</p>

<p align="center"><b>🔐 Secure Google Authentication | ☁️ Google Cloud Native | 🔗 Full Workspace Integration</b></p>

---

## 🚀 Quick Start

Get started in 5 minutes with Google authentication:

```bash
# 1. Clone the repository
git clone https://github.com/iansmith35/SuperAGI.git
cd SuperAGI

# 2. Run automated setup
./setup_google_auth.sh

# 3. Start the platform
docker-compose up
```

**📖 Full Guide**: [QUICK_START.md](QUICK_START.md)

## ✨ Key Features

### 🔐 Google OAuth Authentication
- **One-click sign-in** with your Google account
- No password management required
- Secure OAuth 2.0 implementation
- Auto-sync with Google profile

### ☁️ Google Cloud Integration
- **Gmail API**: Send, receive, and manage emails
- **Google Calendar**: Schedule and manage events
- **Google Drive**: Store and share files
- **Cloud Storage**: Scalable file storage
- **Cloud Run**: Serverless deployment ready

### 🤖 AI Agent Platform
- Build and deploy autonomous AI agents
- Multi-model support (OpenAI, Google PaLM, etc.)
- Tool integration and workflow automation
- Resource management and execution tracking

### 🔧 Enterprise Ready
- PostgreSQL & Redis support
- Docker containerization
- Railway.app deployment ready
- Comprehensive logging and monitoring

## 📋 Prerequisites

- **Google Account** (Gmail)
- **Google Cloud Platform** account ([free tier](https://cloud.google.com/free))
- Docker & Docker Compose OR Python 3.10+
- Node.js 16+ (for frontend)

## 🎯 Setup Google Authentication

### Step 1: Google Cloud Console Setup

1. **Create a Project** in [Google Cloud Console](https://console.cloud.google.com)
2. **Enable APIs**:
   - Google+ API
   - Gmail API
   - Google Calendar API
   - Google Drive API
3. **Create OAuth 2.0 Credentials**:
   - Application type: Web application
   - Authorized redirect URIs: `http://localhost:3000/api/google/oauth-callback`
4. **Download credentials** (Client ID & Secret)

**📖 Detailed Guide**: [GOOGLE_INTEGRATION_GUIDE.md](GOOGLE_INTEGRATION_GUIDE.md)

### Step 2: Configure Application

Run the automated setup:

```bash
./setup_google_auth.sh
```

Or manually edit `config.yaml`:

```yaml
GOOGLE_CLIENT_ID: your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET: your-client-secret
GOOGLE_REDIRECT_URI: "http://localhost:3000/api/google/oauth-callback"
```

### Step 3: Launch Platform

```bash
# Option 1: Docker (Recommended)
docker-compose up

# Option 2: Manual
# Terminal 1: Backend
uvicorn main:app --host 0.0.0.0 --port 8001 --reload

# Terminal 2: Frontend
cd gui && npm install && npm run dev
```

### Step 4: Sign In

1. Open `http://localhost:3000`
2. Click **"Sign in with Google"**
3. Authorize with your Google account
4. Start building! 🎉

## 🌟 What You Get

### Out-of-the-Box Integrations

| Service | Features |
|---------|----------|
| **Gmail** | Send/receive emails, search, drafts, labels |
| **Calendar** | View/create events, check availability, invitations |
| **Drive** | Upload/download files, sharing, search |
| **Cloud Storage** | Scalable file storage, CDN integration |
| **OAuth** | Secure authentication, no password management |

### Platform Capabilities

- 🤖 **AI Agents**: Create autonomous agents for any task
- 🔄 **Workflows**: Build complex automation pipelines
- 📊 **Analytics**: Track performance and metrics
- 🛠️ **Tools**: Extensible toolkit system
- 📁 **Resources**: Manage files and data
- 👥 **Multi-user**: Organization and project management

## 🚀 Deployment

### Deploy to Railway (Recommended)

```bash
# 1. Push to GitHub
git push origin main

# 2. Connect to Railway.app
# 3. Add PostgreSQL and Redis services
# 4. Configure environment variables
```

**📖 Deployment Guide**: [RAILWAY_DEPLOY.md](RAILWAY_DEPLOY.md)

### Google Cloud Run Deployment

```bash
# Build and deploy
gcloud run deploy ishe-group-platform \
  --source . \
  --region us-central1 \
  --allow-unauthenticated
```

## 📚 Documentation

- **[🚀 Quick Start Guide](QUICK_START.md)** - Get up and running in minutes
- **[🔐 Google Integration Guide](GOOGLE_INTEGRATION_GUIDE.md)** - Complete Google setup
- **[☁️ Railway Deployment](RAILWAY_DEPLOY.md)** - Production deployment
- **[⚙️ Configuration](config_template.yaml)** - Environment settings

## 🔒 Security

- ✅ OAuth 2.0 secure authentication
- ✅ JWT token-based sessions
- ✅ Encrypted credentials storage
- ✅ Environment-based configuration
- ✅ No passwords stored
- ✅ Google's security infrastructure

**Important**: Never commit `config.yaml`, `.env`, or service account keys to version control.

## 🛠️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    ISHE Group Platform                   │
├─────────────────────────────────────────────────────────┤
│  Frontend (Next.js)                                     │
│  ├─ Google OAuth Sign-In                                │
│  ├─ Agent Management UI                                 │
│  └─ Resource Dashboard                                  │
├─────────────────────────────────────────────────────────┤
│  Backend (FastAPI)                                      │
│  ├─ Google OAuth Controller                             │
│  ├─ Agent Execution Engine                              │
│  ├─ Tool Manager                                        │
│  └─ API Routes                                          │
├─────────────────────────────────────────────────────────┤
│  Google Cloud Services                                  │
│  ├─ OAuth 2.0 Authentication                            │
│  ├─ Gmail API                                           │
│  ├─ Calendar API                                        │
│  ├─ Drive API                                           │
│  └─ Cloud Storage                                       │
├─────────────────────────────────────────────────────────┤
│  Data Layer                                             │
│  ├─ PostgreSQL (User data, agents, workflows)          │
│  ├─ Redis (Caching, task queue)                        │
│  └─ Vector DB (Embeddings, knowledge base)             │
└─────────────────────────────────────────────────────────┘
```

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check our comprehensive guides
- **Issues**: [GitHub Issues](https://github.com/iansmith35/SuperAGI/issues)
- **Discussions**: [GitHub Discussions](https://github.com/iansmith35/SuperAGI/discussions)

## 🙏 Acknowledgments

Built on the foundation of SuperAGI, enhanced with enterprise Google Cloud integration for seamless authentication and workspace connectivity.

---

<p align="center">
  <b>🔐 Sign in with Google | ☁️ Deploy to Cloud | 🤖 Build AI Agents</b>
</p>

<p align="center">
  Made with ❤️ by ISHE Group
</p>

<p align="center"><b>Share SuperAGI Repository</b></p>

<p align="center">

<a href="https://twitter.com/intent/tweet?text=Check%20this%20GitHub%20repository%20out.%20SuperAGI%20-%20Let%27s%20you%20easily%20build,%20manage%20and%20run%20useful%20autonomous%20AI%20agents.&url=https://github.com/TransformerOptimus/SuperAGI&hashtags=SuperAGI,AGI,Autonomics,future" target="blank">
<img src="https://img.shields.io/twitter/follow/_superAGI?label=Share Repo on Twitter&style=social" alt="Follow _superAGI"/></a> 
<a href="https://t.me/share/url?text=Check%20this%20GitHub%20repository%20out.%20SuperAGI%20-%20Let%27s%20you%20easily%20build,%20manage%20and%20run%20useful%20autonomous%20AI%20agents.&url=https://github.com/TransformerOptimus/SuperAGI" target="_blank"><img src="https://img.shields.io/twitter/url?label=Telegram&logo=Telegram&style=social&url=https://github.com/TransformerOptimus/SuperAGI" alt="Share on Telegram"/></a>
<a href="https://api.whatsapp.com/send?text=Check%20this%20GitHub%20repository%20out.%20SuperAGI%20-%20Let's%20you%20easily%20build,%20manage%20and%20run%20useful%20autonomous%20AI%20agents.%20https://github.com/TransformerOptimus/SuperAGI"><img src="https://img.shields.io/twitter/url?label=whatsapp&logo=whatsapp&style=social&url=https://github.com/TransformerOptimus/SuperAGI" /></a> <a href="https://www.reddit.com/submit?url=https://github.com/TransformerOptimus/SuperAGI&title=Check%20this%20GitHub%20repository%20out.%20SuperAGI%20-%20Let's%20you%20easily%20build,%20manage%20and%20run%20useful%20autonomous%20AI%20agents.
" target="blank">
<img src="https://img.shields.io/twitter/url?label=Reddit&logo=Reddit&style=social&url=https://github.com/TransformerOptimus/SuperAGI" alt="Share on Reddit"/>
</a> <a href="mailto:?subject=Check%20this%20GitHub%20repository%20out.&body=SuperAGI%20-%20Let%27s%20you%20easily%20build,%20manage%20and%20run%20useful%20autonomous%20AI%20agents.%3A%0Ahttps://github.com/TransformerOptimus/SuperAGI" target="_blank"><img src="https://img.shields.io/twitter/url?label=Gmail&logo=Gmail&style=social&url=https://github.com/TransformerOptimus/SuperAGI"/></a> <a href="https://www.buymeacoffee.com/superagi" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="23" width="100" style="border-radius:1px"></a>

</p>

<hr>

## What are we ?

A dev-first open source autonomous AI agent framework enabling developers to build, manage & run useful autonomous agents. You can run concurrent agents seamlessly, extend agent capabilities with tools. The agents efficiently perform a variety of tasks and continually improve their performance with each subsequent run.


### 💡 Features

- <b>Provision, Spawn & Deploy Autonomous AI Agents</b> - Create production-ready & scalable autonomous agents.
- <b>Extend Agent Capabilities with Toolkits</b> - Add Toolkits from our marketplace to your agent workflows.
- <b>Graphical User Interface</b> - Access your agents through a graphical user interface.
- <b>Action Console</b> - Interact with agents by giving them input and permissions.
- <b>Multiple Vector DBs</b> - Connect to multiple Vector DBs to enhance your agent’s performance.
- <b>Performance Telemetry</b> - Get insights into your agent’s performance and optimize accordingly.
- <b>Optimized Token Usage</b> - Control token usage to manage costs effectively.
- <b>Agent Memory Storage</b> - Enable your agents to learn and adapt by storing their memory.
- <b>Models</b> - Custom fine tuned models for business specific usecases.
- <b>Workflows</b> - Automate tasks with ease using ReAct LLM's predefined steps.

### 🛠 Toolkits
Toolkits allow SuperAGI Agents to interact with external systems and third-party plugins.

<a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Twitter.png height=50px width=50px alt="Twitter" valign="middle" title="Twitter"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Coding.png height=50px width=50px alt="Coding Tool" valign="middle" title="Coding Tool"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Insta.png height=50px width=50px alt="Instagram" valign="middle" title="Instagram"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Knowledge_tool.png height=50px width=50px alt="Knowledge Search" valign="middle" title="Knowledge Search"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113612.png height=50px width=50px alt="Email"  valign="middle" title="Email"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113610.png height=50px width=50px alt="Jira" valign="middle" title="Jira"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113611.png height=50px width=50px alt="File Manager" valign="middle" title="File Manager"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113613.png height=50px width=50px alt="Google Search" valign="middle" title="Google Search"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113615.png height=50px width=50px alt="Dall-E" valign="middle" title="Dall-E"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113614.png height=50px width=50px alt="Github" valign="middle" title="Github"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113616.png height=50px width=50px alt="Web Interaction" valign="middle" title="Web Interaction"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/05/Group-113622.png height=50px width=50px alt="Duckduckgo" valign="middle" title="Duckduckgo"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Calendar_tool.png height=50px width=50px alt="Google Calendar" valign="middle" title="Google Calendar"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Search_tool.png height=50px width=50px alt="Google Calendar" valign="middle" title="Google Search"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Serp.png height=50px width=50px alt="Serp API" valign="middle" title="Serp API"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Searx.png height=50px width=50px alt="Searx" valign="middle" title="Searx "></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Web_scraper_logo.png height=50px width=50px alt="Web Scraper" valign="middle" title="Web Scraper"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Notion_logo.png height=50px width=50px alt="Notion" valign="middle" title="Notion"></a> <a href="https://marketplace.superagi.com/" target="_blank"><img src=https://superagi.com/wp-content/uploads/2023/08/Apollo_logo.png height=50px width=50px alt="Apollo" valign="middle" title="Apollo"></a>

### ⚙️ Installation

You can install superAGI using one of the following three approaches.

#### ☁️ SuperAGI cloud

To quickly start experimenting with agents without the hassle of setting up the system, try [Superagi Cloud](https://app.superagi.com/)

1. Visit [Superagi Cloud](https://app.superagi.com/) and log in using your github account.

2. In your account settings, go to "Model Providers" and add your API key.

You're all set! Start running your agents effortlessly.

#### 🖥️ Local

1. Open your terminal and clone the SuperAGI repository.
```
git clone https://github.com/TransformerOptimus/SuperAGI.git 
```

2. Navigate to the cloned repository directory using the command:
```
cd SuperAGI
```
3. Create a copy of config_template.yaml, and name it config.yaml.

4. Ensure that Docker is installed on your system. You can download and install it from [here](https://docs.docker.com/get-docker/).

5. Once you have Docker Desktop running, run the following command in the SuperAGI directory:

   a. For regular usage:
      ```
      docker compose -f docker-compose.yaml up --build
      ```

   b. If you want to use SuperAGI with Local LLMs and have GPU, run the following command:
      ```
      docker compose -f docker-compose-gpu.yml up --build
      ```


6. Open your web browser and navigate to http://localhost:3000 to access SuperAGI.

#### 🌀 Digital Ocean

<p align="left">
<a href="https://cloud.digitalocean.com/apps/new?repo=https://github.com/TransformerOptimus/SuperAGI/tree/main"> <img src="https://www.deploytodo.com/do-btn-blue.svg"></a><br>Deploy SuperAGI to DigitalOcean with one click.
</p>

<a id="architecture">

### 🌐 Architecture
</a>
<details>
<summary>SuperAGI Architecture</summary>

![SuperAGI Architecture](https://superagi.com/wp-content/uploads/2023/09/SuperAGI-Architecture.png)
</details>

<details>
<summary>Agent Architecture</summary>

![Agent Architecture](https://superagi.com/wp-content/uploads/2023/06/Agent-Architecture.png)
</details>

<details>
<summary>Agent Workflow Architecture</summary>

![Agent Workflow Architecture](https://superagi.com/wp-content/uploads/2023/09/Workflow-Architecture.png)
</details>

<details>
<summary>Tools Architecture</summary>

![Tools Architecture](https://superagi.com/wp-content/uploads/2023/09/Tools-Architecture.png)
</details>

<details>
<summary>ER Diagram</summary>

![ER Diagram](https://superagi.com/wp-content/uploads/2023/09/ER-Diagram.png)
</details>

### 📚 Resources

* [Documentation](https://superagi.com/docs/)
* [YouTube Channel](https://www.youtube.com/@_SuperAGI/videos)


### 📖 Need Help?

Join our [Discord community](https://discord.gg/dXbRe5BHJC) for support and discussions.

[![Join us on Discord](https://invidget.switchblade.xyz/uJ3XUGsY2R)](https://discord.gg/uJ3XUGsY2R)

If you have questions or encounter issues, please don't hesitate to [create a new issue](https://github.com/TransformerOptimus/SuperAGI/issues/new/choose) to get support.

### 💻 Contribution
We ❤️ our contributors. We’re committed to fostering an open, welcoming, and safe environment in the community.

If you'd like to contribute, start by reading our [Contribution Guide](https://github.com/TransformerOptimus/SuperAGI/blob/main/CONTRIBUTING.md).

We expect everyone participating in the community to abide by our [Code of Conduct](https://github.com/TransformerOptimus/SuperAGI/blob/main/CODE_OF_CONDUCT.md).

To get more idea on where we are heading, checkout our roadmap [here](https://github.com/users/TransformerOptimus/projects/5/views/1).

Explore some [good first issues](https://github.com/TransformerOptimus/SuperAGI/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) to start contributing.

### 👩‍💻 Contributors
[![TransformerOptimus](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/133493246?v=4&w=50&h=50&mask=circle)](https://github.com/TransformerOptimus) [![Cptsnowcrasher](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/133322218?v=4&w=50&h=50&mask=circle)](https://github.com/Cptsnowcrasher) [![vectorcrow](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/133646556?v=4&w=50&h=50&mask=circle)](https://github.com/vectorcrow) [![Akki-jain](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/92881074?v=4&w=50&h=50&mask=circle)](https://github.com/Akki-jain) [![Autocop-Agent](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/129729746?v=4&w=50&h=50&mask=circle)](https://github.com/Autocop-Agent)[![COLONAYUSH](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/60507126?v=4&w=50&h=50&mask=circle)](https://github.com/COLONAYUSH)[![luciferlinx101](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/129729795?v=4&w=50&h=50&mask=circle)](https://github.com/luciferlinx101)[![mukundans89](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/101278493?v=4&w=50&h=50&mask=circle)](https://github.com/mukundans89)[![Fluder-Paradyne](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/121793617?v=4&w=50&h=50&mask=circle)](https://github.com/Fluder-Paradyne)[![nborthy](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/101320057?v=4&w=50&h=50&mask=circle)](https://github.com/nborthy)[![nihirr](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/122777244?v=4&w=50&h=50&mask=circle)](https://github.com/nihirr)[![Tarraann](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/97586318?v=4&w=50&h=50&mask=circle)](https://github.com/Tarraann)[![neelayan7](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/43145646?v=4&w=50&h=50&mask=circle)](https://github.com/neelayan7)[![Arkajit-Datta](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/61142632?v=4&w=50&h=50&mask=circle)](https://github.com/Arkajit-Datta)[![guangchen811](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/103159823?v=4&w=50&h=50&mask=circle)](https://github.com/guangchen811)[![juanfpo96](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/14787156?v=4&w=50&h=50&mask=circle)](https://github.com/juanfpo96)[![iskandarreza](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/32027019?v=4&w=50&h=50&mask=circle)](https://github.com/iskandarreza)[![jpenalbae](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/8380459?v=4&w=50&h=50&mask=circle)](https://github.com/jpenalbae)[![pallasite99](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/26508636?v=4&w=50&h=50&mask=circle)](https://github.com/pallasite99)[![xutpuu](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/11964505?v=4&w=50&h=50&mask=circle)](https://github.com/xutpuu)[![alexkreidler](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/11166947?v=4&w=50&h=50&mask=circle)](https://github.com/alexkreidler)[![hanhyalex123](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/100895608?v=4&w=50&h=50&mask=circle)](https://github.com/hanhyalex123)[![ps4vs](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/91535358?v=4&w=50&h=50&mask=circle)](https://github.com/ps4vs)[![eltociear](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/22633385?v=4&w=50&h=50&mask=circle)](https://github.com/eltociear)
[![shaiss](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/113060?v=4&w=50&h=50&mask=circle)](https://github.com/shaiss)
[![AdityaRajSingh1992](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/105219157?v=4&w=50&h=50&mask=circle)](https://github.com/AdityaRajSingh1992)
[![namansleeps2](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/134390870?v=4&w=50&h=50&mask=circle)](https://github.com/namansleeps22)
[![sirajperson](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/396941?v=4&w=50&h=50&mask=circle)](https://github.com/sirajperson)
[![hsm207](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/2398765?v=4&w=50&h=50&mask=circle)](https://github.com/hsm207)
[![unkn-wn](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/43097991?v=4&w=50&h=50&mask=circle)](https://github.com/unkn-wn)
[![DMTarmey](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/590474?v=4&w=50&h=50&mask=circle)](https://github.com/DMTarmey)
[![Parth2506](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/122429822?v=4&w=50&h=50&mask=circle)](https://github.com/Parth2506)
[![platinaCoder](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/47349795?v=4&w=50&h=50&mask=circle)](https://github.com/platinaCoder)
[![anisha1607](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/60440541?v=4&w=50&h=50&mask=circle)](https://github.com/anisha1607)
[![jorgectf](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/46056498?v=4&w=50&h=50&mask=circle)](https://github.com/jorgectf)
[![PaulRBerg](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/8782666?v=4&w=50&h=50&mask=circle)](https://github.com/PaulRBerg)
[![boundless-asura](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/122777244?v=4&w=50&h=50&mask=circle)](https://github.com/boundless-asura)
[![JPDucky](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/34105363?v=4&w=50&h=50&mask=circle)](https://github.com/JPDucky)
[![Vibhusha22](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/128478691?v=4&w=50&h=50&mask=circle)](https://github.com/Vibhusha22)
[![ai-akuma](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/7444521?v=4&w=50&h=50&mask=circle)](https://github.com/ai-akuma)
[![rounak610](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/81288115?v=4&w=50&h=50&mask=circle)](https://github.com/rounak610)
[![AdarshJha619](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/53672264?v=4&w=50&h=50&mask=circle)](https://github.com/AdarshJha619)
[![ResoluteStoic](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/105219157?v=4&w=50&h=50&mask=circle)](https://github.com/ResoluteStoic)
[![JohnHunt999](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/137149331?v=4&w=50&h=50&mask=circle)](https://github.com/JohnHunt999)
[![Maverick-F35](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/138012351?v=4&w=50&h=50&mask=circle)](https://github.com/Maverick-F359)
[![jorgectf](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/46056498?v=4&w=50&h=50&mask=circle)](https://github.com/jorgectf)
[![AdityaSharma13064](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/138581531?v=4&w=50&h=50&mask=circle)](https://github.com/AdityaSharma13064)
[![lalitlj](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/138583454?v=4&w=50&h=50&mask=circle)](https://github.com/lalitlj)
[![andrew-kelly-neutralaiz](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/128111428?v=4&w=50&h=50&mask=circle)](https://github.com/andrew-kelly-neutralaiz)
[![sayan1101](https://images.weserv.nl/?url=https://avatars.githubusercontent.com/u/139119661?v=4&w=50&h=50&mask=circle)](https://github.com/sayan1101)


<p align="center"><a href="https://github.com/TransformerOptimus/SuperAGI#"><img src="https://superagi.com/wp-content/uploads/2023/05/backToTopButton.png" alt="Back to top" height="29"/></a></p>

### ⚠️ Under Development!
This project is under active development and may still have issues. We appreciate your understanding and patience. If you encounter any problems, please check the open issues first. If your issue is not listed, kindly create a new issue detailing the error or problem you experienced. Thank you for your support!
