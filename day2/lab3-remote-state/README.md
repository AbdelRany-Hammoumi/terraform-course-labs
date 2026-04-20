# Lab 3 — Remote State & Backends

## Objectives
- Configure a local backend with a custom state path
- Migrate state from the default location to a custom backend
- Inspect state before and after migration to verify integrity
- Simulate concurrent access and observe locking behavior
- (Optional) Configure an S3 backend with DynamoDB locking

## Prerequisites
- Labs 1 and 2 completed
- Familiarity with `terraform state list`, `terraform state show`
- Docker Desktop running (for Part 2)

## Duration
~ 90 minutes

## Context

So far, your state file has been sitting in the working directory — fine for solo work, but dangerous in a team. In this lab, you'll configure a backend to control where state is stored, migrate existing state without data loss, and see what happens when two processes try to modify state at the same time.

You'll work with the `local` backend first (no cloud account needed), then optionally set up an S3 backend if you have AWS credentials.

## Instructions

### Step 1 — Start with a working configuration

Navigate into the starter directory:

```bash
cd day2/lab3-remote-state/starter/
```

Open `main.tf`. You'll see a `# TODO` comment. Replace it with a configuration that:
- Requires Terraform `>= 1.6`
- Declares the `hashicorp/local` provider version `~> 2.5`
- Creates two `local_file` resources:
  - `app_config` — a JSON file at `output/app-config.json` containing `{ "app": "lab3", "environment": "dev" }`
  - `metadata` — a text file at `output/metadata.txt` containing `"Managed by Terraform — do not edit manually"`

Initialize and apply:

```bash
mkdir -p output
terraform init
terraform apply
```

### Step 2 — Inspect the default state

Before migrating, understand what you have:

```bash
ls terraform.tfstate
terraform state list
terraform state show local_file.app_config
```

Check the state file format:

```bash
cat terraform.tfstate | python3 -m json.tool | head -30
```

Questions:
1. Where is the state file stored by default?
2. What is the `serial` number in the state file?
3. What does `terraform.tfstate.backup` contain? When is it created?

### Step 3 — Add a `.gitignore`

Before going further, make sure state files are never committed:

```bash
cat > .gitignore << 'EOF'
*.tfstate
*.tfstate.*
.terraform/
EOF
```

This is non-negotiable for any real project. State files contain all resource attributes, including sensitive values, in plaintext.

### Step 4 — Configure a local backend

Create a file named `backend.tf` with:

```hcl
terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}
```

This tells Terraform to store state in the `state/` subdirectory instead of the working directory.

### Step 5 — Migrate state

Run:

```bash
terraform init -migrate-state
```

Terraform will ask: *"Do you want to copy existing state to the new backend?"* — answer `yes`.

After migration, verify:

```bash
# State moved to new location
ls state/terraform.tfstate

# Old state is now empty (Terraform keeps the file but clears its content)
cat terraform.tfstate

# Resources are still tracked
terraform state list

# No changes needed — migration preserved everything
terraform plan
```

The `terraform plan` output should show `No changes`. This is the proof that migration was lossless.

### Step 6 — Verify the full lifecycle still works

Make a change to prove the new backend is fully functional:

```bash
# Modify a resource — change the environment value
```

Update `app_config` to use `"environment": "staging"` instead of `"dev"`. Then:

```bash
terraform plan
# Expected: 1 to change

terraform apply
cat output/app-config.json
# Expected: {"app":"lab3","environment":"staging"}

# State file updated in the new location
cat state/terraform.tfstate | python3 -m json.tool | grep serial
# serial should have incremented
```

### Step 7 — Observe state locking

Open **two terminal windows** in the same directory.

Local resources apply instantly, so we can't observe locking during apply. Instead, we'll use the interactive approval prompt to hold the lock open.

In `main.tf`, add a third `local_file` resource (any content). Then in Terminal 1:

**Terminal 1:**
```bash
terraform apply -lock-timeout=60s
# When prompted, DO NOT type "yes" yet — leave it hanging
```

**Terminal 2 (while Terminal 1 is waiting for approval):**
```bash
terraform plan
```

Observe the output in Terminal 2. Questions:
1. Does Terminal 2 succeed or fail?
2. What error message do you see?
3. What information does the lock message contain?

Type `yes` in Terminal 1 to finish, then retry Terminal 2.

> **Note:** Local backend locking uses filesystem locks. The behavior may vary slightly by OS. On shared filesystems (NFS), local locks are unreliable — this is one reason teams use remote backends.

### Step 8 — State manipulation commands

Practice the key state commands:

```bash
# List all resources
terraform state list

# Show details for one resource
terraform state show local_file.app_config

# Rename a resource without destroying it
terraform state mv local_file.metadata local_file.info

# Update main.tf to match — rename the resource block from "metadata" to "info"
# Then verify:
terraform plan
# Expected: No changes (the state mv preserved the link)
```

After verifying, rename both the resource block in code AND the filename if you like, then apply.

### Step 9 — Clean up

```bash
terraform destroy
```

Verify:

```bash
terraform state list
# Expected: (empty)

ls output/
# Expected: directory is empty or gone
```

## Validation

Run each command and check against the expected output.

```bash
# After Step 5 — state migrated
ls state/terraform.tfstate
# Expected: file exists

terraform state list
# Expected:
# local_file.app_config
# local_file.metadata

terraform plan
# Expected: No changes. Your infrastructure matches the configuration.

# After Step 6 — change applied through new backend
cat output/app-config.json | python3 -m json.tool
# Expected: {"app": "lab3", "environment": "staging"}

# After Step 8 — resource renamed
terraform state list
# Expected:
# local_file.app_config
# local_file.info

terraform plan
# Expected: No changes.

# After Step 9 — clean state
terraform state list
# Expected: (empty output)
```

## Going Further

1. **S3 Backend** — If you have an AWS account, replace the local backend with an S3 backend:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "your-unique-bucket-name"
       key            = "lab3/terraform.tfstate"
       region         = "eu-west-1"
       encrypt        = true
       dynamodb_table = "terraform-locks"
     }
   }
   ```
   You'll need to create the S3 bucket and DynamoDB table first (via AWS CLI or a separate Terraform project with local state). Then run `terraform init -migrate-state` to move your state to S3.

2. **`terraform_remote_state` data source** — Create a second directory (`consumer/`) that reads the state from your lab3 project using:
   ```hcl
   data "terraform_remote_state" "lab3" {
     backend = "local"
     config = {
       path = "../starter/state/terraform.tfstate"
     }
   }
   ```
   You'll need to add outputs to the lab3 project first — `terraform_remote_state` can only read `output` values.

3. **State import** — Create a file manually (`echo "manual" > output/manual.txt`), then import it into Terraform management with `terraform import`. Write the matching resource block first, then import.

4. **`moved` block** — Instead of using `terraform state mv`, try the declarative approach:
   ```hcl
   moved {
     from = local_file.info
     to   = local_file.metadata
   }
   ```
   Run `terraform plan` to see the move, then `apply`. After applying, remove the `moved` block.
