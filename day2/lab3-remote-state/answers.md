# STEP 2
1. The `terraform.tfstate` file is stored in the local backend by default, here it's the current directory, hence in our case the file is stored in `day2/lab3-remote-state/starter`
2. The serial number corresponds to the current iteration of the build and ensures that there is no version conflict between two builds.
3. The `terraform.tfstate.backup` file contains the previous state build, to allow backpedalling/backtracking in case of issues.

# STEP 7
1. Terminal 2 fails
2. The error message is the following
```
Error: Error acquiring the state lock
│ 
│ Error message: resource temporarily unavailable
│ Lock Info:
│   ID:        ce5c8726-ce98-0f8f-2a72-b188cf0e3eb0
│   Path:      state/terraform.tfstate
│   Operation: OperationTypeApply
│   Who:       gralfjord@GralfJord-L-ordinateur
│   Version:   1.11.4
│   Created:   2026-04-16 11:32:42.856832435 +0000 UTC
│   Info:      
│ 
│ 
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.
╵
```
Simply put, it forbids any actions that would modify the tfstate, as an action is currently locking it for use.
3. The `.terraform.tfstate.lock.info` file contains the following :
`{"ID":"ce5c8726-ce98-0f8f-2a72-b188cf0e3eb0","Operation":"OperationTypeApply","Info":"","Who":"gralfjord@GralfJord-L-ordinateur","Version":"1.11.4","Created":"2026-04-16T11:32:42.856832435Z","Path":"state/terraform.tfstate"}`
Simply put, it contains the info of the currently locking action, in our case the pending apply action, which can be seen with the `Operation` paramater : `{"Operation":"OperationTypeApply"}`.
It also contains the author of the current action, its creation timestamp, its ID and the current `terraform.tfstate` file.