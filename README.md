# spacelift POC

### stack1 

/stack1 is creating two outputs `hello_world` and `hello_dog`

### stack2

/stack2 reads output `hello_dog` from `/stack1` and outputs itself `hello_dog`

To enable `stack2` to read the output of `stack1` you have to enable
`External state access` in spacelift on `stack1` and `Administrative` on `stack2`

:grey_exclamation: Be sure to reference stack1's stack id instead of the stack's
name as workspace name in stack2/main.tf. The id doesn't change when you rename
the stack.

### ToDo

- Add spacelift configuration as IaC

