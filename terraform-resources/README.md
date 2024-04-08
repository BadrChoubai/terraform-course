# Terraform Resources and Complex Types

Resources in Terraform Configuration are used to represent and define resource in your
remote infrastructure.

A resource type determine what the object is; below is a definition to create an
AWS EC2 Instance:

```terraform
resource "aws_instance" "web" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

  # Some resources may let you define `timeouts` to set constraints on how long
  # an operation can run before being considered in a failing state
  timeouts = {
    create = "60m"
    delete = "2h"
  }
}
```

## Complex Types

A complex type is a type that groups multiple values into a single values. Complex
types are represented by type constructors, but several of them also have shorthand
keyword versions.

Complex types are broken up into two categories:

-   Collection Types
    -   `list`, `map`, and `set`
-   Structural Types
    -   `tuple` and `object`

### Collection Types

```terraform
variable "availability_zones__us_defaults" {
  type               = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "availability_zones__region_default" {
  type = map
  default = {
    "us" = "us-east-1"
    "eu" = "eu-west-1"
    "ap" = "ap-northeast-1"
  }
}
```

### Structural Types

```terraform
variable "with_optional_attribute" {
  type = object({
    a = string         # a required attribute
    b = optional(bool) # an optional attribute
  })

  default = {
    a = "us-east-1"
    b = false
  }
}

variable "region_availability" {
  type = tuple([string, bool])
  default = tuple(["us-east-1", false])
}
```
