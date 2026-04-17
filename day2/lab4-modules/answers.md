# STEP 7
1. `terraform apply` will create 6 resources
2. terraform will name the resources using prefixes that indicate which modules the resources are related to. For instance, there will be two instances of each resource, one using the prefixe `module.frontend.` and one using `module.backend.`.
3. The backend module is created first since the frontend needs some of the backend's configuration to be set up (such as the URL and ports)

# STEP 9
1. The containers are removed then recreated with the new config (`-/+` symbol)
2. The containers now have their names ending with `-staging` (as it is the used environment)
3. The config_file names have also changed to used the specified environment `backend-staging-config.json`

# STEP 10
1. It fails and states the following error
```
╷
│ Error: Unsupported attribute
│ 
│   on outputs.tf line 23, in output "frontend_image_id":
│   23:     value = module.frontend.docker_image.app.image_id
│     ├────────────────
│     │ module.frontend is a object
│ 
│ This object does not have an attribute named "docker_image".
╵
```
It cannot find the referenced attribute `docker_image` within the item `frontend`