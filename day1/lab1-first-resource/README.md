# Lab 1 — Your First Terraform Resource

## Objectives
- Initialize a Terraform project from scratch
- Write a configuration using the `local` provider
- Run the full Terraform workflow: `init` → `plan` → `apply` → `destroy`
- Understand the role of each generated file (`.terraform/`, `terraform.tfstate`, `.terraform.lock.hcl`)

## Prerequisites
- Terraform >= 1.6 installed (`terraform -version`)
- A terminal and a text editor (VS Code recommended)
- Run `check-setup.sh` from the `setup/` folder to validate your environment

## Duration
~ 90 minutes

## Context

You just joined a team that manages infrastructure manually. Your first task is to prove that Terraform works by creating something simple: a local file on your machine. No cloud account needed — the `local` provider lets you manage files and directories as Terraform resources.

This lab walks you through the entire Terraform lifecycle so you understand what happens at each step before moving to real cloud resources.

## Instructions

### Step 1 — Project setup

Navigate into the starter directory for this lab:

```bash
cd day1/lab1-first-resource/starter/
```

The starter contains empty files with comments telling you what to fill in:

```
starter/
├── main.tf        ← add resources here
├── variables.tf   ← empty for now
├── outputs.tf     ← empty for now
└── .gitignore     ← already configured
```

Open each file and read the comments before writing any code.

### Step 2 — Configure the provider

In `main.tf`, write a `terraform` block that:
- Requires Terraform `>= 1.6`
- Declares the `hashicorp/local` provider with version `~> 2.5`

Then add an empty `provider "local" {}` block.

Once written, run:

```bash
terraform init
```

Observe the output, then inspect:

```bash
ls -la .terraform/
cat .terraform.lock.hcl
```

Questions:
1. Where was the provider binary downloaded?
2. What information does `.terraform.lock.hcl` contain?
3. Should you commit this file to Git? Why?

### Step 3 — Create your first resource

Add a `local_file` resource to `main.tf` that creates a file named `hello.txt` in the current module directory, with the content `"Hello from Terraform!"`.

> Hint: look up the `local_file` resource in the [Terraform Registry](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file). You need two arguments: `content` and `filename`. Use `path.module` to reference the current directory.

### Step 4 — Read the plan

```bash
terraform plan
```

Before running `apply`, answer these questions by reading the plan output:

1. How many resources will be created?
2. What does the `+` symbol mean?
3. What value does `id` show? Why?

### Step 5 — Apply

```bash
terraform apply
```

Type `yes` when prompted. Then verify:

```bash
cat hello.txt
cat terraform.tfstate
```

Questions:
1. What is the structure of `terraform.tfstate`? What fields do you recognize?
2. Run `terraform apply` a second time without changing anything. What happens? Why?

### Step 6 — Observe an update

Change the `content` of your `local_file` resource to a different string. Run `terraform plan` again.

Questions:
1. What symbol appears next to the resource this time? What does it mean?
2. Is the resource destroyed and recreated, or updated in place?

Apply the change and verify the file content updated.

### Step 7 — Add a structured config file

Add a second resource to `main.tf` that creates a file named `app-config.json` using `jsonencode()`:

The JSON should contain:
- a `version` field (string)
- an `environment` field (hardcode `"dev"` for now)
- a `services` field with at least two key-value pairs of your choice

```bash
terraform plan
terraform apply
cat app-config.json
```

Verify the output is valid JSON.

### Step 8 — Inspect the state

```bash
terraform state list
terraform state show local_file.hello
terraform show
```

Questions:
1. What is the difference between `terraform state list` and `terraform show`?
2. What attributes does Terraform track for your `local_file` resource?

### Step 9 — Destroy

```bash
terraform plan -destroy
```

Read the plan. How many resources will be destroyed? Then:

```bash
terraform destroy
```

Verify the files are gone and the state is empty:

```bash
ls *.txt *.json 2>/dev/null || echo "No files — clean"
terraform state list
```

## Validation

Run each command and check against the expected output.

```bash
# After Step 5 — resource created
cat hello.txt
# Expected: Hello from Terraform!

terraform state list
# Expected:
# local_file.hello

# After Step 6 — update observed
terraform plan
# Expected: Plan: 0 to add, 0 to change, 0 to destroy.
# (nothing changed since last apply)

# After Step 7 — JSON file valid
python3 -m json.tool app-config.json
# Expected: formatted JSON with no errors

terraform state list
# Expected:
# local_file.app_config
# local_file.hello

# After Step 8 — state inspection
terraform state show local_file.hello | grep filename
# Expected: filename = "./hello.txt"

# After Step 9 — clean state
terraform state list
# Expected: (empty output)

ls hello.txt app-config.json 2>/dev/null || echo "clean"
# Expected: clean
```

## Going Further

1. **File permissions** — Add the `file_permission` argument to `local_file` and set it to `"0600"`. Run `terraform plan` — does it trigger an update or a recreate?

2. **Sensitive file** — Replace `local_file` with `local_sensitive_file` for `app-config.json`. Run `terraform plan` — how does the plan output differ? Check the file permissions on disk after apply.

3. **Multiple resources with `count`** — Add a resource that creates 3 files using the `count` meta-argument:
   ```hcl
   resource "local_file" "numbered" {
     count    = 3
     content  = "File number ${count.index + 1}"
     filename = "${path.module}/output/file-${count.index + 1}.txt"
   }
   ```
   Observe how the plan and state look with indexed resources (`local_file.numbered[0]`, etc.).

4. **Import** — Manually create a file `manual.txt` with any content. Then bring it under Terraform management using `terraform import`. Check the [import documentation](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file#import) for the exact syntax.