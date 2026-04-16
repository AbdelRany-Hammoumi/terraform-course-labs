# Lab 3 — Remote State & Backends — Réponses

## Step 2 — Inspection de l'état par défaut

1. Où est le fichier d'état par défaut ?
   Le fichier terraform.tfstate est stocké dans le répertoire de travail courant.

2. Quel est le numéro serial dans le fichier d'état ?
   Après le premier terraform apply, le serial était 1. Il augmente à chaque modification de l'infrastructure.

3. Que contient terraform.tfstate.backup ? Quand estil créé ?
   Il contient la version précédente du fichier d'état. Il est créé automatiquement avant chaque modification de l'état (apply, destroy, state mv), pour permettre un retour arrière en cas de problème.

## Step 5 — Migration de l'état

 La commande terraform init migratestate a migré l'état depuis ./terraform.tfstate vers state/terraform.tfstate.
 Le terraform plan après migration affiche No changes : la migration est sans perte de données.

## Step 7 — Observation du verrouillage d'état (State Locking)

 Le backend local utilise un fichier .terraform.tfstate.lock.info pour verrouiller l'état pendant une opération.
 Si Terminal 1 est en attente d'approbation (terraform apply), Terminal 2 obtient une erreur du type :  
  Error: Error locking state: Error acquiring the state lock
 Le message de lock contient : l'ID du lock, l'opération en cours, la date, et le chemin du fichier.

## Step 8 — Manipulation de l'état

 terraform state mv local_file.metadata local_file.info renomme la ressource dans l'état sans la détruire.
 Après avoir mis à jour le code (main.tf) pour utiliser local_file.info, terraform plan affiche No changes.
 Cela prouve que state mv préserve le lien entre la ressource réelle et la configuration Terraform.
