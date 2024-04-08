# Terraform Workflow

This chapter covers the commands used by terraform to dictate the flow of work in
a terraform project.

## Terraform Init `terraform init`

Running `terraform init` is used to initialize your terraform project inside the directory
for which it is run. Generally, you will run this command when beginning a new project
using terraform. Also, if you modify or change dependencies you will need to run it
again to apply the updates. It does the following:

    - Download plugin dependencies (Providers, Modules)
    - Create a `.terraform` directory
    - Create a dependency lock file to enforce expected versions for plugins and
    terraform itself
    - If supported by your backend, locks your state to prevent writes for all 
    operations that could write state

Running `terraform init` with the `-upgrade` flag will upgrade all plugins to the
latest version accounting for their version constraints

Running `terraform init` with the `-get-plugins-false` flag will skip plugin installation

Running `terraform init` with the `-plugin-dir=PATH` flag will install plugins only
from the given directory PATH

Running `terraform init` with the `-lockfile=MODE` flag lets you set the mode on
the dependency lockfile 

### `terraform get`

The `terraform get` command may be used if you are developing your own terraform module,
in this case, you may not need to initialize state or pull new provider binaries. 

## Writing and Modifying Terraform Code

Terraform has a set of "utility" commands which you can use when developing your
terraform project. 

### `terraform fmt`

This command may be run to rewrite your configuration files to a standard format
and style. Similar to running `go fmt` or `npx prettier --write .`, it can be used
to format your terraform code.

The command will only format files in the directory that it is called in, if you have
subdirectories containing other configuration files, use the `-recursive` flag to
format the files in them as well.

```bash
terraform fmt -recursive
```

To preview the changes being made by the command use the `--diff` flag:

```bash
terraform fmt --diff
```

### `terraform validate`

This command may be run to validate the syntax and arguments of the configuration files
in your Terraform project. Running `terraform plan` or `terraform apply` includes a 
step that runs `terraform validate`.


### `terraform console`

This command may be run to create an interactive shell for testing expressions
that you'd like to include in your configuration files.

## Terraform Plan `terraform plan`

Running `terraform plan` is done to generate the "Execution Plan" that will be used
to create resources, which consists of:

    - Reading the current state of any pre-existing remote objects to make sure
    that the state is up-to-date
    - Comparing the current configuration to the prior state an noting any differences
    - Proposing a set of change actions that should, if applied, make the remote
    object match the configuration

**The command does not carry out the proposed changes, the is done only by `terraform apply`**

There are two types of plans which Terraform will work with:

- Speculative Plan
    - Created with `terraform apply`
    - Terraform outputs the description of the plan without any intention of
    running it
- Saved Plan
    - Create with `terraform apply -out=FILE`
    - This will generate a plan file which can then be passed to `terraform apply [FILE]`.
    When using a saved plan, it will not prompt you to confirm and will act like auto-approve

## Terraform Apply `terraform apply`

Running `terraform apply` is done to execution the actions proposed in an Execution Plan and, ter
it runs in two modes.

- Automatic Plan Mode
    - Run `terraform apply`
    - Executes plan, validate, and the apply
    - Requires users to manually approve the plan by writing "yes", unless `-auto-approve`
    flag is passed
- Saved Plan Mode
    - Running `terraform apply FILE`
    - Performs exactly the steps specified by the plan file and does not prompt
    for approval. If you'd like to preview changes you can run `terraform show`

### Commands

```bash
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure
```
