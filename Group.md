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

