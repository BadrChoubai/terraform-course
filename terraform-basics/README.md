# Terraform Basics

This chapter will go over some basic of Terraform introducing the learner to key
concepts

Terraform Best Practices: <https://www.terraform-best-practices.com/>

## Terraform Lifecyle

1. Write or Update your Terraform Configuration file
2. use `terraform init` to initialize your project and pull latest providers and
   modules
3. use `terraform plan` to generate output of planned changes which you may optionally
   save
4. use `terraform validate` to ensure that types and values are presents and that
   required attributes are present
5. use `terraform apply` to execcute and provision the infrastructure from the plan
   created in the previous command
6. use `terraform destroy` to destroy remote infrastructure

### Commands

```bash
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.
```

## Change Automation

Terraform uses Change Automation in the form of Execution Plans and Resources Graphs
to apply and review complex ChangeSets

- What is Change Management?

  - A standard approach to apply change and resolve conflicts brough about by change
  - In the context of Infrastructure as Code, change management is the procedure that
    will be followed when resources are modified and applied by configuration script

- What is Change Automation?
  - A way of _automatically_ creating a consistent, systematic, and predictable
    way of managing change requests via organizational controls and policies

### Execution Plans

An Execution Plan is a manual review of what resources will be add, changed, or
destroyed before you apply changes. [`terraform apply`]

```bash
Usage: terraform [global options] apply [options] [PLAN]

  Creates or updates infrastructure according to Terraform configuration
  files in the current directory.

  By default, Terraform will generate a new plan and present it for your
  approval before taking any action. You can optionally provide a plan
  file created by a previous call to "terraform plan", in which case
  Terraform will take the actions described in that plan without any
  confirmation prompt.
```

### Visualizing Execution Plans

You can visualize the execution plan using the `terraform graph` command, which
will output a GraphViz file. This will show you the relationships between all of
the planned infrastructure in your configuration.

```bash
terraform graph | dot - Tsvg > graph.svg
```
