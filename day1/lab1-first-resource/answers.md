# STEP 2
1. It was downloaded in the local `.terraform` folder
and created the `terraform.lock.hcl` file to save the latest configuration
2. It contains the configuration of the latest terraform build
3. you shouldn't commit the .lock file because it can be generated from the main.tf file.
(the latter should be committed).

# STEP 3

# STEP 4
1. It will create one (1) resource
2. The plus symbol means it is creating 
3. The id will be the identifier of the terraform build,
currently shown as `know after apply` as the build is yet to be created

# STEP 5
1. It has the structure of a JSON file,
we can recognize the `resources`, `id`, `filename` and `type` fields
2. It doesn't run because there are no changes detected, hence no need to rebuild

# STEP 6
1. The symbol this time is a "tilde" `~`,
as the files mentionned will need modifications (not creations or deletions)
and there is a `-/+` symbol for the resource which signifies that it is not updated but rather deleted and re-created.
2. The resource is deleted then recreated (see the `-/+` symbol)

# STEP 7

# STEP 8
1. `terraform state list` displays the different resources : `<type>.<name>`
`terraform show` displays the configurations of the different resources
2. terraform tracks the type, name, content, encoding of the content, permissions (directory and file) and id of each resource

# STEP 9
1. Both resources will be `destroyed`
