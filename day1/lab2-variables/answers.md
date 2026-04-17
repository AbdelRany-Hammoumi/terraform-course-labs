# STEP 5
1. The winnign value is `terraform plan -var="environment=staging"`, as the TF_VAR is ignored.
# GOING FURTHER
1. Trying to plan after simply adding the sensitive variable into a resource prompts us to enter the sensitive value by hand (since no default value was entered), then raises the following error :
```
╷
│ Error: Output refers to sensitive values
│ 
│   on outputs.tf line 7:
│    7: output "config_content" {
│ 
│ To reduce the risk of accidentally exporting sensitive data that was intended to be only    
| internal, Terraform requires
│ that any root module output containing sensitive data be explicitly marked as sensitive, to 
| confirm your intent.
│ 
│ If you do intend to export this data, annotate the output value as sensitive by adding the 
| following argument:
│     sensitive = true
╵
```
The issue is the sensitive value contained by the variable is outputted into non-sensitive outputs, which Terraform doesn't allow. It can be fixed by adding `sensitive = true` to the related outputs.

after the fix, the plan indicates
```
Changes to Outputs:
  + config_content    = (sensitive value)
  + config_filename   = "./my-terraform-lab-config-dev.json"
  + project_summary   = (sensitive value)
  + read_back_content = (known after apply)
```
2. **see variables.tf + main.tf**
3. **see outputs.tf**
4. **see dev.tfvars + prod.tfvars**