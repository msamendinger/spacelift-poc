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

### modules

Two modules to test the module registry. The configuration for the modules are
in the `.spacelift` directory. Documentation can be found in the
[module configuration docs](https://docs.spacelift.io/vendors/terraform/module-registry#module-configuration)

### ToDo

- Notification policy mattermost webhook
- Policy are tags on resource group
- Approval policy
- local run with spacectl
- Use GitHub App on GHES

