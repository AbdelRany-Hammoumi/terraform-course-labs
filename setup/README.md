# Environment Setup

Get your machine ready for the Terraform course. Target time: **15 minutes**.

## 1. Terraform >= 1.6

### Recommended: tfenv (version manager)

```bash
# macOS
brew install tfenv

# Linux
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Then install and activate:

```bash
tfenv install 1.11.4
tfenv use 1.11.4
terraform -version
```

### Alternative: direct download

Download the binary for your platform from https://releases.hashicorp.com/terraform/ and place it in a directory on your `PATH` (`/usr/local/bin` works on both macOS and Linux).

```bash
# Verify
terraform -version
# Expected: Terraform v1.x.x (>= 1.6)
```

## 2. Docker

You need a running Docker daemon, not just the binary.

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

### Install VS Code

- macOS: `brew install --cask visual-studio-code`
- Linux: https://code.visualstudio.com/docs/setup/linux

### Install the Terraform extension

```bash
code --install-extension hashicorp.terraform
```

This gives you syntax highlighting, autocompletion, and `terraform fmt` on save.

## 5. Clone the lab repo

```bash
git clone https://github.com/<org>/terraform-course-labs.git
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
which terraform || find /usr/local /opt/homebrew ~/.tfenv -name terraform 2>/dev/null

# Add to PATH (adjust the path to match your install)
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# If using tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

On macOS with zsh, replace `~/.bashrc` with `~/.zshrc`.
