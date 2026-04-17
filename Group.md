### Mbarek Lamin & Tanguy Van Hullebusch 

## Lab 1 

# Step 2

Questions:
1. Where was the provider binary downloaded?

Dans le dossier ".terraform/"

2. What information does `.terraform.lock.hcl` contain?

Le hash exact des providers, et leur version exact.

3. Should you commit this file to Git? Why?

Oui pour garantir la reproductibilité.

# Step 4

Before running `apply`, answer these questions by reading the plan output:

1. How many resources will be created?

Une seule ressource

2. What does the `+` symbol mean?

Ce sont les attributs ajoutés.

3. What value does `id` show? Why?

L'attribut (know after reply). Cela veut dire que la valeur sera assignée au moment de la création.

# Step 5

Questions:
1. What is the structure of `terraform.tfstate`? What fields do you recognize?

C'est un fichier Json avec des attributs "version", "version de terraform", "serial", "lineage", "outputs", "ressources"

2. Run `terraform apply` a second time without changing anything. What happens? Why?

Aucun changement a était appliqué car la configuration n'a pas changée. 

# Step 6

Questions:
1. What symbol appears next to the resource this time? What does it mean?

Le symbole -/+. Cela veut dire que la ressource sera détruite et remplacé.

2. Is the resource destroyed and recreated, or updated in place?

Elle est détruite et remplacé.

# Step 8

Questions:
1. What is the difference between `terraform state list` and `terraform show`?

'terraform state list' liste les ressources au moment de la commande et 'terraform show' montre l'état actuel de terraform.

2. What attributes does Terraform track for your `local_file` resource?

le contenu, le hash du contenu, les permissions, le nom du fichier et l'ID

# Step 9

Read the plan. How many resources will be destroyed?

2 ressources seront détruites

## lab2:

# step 4 :

result = 

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


# step 5 :

Which value wins?

its -var flag

# Step 7 :

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

## lab 3

# step 2

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

In the same folder as main.tf

2. What is the `serial` number in the state file?

Le serial designe la version du fichier

3. What does `terraform.tfstate.backup` contain? When is it created?

`terraform.tfstate.backup` contient la dernière sauvegarde connu de terraform. 
Elle est crée lors d'un `terraform init`

# step 6 

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
"serial": 6

# step 7

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

It fail 

2. What error message do you see?

Error acquiring the state lock

3. What information does the lock message contain?

│ Error message: resource temporarily unavailable

# step 8

```bash
# List all resources
terraform state list

#local_file.app_config
#local_file.metadata
#local_file.text

# Show details for one resource
terraform state show local_file.app_config

"
resource "local_file" "app_config" {
    content              = jsonencode(
        {
            app          = "lab3"
            environement = "staging"
        }
    )
    content_base64sha256 = "kMPtAs2inOBbgPUV763a/KhAHpbTzla1n8aRAK5qOUI="
    content_base64sha512 = "FJOu7ICIqd3zPSvA37BEkzpYsKNLJf0MLGSjgBUEAv12sbxao5pn4bdyy+ixRRWoFz04yIYlDXjEy+C8THzHiw=="
    content_md5          = "9a49bb8b85c1cfbbf807f7c2daee1a92"
    content_sha1         = "f8562ab6fc828019484ab68124edc358233836b5"
    content_sha256       = "90c3ed02cda29ce05b80f515efaddafca8401e96d3ce56b59fc69100ae6a3942"
    content_sha512       = "1493aeec8088a9ddf33d2bc0dfb044933a58b0a34b25fd0c2c64a380150402fd76b1bc5aa39a67e1b772cbe8b14515a8173d38c886250d78c4cbe0bc4c7cc78b"
    directory_permission = "0777"
    file_permission      = "0777"
    filename             = "output/app-config.json"
    id                   = "f8562ab6fc828019484ab68124edc358233836b5"
}"

# Rename a resource without destroying it
terraform state mv local_file.metadata local_file.info

"""
Move "local_file.metadata" to "local_file.info"
Successfully moved 1 object(s).
"""



## lab 4

# step 7 

Before applying, answer these questions by reading the plan:
1. How many resources will Terraform create in total?

Terraform va créé 6 nouvelles resources 

2. How are resources named in the plan? (look for `module.frontend.` and `module.backend.` prefixes)

module.backend.docker_container.app
module.backend.docker_image.app
module.backend.local_file.config
module.frontend.docker_container.app
module.frontend.docker_image.app
module.frontend.local_file.config

3. Which module is created first? Why?

Selon la console, le premier module créé est backend.docker_container.app.
Il est créé en premier car le module frontend  starter\main.tf reference le module backend,
Ce qui cause Terraform de créé module.backend en premier.

# step 8

```bash
# Containers are running
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

# Terminal : 

NAMES          PORTS                  STATUS
frontend-dev   0.0.0.0:8081->80/tcp   Up 30 seconds
backend-dev    0.0.0.0:3000->80/tcp   Up 9 minutes

# Outputs are accessible
terraform output

#Terminal : 

backend_container = "backend-dev"
backend_url = "http://localhost:3000"
frontend_container = "frontend-dev"
frontend_url = "http://localhost:8081"

# Config files were generated
cat output/frontend-dev-config.json | python3 -m json.tool


# Terminal :

{
    "app_name": "frontend",
    "environment": "dev",
    "port": 8081
}

cat output/backend-dev-config.json | python3 -m json.tool

# Terminal :

{
    "app_name": "backend",
    "environment": "dev",
    "port": 3000
}

# State shows module namespacing
terraform state list

# Terminal :

module.backend.docker_container.app
module.backend.docker_image.app
module.backend.local_file.config
module.frontend.docker_container.app
module.frontend.docker_image.app
module.frontend.local_file.config

# Test the endpoints
curl -s http://localhost:8080 | head -5

# Terminal : 

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>

curl -s http://localhost:3000 | head -5

# Terminal :

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>

```

# step 9

Change the environment to `staging` and apply:

```bash
terraform apply -var="environment=staging"
```

Questions:
1. What happens to the containers? Are they updated in place or replaced?

Ils sont remplacés : Plan: 4 to add, 0 to change, 4 to destroy.

2. Check `docker ps` — what are the new container names?

Les noms de conteneurs ont étaient changé en backend_staging et frontend-staging

3. Check the config files — did the filenames change?

Le contenus des fichiers de configurations n'ont pas changés 
malgré le apply -var="environment=staging"

# step 10

Try adding this output to the root `outputs.tf`:

```hcl
output "frontend_image_id" {
  value = module.frontend.docker_image.app.image_id
}
```

Run `terraform plan`. What happens? Why?

Une erreur s'active. Selon le message, le module "frontend" n'a pas était déclaré.

