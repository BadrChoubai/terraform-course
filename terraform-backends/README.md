# Terraform Backends

A Terraform configuration can specify a backend, which is where state data files
can be stored. 

## Configuration

To configure a backend, add a nested backend block within the top-level terraform 
block. A standard backend will only be used to store the configuration state, but an
enhanced backed will also be able to perform operations over your configuration.

If a configuration includes no backend block, Terraform defaults to using the local 
backend, which stores state as a plain file in the current working directory.

```terraform
terraform {
  # A standard backend created to use an AWS S3 storage bucket
  # The backup of your configuration statefile will be stored locally
  backend "s3" {
    bucket         = "example-bucket"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
  }

  # If using Terraform Cloud a `cloud` block is created 
  cloud {
    hostname     = "app.terraform.io"
    organization = "company"

    workspaces {
      tags = ["app"]
    }
  }
}
```

## Initializing a Backend

Running `terraform init` with the `-backend-config` flag can be used for partial
backend configuration.

```bash
terraform init -backend-config=backend.hcl
```

Running the above command tells terraform to use the configuration stored in
`backend.hcl` to fill out the configuration value for the `backend` block in `main.tf`.

```terraform
# main.tf
terraform {
  required_version = ">= 1.2.0"

  backend "remote" {}
}

# backend.hcl
workspaces    = { name = "workspace" }
hostname      = "app.terraform.io"
origanization = "company"
```

## Remote State

Using the `terraform_remote_state` data source will retrieve and use the root
module output values from another Terraform configuration, using the latest state
snapshot from the remote backend.

`terraform_remote_state` only exposes output values which often include sensitive
information. It is recommended to explicitly push data for external consumption
to a separate location instead of access it via remote state.

```terraform
data "aws_s3_bucket" "staging" {
  bucket = "bucket.staging.com"
}

resource "aws_instance" "web" {
  subnet_id = "${data.aws_s3_bucket.staging.subnet_id}"
}
```

## State Locking

State locking is done automatically for all operations that could write state.
Preventing others from from acquiring the lockfile and potentially corrupting it.

Terraform does not notify if a lock is complete, if the operation takes longer than
expected, it will output a status message.

Terraform has a `force-unlock` command to manually unlock state if doing so fails.
If you unlock the state when someone else is holding the lock it could cause downstream
issues as multiple writers will be created.

```bash
terraform force-unlock LOCK_ID
```

The value for `LOCK_ID` is available only if an attempt to unlock state has failed
previously.

## Protecting Sensitive Data

A statefile can contain sensitive data and is a possible attack vector for
malicious actors.

### Local State

When using a local backend, state is store in plan-text JSON (`.json`) files:

- DO NOT share this file to anybody
- DO NOT commit this file to your `git` repository 

### Remote State (Terraform Cloud)

A benefit to using Terraform Cloud is it has built-in guarantees for securing
information about the statefile

- The statefile is held on in-memory and is not persisted to disk.
- The statefile is encrypted at-rest and in-transit
- With Terraform Enterprise you have detailed audit logging for tamper
  evidence

### Remote State with Third-Party Backends

You can store state with Third-Party backends (i.e. S3), but you should vet your
choices' capabilities and determine if it will meet your standards for security
and compliance.

Given the example of using S3, you would need to ensure that encryption and 
versioning are turned on and create a custom trail for data events.

#### Terraform Ignore File

When executing a remote plan or apply in a CLI-driven run, an archive of your
configuration directory is uploaded to Terraform Cloud. You can define paths to
ignore with `.terraformignore` file at the root of you configuration directory.

If the file is not present, the archive will exclude only the `.git/` and
`.terraform/` directories.

#### .gitignore [Source Code](https://github.com/github/gitignore/blob/main/Terraform.gitignore)

```gitignore
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.
*.tfvars
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc
```

