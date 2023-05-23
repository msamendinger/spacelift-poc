# spacelift POC

### foundation

spacelift configuration is managed as terraform files here.

- The stack that points to the foundation subfolder must be an administrative one.
- If you want to use `spacectl stack local-preview --id <stack-id>` the stack
must have `enable_local_preview` set to `true`.
- `policies.tf` contains a plan policy to disallow resource groups without
mandatory tags and a notification policy to send a mattermost message for failed
runs.
- The mattermost webhook is currently manually added to spacelift as the url
must be considered a secret.
- Private worker pool is configured in the file `worker-pool.tf` the worker
itself in `vm.tf` and identity.tf
- The `azure-dev` stack runs on the private worker
- Modules are set up in `modules.tf`
- A context is created and bound to the `foundation` and `azure-dev` stacks.
The ssh public key for the vms and the azurerm env vars are currently
manually added to the context.

### stack1 

/stack1 is creating two outputs `hello_world` and `hello_dog`

### stack2

/stack2 reads output `hello_dog` from `/stack1` and outputs itself `hello_dog`

To enable `stack2` to read the output of `stack1` you have to enable
`External state access` in spacelift on `stack1` and `Administrative` on `stack2`

:exclamation: Be sure to reference stack1's stack id instead of the stack's
name as workspace name in stack2/main.tf. The id doesn't change when you rename
the stack.

### env/dev

/env/dev is the `azure-dev` stack. Used to deploy to Azure.
At the moment only one vm. Using federated credentials to access the Azure API.

### modules

Two modules to test the module registry. The configuration for the modules are
in the `.spacelift` directory. Documentation can be found in the
[module configuration docs](https://docs.spacelift.io/vendors/terraform/module-registry#module-configuration)

### ToDo

- Approval policy
- Use GitHub App on GHES
- Use secrets from Azure Key Vault eg. mattermost webhook

### Questions, thoughts

- stack ID should be a random ID and more prominently featured to avoid confusion
- way to roll everything back if deployment didn't work
- How to work with all the checks in branch protection rules
