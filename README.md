# PS-ServiceCommander
🚀 All-in-One Service Manager for Modern Development Stacks
A PowerShell-powered CLI to orchestrate Uvicorn servers, Celery workers, Redis instances, and more with single-command simplicity

#### Features Highlight
✅ Unified control for Uvicorn + Celery + Redis
✅ Built-in process management (stop_celery, stop_redis)
✅ Automatic virtual environment activation
✅ Production-ready service configurations
✅ Developer-friendly alias system (start-server)
✅ WSL Redis support

#### Key Technologies
🛠️ PowerShell Core | ⚡ Uvicorn | 🌿 Celery | 🧠 Redis | 🐍 Python

Ideal For

  - Full-stack developers working with async Python
  - DevOps engineers managing microservice workflows
  - Teams needing consistent environment management
  - Projects combining FastAPI + Celery + Redis stacks

## Permanent Alias Setup

### Create `start-server` Command Alias

1. **Check PowerShell Profile Existence**
   ```powershell
   Test-Path $PROFILE
2. **Create Profile if Missing**
   ```powershell
   New-Item -Path $PROFILE -ItemType File -Force
3. **Edit Profile Script**
   ```powershell
   # Open with Notepad:
   notepad $PROFILE

   # Or with VSCode:
   code $PROFILE
4. **Add Alias Configuration**
   ```powershell
   Set-Alias -Name Start-Server -Value 'script_directory(D:\work\start-server.ps1)'
5. **Reload Profile**
   ```powershell
   . $PROFILE

"Your one-command solution to launch, manage, and maintain development services"
