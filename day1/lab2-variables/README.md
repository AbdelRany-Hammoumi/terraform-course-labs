# Lab 2 — Variables, Outputs, and Data Sources

## Objectives
- Parameterize a Terraform configuration using input variables
- Use different variable types: `string`, `number`, `list`, `map`, `object`
- Define and query output values
- Use a data source to read existing resources
- Understand variable precedence (defaults, `.tfvars`, CLI flags, env vars)

## Prerequisites
- Lab 1 completed
- Familiarity with `terraform init`, `plan`, `apply`

## Duration
~ 30 minutes

## Context

Hardcoding values in `main.tf` doesn't scale. In this lab, you'll refactor a Terraform configuration to use variables and outputs, making it reusable and configurable. You'll also use a data source to read information from an existing resource — a pattern you'll use constantly in real-world Terraform.

## Instructions

### Step 1 — Scaffold the project

Navigate into the starter directory for this lab:

```bash
cd day1/lab2-variables/starter/
```

Inspect the files already provided. You'll find empty `main.tf`, `variables.tf`, and `outputs.tf` with comments indicating what to fill in. Initialize the project:

```bash
terraform init
```

### Step 2 — Define input variables

Open `variables.tf` and declare the following variables:

- `project_name` — type `string`, default `"my-terraform-lab"`
- `environment` — type `string`, default `"dev"`, with a validation rule that only accepts `"dev"`, `"staging"`, or `"prod"`
- `tags` — type `map(string)`, default `{}`
- `file_count` — type `number`, default `1`

> The `environment` variable must have a default value. Without one, Terraform will prompt interactively when no value is provided — which blocks pipelines and surprises first-time users.

### Step 3 — Use variables in resources

In `main.tf`, write a `local_file` resource that:
- Uses `var.project_name` and `var.environment` to build the output filename
- Uses `jsonencode()` to write a JSON file containing the project name, environment, and tags

Create the output directory before applying:

```bash
mkdir -p output
terraform plan
```

### Step 4 — Set variable values with a `.tfvars` file

Create `terraform.tfvars` and set:

```hcl
environment  = "dev"
project_name = "terraform-lab2"
tags = {
  owner  = "student"
  course = "terraform-master"
}
file_count = 3
```

Run `terraform plan` and verify the variables resolve correctly in the output.

results = 

'''
# local_file.project must be replaced
-/+ resource "local_file" "project" {
      ~ content              = jsonencode(
          ~ {
              ~ project_name = "my-terraform-lab" -> "terraform-lab2"
              ~ tags         = {
                  + course = "terraform-master"
                  + owner  = "student"
                }
                # (1 unchanged attribute hidden)
            } # forces replacement
        )
}'''

### Step 5 — Test variable precedence

This step is the most important in the lab. Run each command below and observe which value actually takes effect.

**Test 1 — CLI flag**
```bash
terraform plan -var="environment=staging"
```

**Test 2 — Environment variable**
```bash
export TF_VAR_environment="prod"
terraform plan
```

Now run **both at the same time**:
```bash
terraform plan -var="environment=staging"
# TF_VAR_environment is still set to "prod"
```

Which value wins?

its -var flag

**The correct precedence order, from highest to lowest:**

| Priority | Source |
|----------|--------|
| 1 (highest) | `-var` and `-var-file` flags on the CLI |
| 2 | `*.auto.tfvars` files (loaded alphabetically) |
| 3 | `terraform.tfvars` (auto-loaded if present) |
| 4 | `TF_VAR_*` environment variables |
| 5 (lowest) | `default` value in the `variable` block |

> ⚠️ Common mistake: `TF_VAR_*` env vars have **lower** priority than `terraform.tfvars`, not higher. In step 2 above, `terraform.tfvars` sets `environment = "dev"`, so `TF_VAR_environment=prod` will be **overridden** by the tfvars file.

Unset the env var when done:
```bash
unset TF_VAR_environment
```

### Step 6 — Use a data source

Before defining outputs, add a data source that reads back the file you just created:

```hcl
data "local_file" "read_config" {
  filename = local_file.config.filename
}
```

Apply your configuration so the file exists on disk:
```bash
terraform apply
```

### Step 7 — Define and query outputs

In `outputs.tf`, define three outputs:

- `config_filename` — the path to the generated file
- `config_content` — the decoded JSON content (use `jsondecode()`)
- `project_summary` — a single string combining project name and environment
- `read_back_content` — the content read via the data source (use `jsondecode()`)

Apply and query your outputs:

```bash
terraform apply
terraform output
terraform output config_filename
terraform output -json
```

output "config_filename" {

    description = "the path to the generated file"
    value   = "${local_file.config.filename}"
    sensitive = true

}

output "config_content" {

    description = "read the Json content"
    value = jsondecode(resource.local_file.config.content)

}

output "project_summary" {
    description = "combinaison du nom de projet et de l'environement"
    
    value = join("-",[var.project_name, var.environment])
  
}

output "read_back_content"{
    description = "jsondecode de datasource"
    value = jsondecode(data.local_file.read_config.content)
}


### Step 8 — Trigger a validation error

Try passing an invalid environment value:

```bash
terraform plan -var="environment=production"
```

Observe the error message. This fires at plan time — before any infrastructure is touched.

## Validation

Run the following commands and check that each matches the expected output.

```bash
# Variables resolved correctly
terraform output project_summary
# Expected: "terraform-lab2 (dev)"

# JSON content written and readable
terraform output -json config_content
# Expected: JSON object with project, environment, tags keys

# Data source reads back the same content
terraform output -json read_back_content
# Expected: identical to config_content

# File exists on disk with the right name
ls output/
# Expected: terraform-lab2-dev.json

# State contains exactly 1 resource
terraform state list
# Expected: local_file.config

# Validation catches bad input
terraform plan -var="environment=production" 2>&1 | grep "error_message"
# Expected: "Environment must be dev, staging, or prod."
```

## Going Further

1. **Sensitive variables** — Add a `variable "api_key"` with `sensitive = true`. Use it in a resource. Run `terraform plan` and observe how the output differs from a regular variable.
2. **Complex types** — Create a variable of type `object({ name = string, port = number, enabled = bool })` and use it to generate a JSON config file.
3. **Local values** — Use a `locals` block to compute a derived value (e.g., `full_name = "${var.project_name}-${var.environment}"`) and refactor your resources to use it everywhere instead of repeating the interpolation.
4. **Multiple environments** — Create two tfvars files: `dev.tfvars` and `prod.tfvars`. Apply each with `-var-file` and verify the output files are different.