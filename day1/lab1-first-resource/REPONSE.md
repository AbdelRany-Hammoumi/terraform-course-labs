# Lab 1 — Réponses aux questions

## Step 2 — Configuration du provider

### 1. Où le binaire du provider a-t-il été téléchargé ?

Le binaire a été téléchargé dans le dossier caché .terraform/ créé à la racine du module.
Le chemin exact est : .terraform/providers/registry.terraform.io/hashicorp/local/2.8.0/linux_amd64/
Terraform crée cette arborescence automatiquement lors de terraform init.

### 2. Que contient .terraform.lock.hcl ?

Ce fichier contient les versions exactes et les empreintes cryptographiques des providers sélectionnés lors du init.
Il garantit la reproductibilité : toute personne qui clone le repo et lance terraform init obtiendra exactement le même provider, même version, même binaire vérifié.

### 3. Faut-il committer ce fichier dans Git ?

Oui, il faut le committer. Il joue le même rôle que package-lock.json pour Node ou Pipfile.lock pour Python.
Il verrouille les versions pour que tous les membres de l'équipe et les pipelines CI/CD travaillent avec les mêmes providers.
Si on ne le committe pas, on s'expose à des comportements différents selon les environnements.


## Step 4 — Lire le plan

### 1. Combien de ressources seront créées ?

2 ressources : local_file.hello et local_file.app_config.

### 2. Que signifie le symbole + ?

Le + signifie que la ressource va être créée car elle n'existe pas encore dans le state.
Les autres symboles possibles sont :
- ~ : mise à jour en place (update in-place)
- -/+ : destruction puis recréation (replace)
- - : destruction (destroy)

### 3. Quelle valeur affiche id ? Pourquoi ?

id affiche "known after apply". Cela signifie que l'identifiant ne peut pas être calculé avant l'exécution réelle.
Pour local_file, l'id est le hash SHA1 du contenu du fichier, il n'est donc connu qu'une fois le fichier réellement écrit sur le disque.


## Step 5 — Apply

### 1. Quelle est la structure de terraform.tfstate ?

Le fichier terraform.tfstate est un JSON qui contient :
- version : la version du format du state
- terraform_version : la version de Terraform utilisée
- serial : un compteur incrémenté à chaque modification
- lineage : un UUID unique identifiant ce state
- outputs : les valeurs des outputs déclarés
- resources : la liste des ressources gérées, avec pour chacune leur type, nom, provider et attributs comme filename, content, content_sha1, id, etc.

### 2. Que se passe-t-il si on relance terraform apply sans rien changer ?

Terraform affiche "No changes. Infrastructure is up-to-date." et ne fait rien.
C'est le principe d'idempotence : Terraform compare l'état réel avec l'état désiré dans le code et s'ils sont identiques, il n'exécute aucune action.


## Step 6 — Observer une mise à jour

### 1. Quel symbole apparaît à côté de la ressource ? Que signifie-t-il ?

Le symbole -/+ apparaît. Il signifie que la ressource sera détruite puis recréée (replace).
On voit aussi "forces replacement" dans le plan pour indiquer que c'est le changement de contenu qui en est la cause.

### 2. La ressource est-elle détruite et recréée, ou mise à jour sur place ?

Pour local_file, le changement du content provoque une destruction puis une recréation complète du fichier.
Ce n'est pas une mise à jour en place. Terraform réécrit le fichier entièrement.


## Step 8 — Inspecter le state

### 1. Différence entre terraform state list et terraform show ?

terraform state list affiche uniquement la liste des noms des ressources gérées, par exemple local_file.hello. C'est une vue synthétique.
terraform show affiche tous les attributs de toutes les ressources et les outputs. C'est une vue détaillée complète.
terraform state show suivi d'un nom de ressource est un intermédiaire : il détaille une seule ressource spécifique.

### 2. Quels attributs Terraform suit-il pour local_file ?

Terraform suit notamment :
- filename : le chemin du fichier
- content : le contenu texte
- file_permission : les permissions du fichier, par exemple 0777
- directory_permission : les permissions du répertoire parent
- id : le hash SHA1 du contenu qui sert d'identifiant
- content_md5, content_sha1, content_sha256, content_sha512 : différentes empreintes du contenu


## Step 9 — Destroy

### Combien de ressources seront détruites ?

2 ressources : local_file.hello et local_file.app_config.
Le terraform plan -destroy affiche : Plan: 0 to add, 0 to change, 2 to destroy.


## Résumé du cycle de vie Terraform

L'ordre des commandes est : init, puis plan, puis apply, puis on modifie le code, puis plan, puis apply, et enfin destroy si besoin.

- terraform init : télécharge les providers et initialise le backend
- terraform plan : calcule les différences entre le code et le state actuel
- terraform apply : applique les changements planifiés sur l'infrastructure réelle
- terraform destroy : détruit toutes les ressources gérées
- terraform state list : liste les ressources dans le state
- terraform state show : affiche les attributs d'une ressource du state
- terraform show : affiche l'intégralité du state en format lisible
