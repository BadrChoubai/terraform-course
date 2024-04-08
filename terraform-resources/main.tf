terraform {}

variable "with_optional_attribute" {
  type = object({
    a = string         # a required attribute
    b = optional(bool) # an optional attribute
  })

  default = {
    a = "us-east-1"
  }
}

variable "region_availability" {
  type    = tuple([string, bool])
  default = ["us-east-1", false]
}
