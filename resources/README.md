# Resources

## Resource Meta Arguments

Terraform language defines several meta-arguments, which can be used with any
resource type to change the behavior of resources

### `depends_on`

Used to set the precedence of resources being provisioned and can be set when one
resource depends on another for its creation.

Terraform can implicitly determine the order of provision for resources but there
may be some cases where it cannot determine the correct order

```terraform
resource "aws_iam_role_policy" "example" {
  policy = ""
  role   = ""
}

resource "aws_instance" "example" {
  ami           = ""
  instance_type = ""

  depends_on = [
    aws_iam_role_policy.example,
  ]
}
```

### `count`

When you are managing a pool of objects, like a fleet of Virtual Machine you can
use `count`

```terraform
resource "aws_instance" "server" {
  count = 4 # Create four similar EC2 instances
  # count = length(var.subnet_ids)

  ami           = "ami-abc123"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
```

### `foreach`

Similar to `count` for managing multiple related objects but you
can iterate over a map for more dynamic values

```terraform
resource "azurerm_resource_group" "rg" {
  for_each = {
    us_group = "southcentralus"
    eu_group = "francecentral"
  }

  name     = each.key
  location = each.value
}
```

## Resource Behaviour and Lifecycle

When you execute your resource plan using `terraform apply`, it will
perform one of the following to a resource:

1. Create (`+ create`)
    - Resources that exist in the configuration but are not associated with a real
      infrastructure object in the state
2. Destroy (`- destroy`)
    - Resources that exist in the state but no longer exist in the configuration
3. Update in-place (`~ update in-place`)
    - Resources whose arguments have changed
4. Destroy and re-create (`-/+ destroy and the create replacement`)
    - Resources whose arguments have changed but which cannot be update in-place
      due to remote API limitations

### Lifecycle Blocks

Lifecycle block allows you to change what happens to a resource

-   `create_before_destroy(bool)`
    -   when replacing a resource, first create the new resource before deleting it
-   `prevent_destroy(bool)`
    -   Ensures a resource is not destroyed
-   `ignore_changes(list)`
    -   Don't change the resource (create, update, destroy) the resource
        if a change occurs for the listed attributes

```terraform
resource "azurerm_resource_group" "example" {
  lifecycle = {
    create_before_destroy = true
  }
}
```

## Resource Providers and Alias

```terraform
provider "google" {
  region = "us-central"
}

provider "google" {
  alias  = "europe"
  region = "europe-west1"
}

resource "google_compute_instance" "example-us" {
  provider = google
}

resource "google_compute_instance" "example-eu" {
  provider = google.europe
}
```
