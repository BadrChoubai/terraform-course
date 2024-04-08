# Terraform State

State is used by Terraform to inform on the condition of cloud resources at a given
time.

Terraform preserves state via a state file (JSON) it creates called
`terraform.tfstate`. It is a one-to-one mapping of `resource instances` to
`remote objects`.

## Terraform State Backups

All terraform state subcommands that modify state will write a backup file. This file
is created as `terraform.tfstate.backup`.

## Terraform State Commands

- `terraform state mv`
  - Rename existing resources: `... mv packet_device.worker packet_device.helper`
  - Move a resource into a module: `... mv package_device.worker module.workers.packet_device.worker`
  - Move a module into a module: `... mv module.app module.parent.module.app

### Commands

```bash
Usage: terraform [global options] state <subcommand> [options] [args]

  This command has subcommands for advanced state management.

  These subcommands can be used to slice and dice the Terraform state.
  This is sometimes necessary in advanced cases. For your safety, all
  state management commands that modify the state create a timestamped
  backup of the state prior to making modifications.

  The structure and output of the commands is specifically tailored to work
  well with the common Unix utilities such as grep, awk, etc. We recommend
  using those tools to perform more advanced state tasks.

Subcommands:
    list                List resources in the state
    mv                  Move an item in the state
    pull                Pull current state and output to stdout
    push                Update remote state from a local state file
    replace-provider    Replace provider in the state
    rm                  Remove instances from the state
    show                Show a resource in the state
```
