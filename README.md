# spacelift POC

### foundation

spacelift configuration is managed as terraform files here.

The stack that points to the foundation subfolder must be an administrative one.

### stack1 

/stack1 is creating two outputs `hello_world` and `hello_dog`

### stack2

/stack2 reads output `hello_dog` from `/stack1` and outputs itself `hello_dog`

To enable `stack2` to read the output of `stack1` you have to enable
`External state access` in spacelift on `stack1` and `Administrative` on `stack2`

:exclamation: Be sure to reference stack1's stack id instead of the stack's
name as workspace name in stack2/main.tf. The id doesn't change when you rename
the stack.

### ToDo

- Modules in subfolders of repo
  - versioning
- Notification policy mattermost webhook
- Policy are tags on resource group
- Approval policy
- local run with spacectl

### Teardown external infrastructure

- delete acr for runner-terraform:azure-latest
