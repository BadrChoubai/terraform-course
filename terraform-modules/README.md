# Terraform Modules

Terraform Documentation on Modules: [developer.hashicorp.com](https://developer.hashicorp.com/terraform/language/modules)

## Finding Modules

> The Terraform Registry hosts a broad collection of publicly available Terraform 
> modules for configuring many kinds of common infrastructure. These modules are 
> free to use, and Terraform can download them automatically if you specify the 
> appropriate source and version in a module call block.

When searching the registry, keep in mind that only `verified` module will be 
displayed in the search terms.

## Using Modules

Using modules is done using the `module` call block inside your terraform configuration
file. You may optionally specify a value for `version`. When you run `terraform init`
modules are automatically downloaded and cached.

The syntax for a public module (Terraform Registry) source value looks like: 
`<NAMESPACE>/<NAME>/<PROVIDER>`

The syntax for a private module source value looks like: 
`<HOSTNAME>/<NAMESPACE>/<NAME>/<PROVIDER>`

```terraform
module "aws_vpc" { 
  source = "terraform-aws-modules/vpc/aws"
}
```

### Private Module Access

To configure private module access, you can authenticate against Terraform Cloud 
using `terraform login` or you can create a user API Token and manually configure
the credentials in the CLI config file.

## Publishing Modules

Anyone can publish and share modules on the Terraform Registry, published modules
support. Public modules are managed via a public `git` repository and new versions 
are made available when changes are pushed.

Repositories must be named as: `terraform-<PROVIDER>-<NAME>`.

### Verified Modules

Verified modules are review by HashiCorp and are actively maintained by contributors
to stay up-to-date and compatible with both Terraform and their respective providers.

## Module Structure

```bash
# Standard structure of a terraform project
├── locals.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── modules
│   ├── ecr
│   │   ├── ecr.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── ecs
│       ├── data.tf
│       ├── ecs.tf
│       └── variables.tf
└── providers.tf
```
