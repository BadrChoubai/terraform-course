# Terraform Language

This lesson covers the Domain-Specific Language (DSL) used by Terraform called
HCL.

## `.tf` File Syntax

```terraform
resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami = "ami-abc123"
}
```

## Alternative Syntax (JSON-Compatible)

Useful when generating portions of configuration programatically as existing JSON
libraries can be used to prepare the generated file.

```json
{
    "resource": {
        "aws_instance": {
            "example": {
                "instance_type": "t2.micro",
                "ami": "ami-abc123"
            }
        }
    }
}
```

## Terraform Settings

The `terraform {}` block inside of a configuration file is used to configure of
Terraform itself

```terraform
terraform {
    # The expected version of terraform
    required_version = ""

    # The providers which will be pulled when running `terraform init`
    required_providers {}

    # Experimental language features
    experiments {}

    # Module-specific information for providers
    provider_meta {}
}
```

## Variable Definition

Variables are used by terraform modules to define parameters for use in configuration.

```terraform
variable "bucket_name" {
  default     = "terraform-state-bucket"
  description = "Remote S3 Bucket Name"
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
    error_message = "Bucket name must not be empty and must follow S3 naming rules."
  }

  # Show/Hide value in configuration output
  # sensitive = true|false
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.bucket_name
  force_destroy = true
}
```

### Environment Variables

Terraform will look for variables defined in your environment that start with
`TF_VAR_`

## Loading Variables

-   Default auto-loaded files: `terraform.tfvars[.json]`, automatically loaded by
    running `terraform apply`
-   Other variable files: `development.tfvars`, not automatically loaded and must be
    specified in running the command (with `-var-file`). Naming the file with:
    `development.auto.tfvars` tells terraform to load the file automatically
-   If you only need to overwrite a single variable you can use the `-var` flag on it
    and providing the new value

### Load Precedence

1. Environment Variables
2. `terraform.tfvars`
3. `terraform.tfvars.json`
4. `*.auto.tfvars` or `*.auto.tfvars.json`
5. `-var` and `-var-file` flag

## Output Values

Output values are computed values which may be viewed after a `terraform apply`
is performed, allowing you to:

-   Obtain information after resource provisioning is done (i.e. public IP address)
-   Output a file of values for programattic integration
-   Cross-reference stacks view outputs in a state file via `terraform_remote_state`

```terraform
output "repository_url" {
    description = "The Repository URL created inside of ECR"
    value       = aws_ecr_repository.demo_app_ecr_repo.repository_url
    sensitive   = false # if set to true, will still be viewable within the statefile
}
```

### Command for Viewing Output of a Configuration

```bash
Usage: terraform [global options] output [options] [NAME]

  Reads an output variable from a Terraform state file and prints
  the value. With no additional arguments, output will display all
  the outputs for the root module.  If NAME is not specified, all
  outputs are printed.

Options:

  -state=path      Path to the state file to read. Defaults to
                   "terraform.tfstate". Ignored when remote
                   state is used.

  -no-color        If specified, output [will not] contain any color.

  -json            If specified, machine readable output will be
                   printed in JSON format.

  -raw             For value types that can be automatically
                   converted to a string, will print the raw
                   string directly, rather than a human-oriented
                   representation of the value.
```

## Local Variables

A local value (`locals` block) assigns a name to an expression, so you can
use it multiple times within the same module. Once declared they are accessible
by `lcaol.<NAME>`.

```terraform
locals {
  bucket_name = "dk-tf-demo"
  table_name  = "dkTfDemo"
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}
```

## Data Sources

Data sources allow Terraform to use information defined outside of it,
defined by another configuration, or modified by functions.

```terraform
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}
```

## Values

-   Named values in Terraform are built-in expressions used to reference
    various values:

        ```text
        Resources:              `<RESOURCE_TYPE>.<NAME>`
        Input Variables:        `var.<NAME>`
        Local Values:           `local.<NAME>`
        Child Module Outputs:   `module.<NAME>`
        Data Sources:           `data.<DATA_TYPE>.<NAME>`
        ```

-   Filesystems and workspace info can also be accessed:

    ```text
    path.module         - path of the module where the expression is placed
    path.root           - path of the root module of the configuration
    path.cwd            - path of the current working directory
    terraform.workspace - name of the currently selected workspace
    ```

-   Block-local values (within block bodies)

    ```text
    count.index             - when you use the count meta argument
    each.key / each.value   - when you use the _each meta argument
    self.<attribute>        - self-reference information within the block
    ```

-   Resource Meta Arguments (change behaviour of resources)
-   ```text
    depends_on            - for specifying explicit dependencies
    count                 - for creating multiple resource instances according to a count
    for_each              - for creating multiple instance according to a map, or set of strings
    provider              - for selecting a non-default provider configuration
    lifecycle             - for lifecycle customizations
    provision, connection - for taking extra action after resource creation
    ```
