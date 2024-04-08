# Configuration Drift

Configuration drift is when your expected resources are different from your expected
state. Using Terraform, we can resolve the issue in three ways:

1. Replacing Resources
    - When a resource has become damaged or degraded in a way that cannot be detected
    by Terraform we can use the `-replace` flag
2. Importing Resources
    - When an approved manual addition of a resource needs to be performed we can
    use the `import` command
3. Refresh State 
    - When an approved manual configuration of a resource has changed or removed we can
    use the `-refresh-only` flag to reflect those changes in our state file

## Replacing Resources

> A cloud resource can become _degraded_ or _damaged_ and you want to return
> the expected resource to a healthy state

Terraform has the abiliy to mark a resource for replacement, this is done by the
`-replace` flag which may be passed to `terraform apply` or `terraform plan`

This flag Instructs Terraform to plan to replace the resource instance with the
given address. This is helpful when one or more remote objects have become degraded,
and you can use replacement objects with the same configuration to align with 
immutable infrastructure patterns.

### Command Usage

```bash
terraform apply -replace="aws_instance.example[0]"
```

## Importing Resources

The `terraform import` command may be used to import existing resources into
a configuration. This is done by defining a placeholder for the resource you'd like
to import and running the command. Its configuration will not be generated and output
to the file, you will need to do this manually after the fact. Not all resources
are importable so double-check the documentation to see if it may be imported

```terraform
resource "aws_instance" "example" {}
```

```bash
terraform import aws_instance.example i-abcd1234
```

### Terraform >=v1.5.0 Support for `import` Block

Support for the usage of an import block has been added in recent versions of Terraform
which allow you to import resources inside of the configuration itself.

>```terraform 
>import {
>  to = aws_instance.example
>  id = "i-abcd1234"
>}
>
>resource "aws_instance" "example" {} 
> ```
> The above import block defines an import of the AWS instance with the ID 
> "i-abcd1234" into the aws_instance.example resource in the root module.
>
> The import block has the following arguments:
>
>    - `to` - The instance address this resource will have in your state file.
>    - `id` - A string with the import ID of the resource, or an expression that
>       evaluates to a string.
>    - `provider` (optional) - An optional custom resource provider, see The 
>       Resource provider Meta-Argument for details.

[Import Block Documentation](https://developer.hashicorp.com/terraform/language/import)

## Refreshing Resources

Running the `terraform apply` command in refresh-only mode may be used to refresh
and update your state file without making changes to your remote infrastructure. The
below scenario highlights its utility.

> ### Scenario
>
> As a DevOps engineer you create a terraform configuration that deploys a Virtual Machine
> on AWS. You ask an engineer to terminate the server, and instead of updating the terraform
> configuration they mistakenly terminate the server via the AWS Command Line.
> 
> How will the `terraform apply` command behave?

#### Running `terraform apply`

- Terraform will notice that the VM is missing
- Terraform will propose to create a new VM
- The changes to the infrastructure match the state file
- The infrastructure will be created and match the state file

#### Running `terraform apply -refresh-only`

- Terraform will notice that the VM you provisioned is missing
- But by using the `refresh-only` flag, it knows that the missing VM is intentional
- Terraform will propose to delete the VM from the state file

## Resource Addressing

A resource address is a string that `identifies zero or more resource instances`
in your configuration.

### Addressing Structure

- Module Path - addresses a module within the tree of modules
    - `module.module_name[module_index]`
        - `module` namespace of a module
        - `module_name` user-defined name of a module

- Resource Spec - adresses a specific resource instance in the selected module 
    - `resource_type.resource_name[instance_index]`
        - `resource_type` type of the resource being addressed
        - `resource_name` user-defined name of the resource

