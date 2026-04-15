# Terraform Course — Labs

Hands-on labs for the 3-day Terraform course. Clone this repo, follow the READMEs, write Terraform code.

## Prerequisites

Install all required tools **before Day 1**: see [`setup/README.md`](setup/README.md).

Run the validation script to confirm everything works:

```bash
cd setup && ./check-setup.sh
```

## Repository structure

```
setup/                         Environment setup guide and validation script
day1/
  lab1-first-resource/         Create your first Terraform resource (local provider)
  lab2-variables/              Parameterize configs with variables, outputs, data sources
day2/
  lab3-remote-state/           Configure remote state with backends
  lab4-modules/                Build and consume reusable modules
day3/
  lab5-ci-cd/                  Automate Terraform with GitHub Actions
  final-project/               Deploy a 3-tier infrastructure end-to-end
```

Each lab directory contains:
- `README.md` — instructions, objectives, validation steps
- `starter/` — scaffold files (`main.tf`, `variables.tf`, `outputs.tf`) to build on

## Quick start

```bash
git clone https://github.com/AbdelRany-Hammoumi/terraform-course-labs.git
cd terraform-course-labs/setup && ./check-setup.sh
cd ../day1/lab1-first-resource && cat README.md
```

> Replace `<org>` with the GitHub organization provided by your instructor.

## Labs

| Lab | Title | Directory | Duration | Provider |
|-----|-------|-----------|----------|----------|
| 1 | First resource | `day1/lab1-first-resource/` | 90 min | local |
| 2 | Variables & outputs | `day1/lab2-variables/` | 30 min | local |
| 3 | Remote state | `day2/lab3-remote-state/` | 90 min | local (S3/GCS optional) |
| 4 | Reusable modules | `day2/lab4-modules/` | 60 min | local / Docker |
| 5 | CI/CD pipeline | `day3/lab5-ci-cd/` | 60 min | GitHub Actions |
| FP | Final project | `day3/final-project/` | 75 min | Docker / AWS |

## Solutions

Solutions are **not** included in this repository. They are provided separately by your instructor.
