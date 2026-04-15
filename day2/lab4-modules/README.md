# Lab 4 — Build a Reusable Module

## Objectives
- Create a Terraform module with inputs, resources, and outputs
- Call the same module multiple times with different parameters
- Wire outputs from one module into inputs of another
- Refactor a flat configuration into a modular structure

## Prerequisites
- Lab 3 completed
- Docker Desktop running (`docker ps` should work)
- Familiarity with `variable`, `resource`, `output` blocks

## Duration
~ 60 minutes

## Context

Your team manages several Docker-based microservices. Each service needs a container, a configuration file, and a network attachment — the same pattern every time, with different parameters. Instead of copy-pasting Terraform code for each service, you'll build a reusable module that encapsulates the pattern. Then you'll call it twice and wire the services together.

## Instructions

### Step 1 — Explore the starter structure

Navigate into the starter directory:

```bash
cd day2/lab4-modules/starter/
```

You'll find this layout:

```
starter/
├── main.tf                       ← root module (TODO)
├── variables.tf                  ← root variables (TODO)
├── outputs.tf                    ← root outputs (TODO)
└── modules/
    └── docker-app/
        ├── main.tf               ← module resources (TODO)
        ├── variables.tf          ← module inputs (TODO)
        └── outputs.tf            ← module outputs (TODO)
```

Read the `# TODO` comments in each file before writing any code.

### Step 2 — Define the module's inputs

Open `modules/docker-app/variables.tf`. Define these variables:

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `app_name` | `string` | (required) | Name of the application |
| `environment` | `string` | `"dev"` | Deployment environment |
| `image` | `string` | `"nginx:1.25-alpine"` | Docker image to use |
| `internal_port` | `number` | `80` | Port exposed inside the container |
| `external_port` | `number` | (required) | Port mapped on the host |
| `env_vars` | `map(string)` | `{}` | Environment variables to pass to the container |

Add a `description` to every variable.

### Step 3 — Write the module's resources

Open `modules/docker-app/main.tf`. Create three resources:

**1. Docker image:**
```hcl
resource "docker_image" "app" {
  name         = var.image
  keep_locally = true
}
```

**2. Local config file** — generates a JSON config for the app:
```hcl
resource "local_file" "config" {
  filename = "${path.module}/../../output/${var.app_name}-${var.environment}-config.json"
  content = jsonencode({
    app_name    = var.app_name
    environment = var.environment
    port        = var.external_port
  })
}
```

**3. Docker container** — the actual running service:

Create a `docker_container` resource named `app` that:
- Uses `"${var.app_name}-${var.environment}"` as the container name
- Uses the image ID from the `docker_image.app` resource
- Maps `var.internal_port` (internal) to `var.external_port` (external)
- Sets environment variables by converting `var.env_vars` to a list of `"KEY=VALUE"` strings

> Hint for env vars: use `[for k, v in var.env_vars : "${k}=${v}"]`

### Step 4 — Expose the module's outputs

Open `modules/docker-app/outputs.tf`. Define these outputs:

| Output | Value | Description |
|--------|-------|-------------|
| `container_id` | `docker_container.app.id` | Container ID |
| `container_name` | `docker_container.app.name` | Container name |
| `endpoint` | `"http://localhost:${var.external_port}"` | Application URL |
| `config_path` | `local_file.config.filename` | Path to the generated config file |

### Step 5 — Configure the root module

Open the root `main.tf`. Add:

**Provider configuration:**

```hcl
terraform {
  required_version = ">= 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "docker" {}
provider "local" {}
```

**Two module calls** — a frontend and a backend:

```hcl
module "frontend" {
  source = "./modules/docker-app"

  app_name      = "frontend"
  environment   = var.environment
  image         = "nginx:1.25-alpine"
  external_port = 8080
  env_vars = {
    API_URL = module.backend.endpoint
  }
}

module "backend" {
  source = "./modules/docker-app"

  app_name      = "backend"
  environment   = var.environment
  image         = "nginx:1.25-alpine"
  external_port = 3000
  env_vars = {
    LOG_LEVEL = "debug"
  }
}
```

Notice: `module.frontend` references `module.backend.endpoint`. Terraform resolves this dependency automatically — backend is created first.

### Step 6 — Add root variables and outputs

In the root `variables.tf`:

```hcl
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
```

In the root `outputs.tf`, expose:
- `frontend_url` — from `module.frontend.endpoint`
- `backend_url` — from `module.backend.endpoint`
- `frontend_container` — from `module.frontend.container_name`
- `backend_container` — from `module.backend.container_name`

### Step 7 — Initialize and apply

```bash
mkdir -p output
terraform init
terraform plan
```

Before applying, answer these questions by reading the plan:
1. How many resources will Terraform create in total?
2. How are resources named in the plan? (look for `module.frontend.` and `module.backend.` prefixes)
3. Which module is created first? Why?

```bash
terraform apply
```

### Step 8 — Verify everything works

```bash
# Containers are running
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

# Outputs are accessible
terraform output

# Config files were generated
cat output/frontend-dev-config.json | python3 -m json.tool
cat output/backend-dev-config.json | python3 -m json.tool

# State shows module namespacing
terraform state list

# Test the endpoints
curl -s http://localhost:8080 | head -5
curl -s http://localhost:3000 | head -5
```

### Step 9 — Test reusability

Change the environment to `staging` and apply:

```bash
terraform apply -var="environment=staging"
```

Questions:
1. What happens to the containers? Are they updated in place or replaced?
2. Check `docker ps` — what are the new container names?
3. Check the config files — did the filenames change?

### Step 10 — Inspect module encapsulation

Try adding this output to the root `outputs.tf`:

```hcl
output "frontend_image_id" {
  value = module.frontend.docker_image.app.image_id
}
```

Run `terraform plan`. What happens? Why?

Remove the broken output. The correct way is to add an `image_id` output inside the module's `outputs.tf`, then reference it as `module.frontend.image_id`.

### Step 11 — Clean up

```bash
terraform destroy
docker ps   # should show no lab containers
```

## Validation

Run each command and check against the expected output.

```bash
# After Step 7 — resources created
terraform state list
# Expected (6 resources):
# module.backend.docker_container.app
# module.backend.docker_image.app
# module.backend.local_file.config
# module.frontend.docker_container.app
# module.frontend.docker_image.app
# module.frontend.local_file.config

# Containers running
docker ps --filter "name=frontend" --filter "name=backend" --format "{{.Names}}"
# Expected:
# frontend-dev
# backend-dev

# Outputs work
terraform output frontend_url
# Expected: "http://localhost:8080"

terraform output backend_url
# Expected: "http://localhost:3000"

# Config files exist and are valid JSON
python3 -m json.tool output/frontend-dev-config.json > /dev/null && echo "valid"
# Expected: valid

python3 -m json.tool output/backend-dev-config.json > /dev/null && echo "valid"
# Expected: valid

# Nginx responds
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080
# Expected: 200

curl -s -o /dev/null -w "%{http_code}" http://localhost:3000
# Expected: 200

# After Step 11 — clean
terraform state list
# Expected: (empty)

docker ps --filter "name=frontend" --filter "name=backend" -q
# Expected: (empty)
```

## Going Further

1. **Add a network module** — Create a `modules/docker-network/` module that creates a `docker_network`. Pass the network ID as an output, then add a `network_id` variable to the `docker-app` module. Wire them: network module → output → docker-app module input. Attach both containers to the shared network.

2. **`for_each` on modules** — Instead of two separate module blocks, use `for_each` to create both services from a map:
   ```hcl
   variable "services" {
     default = {
       frontend = { image = "nginx:1.25-alpine", port = 8080 }
       backend  = { image = "nginx:1.25-alpine", port = 3000 }
     }
   }

   module "service" {
     for_each      = var.services
     source        = "./modules/docker-app"
     app_name      = each.key
     external_port = each.value.port
     image         = each.value.image
   }
   ```

3. **Health check** — Add a `healthcheck` block to the Docker container in the module. Use `curl -f http://localhost:${var.internal_port}/ || exit 1` as the test command. Observe the container health status with `docker inspect`.

4. **Module documentation** — Add a `README.md` inside `modules/docker-app/` that documents the module's purpose, inputs, outputs, and a usage example. This is what every public Terraform module includes.
