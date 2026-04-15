# Environment Setup

Get your machine ready for the Terraform course. Target time: **15 minutes**.

## 1. Terraform >= 1.6

### Windows (WSL) / Linux (Ubuntu/Debian)

All commands below run inside your WSL terminal.

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```

### macOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Verify

```bash
terraform -version
# Expected: Terraform v1.x.x (>= 1.6)
```

## 2. Docker

You need a running Docker daemon, not just the binary.

### Windows (WSL)

1. Download and install **Docker Desktop** from https://www.docker.com/products/docker-desktop/
2. During installation, make sure **Use WSL 2 based engine** is checked.
3. Once installed, open Docker Desktop and go to **Settings > Resources > WSL Integration**.
4. Enable integration with your default WSL distribution (e.g. Ubuntu).
5. Click **Apply & restart**.
6. Open your WSL terminal and verify:

```bash
docker ps
# Expected: empty table, no errors
```

Docker Desktop handles the daemon — do not install Docker Engine inside WSL separately.

### macOS — Docker Desktop

```bash
brew install --cask docker
```

Open Docker Desktop from Applications, wait for the engine to start (whale icon in the menu bar stops animating).

### macOS — Colima (lightweight alternative)

```bash
brew install colima docker
colima start
```

Colima runs a Linux VM with Docker inside. No Docker Desktop license needed.

### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

Log out and back in for the group change to take effect, then verify:

```bash
docker ps
# Expected: empty table, no errors
```

## 3. Git

### macOS

```bash
# Already installed with Xcode CLI tools. Verify:
git --version

# If missing:
xcode-select --install
```

### Linux

```bash
sudo apt-get install -y git
```

## 4. VS Code + Terraform extension

### Windows (WSL)

1. Install **VS Code on Windows** (not inside WSL): download from https://code.visualstudio.com/ or via `winget`:

```powershell
# Run in PowerShell (Windows side)
winget install Microsoft.VisualStudioCode
```

2. Open VS Code and install the **WSL** extension (`ms-vscode-remote.remote-wsl`). This lets VS Code run its backend inside your WSL distribution while the UI stays on Windows.
3. From your WSL terminal, open any folder with:

```bash
code .
```

VS Code opens on Windows and connects to WSL automatically. The bottom-left corner shows **WSL: Ubuntu** (or your distribution name) — this confirms the connection is active.

4. Install the Terraform extension (from the WSL-connected VS Code):

```bash
code --install-extension hashicorp.terraform
```

All terminal, file access, and extensions run inside WSL. You edit in Windows, everything executes in Linux.

### macOS

```bash
brew install --cask visual-studio-code
code --install-extension hashicorp.terraform
```

### Linux

Install VS Code following https://code.visualstudio.com/docs/setup/linux, then:

```bash
code --install-extension hashicorp.terraform
```

The Terraform extension gives you syntax highlighting, autocompletion, and `terraform fmt` on save.

## 5. Clone the lab repo

```bash
git clone https://github.com/AbdelRany-Hammoumi/terraform-course-labs.git
cd terraform-course-labs
```

> Replace `<org>` with the GitHub organization provided by your instructor.

## 6. Validate your setup

```bash
cd setup/
./check-setup.sh
```

Expected output (all green):

```
Terraform Course — Environment Check

  ✓ Terraform 1.x.x (>= 1.6 required)
  ✓ Docker 2x.x.x (daemon running)
  ✓ Git 2.x.x (>= 2.0 required)
  ✓ VS Code 1.x.x

Results: 4/4 passed
```

If any line shows a red `✗`, fix it using the install steps above, then re-run the script.

## Troubleshooting

### Terraform provider download fails behind a corporate proxy

`terraform init` needs HTTPS access to `registry.terraform.io`. If you are behind a proxy, set these environment variables before running any Terraform command:

```bash
export HTTP_PROXY="http://proxy.example.com:8080"
export HTTPS_PROXY="http://proxy.example.com:8080"
export NO_PROXY="localhost,127.0.0.1"
```

Ask your instructor or IT department for the correct proxy URL. Add the lines to your `~/.bashrc` or `~/.zshrc` to make them persistent.

### Docker daemon not running on Linux

If `docker ps` returns `Cannot connect to the Docker daemon`:

```bash
# Check the service status
sudo systemctl status docker

# Start it if stopped
sudo systemctl start docker

# If your user is not in the docker group
sudo usermod -aG docker $USER
# Then log out and back in
```

### `terraform` not found after install

Your shell cannot find the binary. Check where it is and add it to your `PATH`:

```bash
# Find the binary
which terraform || find /usr/local /opt/homebrew -name terraform 2>/dev/null

# Add to PATH (adjust the path to match your install)
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

On macOS with zsh, replace `~/.bashrc` with `~/.zshrc`.
