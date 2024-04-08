# Terraform Expressions

Expressions are used to `refer to` or `compute values` within a configuration:

## Types and Values

```text
- Primitive Types
    string        `value = "string"`
    number        `size = 0.0`
    bool          `bool = true` 

- Complex, Structural, Collection Types
    list(tuple)   `regions = ["us-east", "us-west"]`
    map(object)   `tags = { env = "Production", priority = 3 }

- No Type
    null          `value = null` - null represents absence or omission
```

## Strings and Templates

- strings are creating using double quotes `"string"`
- For multi-line strings you would use "heredoc" syntax

    ```text
    <<EOT
    hello
    world
    EOT
    ```

- string interpolation syntax 
    - `Region: ${local.region}` 
- directives can be used for evaluating logic inside of templated strings and
multi-line strings
    - `%{if <BOOL>}`/`%{else}`/`%{endif}`
    - `%{for <NAME> in <COLLECTION>}` / `%{endfor}`

## Expressions

### Conditional Expressions

Terraform supports the use of ternary if else conditions: 
`condition ? true : false`, the type of the values being compared must be the same.

### For Expressions

For expressions allow you to iterate over a complex type and apply transformations
as input a list, set, tuple, map, or object may be used.

- Lists `[] returns a tuple value`
    - `[for n in var.list : tostring(n)]`       =>  `["1", "2", ... ]`
    - `[for i, v in var.list : "${i} is ${v}"]
- Maps and Objects `{} returns an object value`
    - `for k, v in var.map : join("-", [k, v])` => `{ k = "k-v", ... }`

### Splat Expressions

A Splat expression provides a shorter expression for `for` expressions

The splat operator (`*`) turns this expression: `[for v in var.list : v.id]`, 
into: `var.list[*].id`

The have a special behavior when applied to lists:

- if the value is anything other than a null value, then the splat expression willl
transform it into a single-element list
- if the value is null then the splat express will return an empty tuple

The behavior is useful for modules that accept optional input variables whose
default value is null to represent the absence of any value.

## Dynamic Blocks

Dynamic blocks allow you to dynamically construct repeatable nested blocks, the
example shows a use case for which we dynamically create security group ingress
rules using a list of rules stored in the local `ingress_rules`

```terraform
locals {
  ingress_rules = [{
    port        = 443
    description = "Port 443"
  },
  {
    port        = 80
    description = "Port 80"
  }]
}

resource "aws_security_group" "main" {
  name      = "sg"
  vpc_id    = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocal    = "tc" 
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```
 
## Version Constraints

Terraform uses Semantic Versioning for specifying Terraform, Provider and Module
versions.

1. MAJOR - Version when you make incompatible API changes
2. MINOR - Version when you add functionality in a backwards-compatible manner
3. PATCH - Version when you make backwards compatible bug fixes

A version constraint is a string containing one or more conditions, separated by commas

- `=1.0.0` - Match exact version number
- `!=1.0.0` - Exclude exact version number
- `< |<= | > | >= 1.0.0` - Compare against a specific version
- `~>1.0.21` - Allow only the rightmost number to increment 

### Progressive Versioning

Progressive Versioning is the practive of using the latest version to keep a
progressive stance on security, modernity, and development agility.

Setting up nightly builds of your golden images or terraform plans can act as a
warning signal to budget time to fix issues without an outage. 

