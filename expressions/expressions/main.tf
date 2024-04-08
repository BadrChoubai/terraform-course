terraform {

}

/**
For the lesson, use `terraform console` and test that you can print "Hello, world"

> "Hello, ${var.hello}"
"Hello, world"
*/
variable "hello" {
  type = string
}

/**
For the lesson, use `terraform console` and test that you can iterate over the
list of planets

> [ for p in var.planets : p ]
[
  "moon",
  "mars",
  "jupiter",
  "saturn",
]
*/
variable "planets" {
  type = list(any)
}

/**
For the lesson, use `terraform console` and test that you can iterate over the
list of planets using the splat operator
> var.planets_splat[*]
tolist([
  {
    "distance_from_earth" = "1.31ls"
    "planet" = "Moon"
  },
  {
    "distance_from_earth" = "4.35lm"
    "planet" = "Mars"
  },
  {
    "distance_from_earth" = "34.95lm"
    "planet" = "Jupiter"
  },
  {
    "distance_from_earth" = "1.18lh"
    "planet" = "Saturn"
  },
])
*/
variable "planets_splat" {
  type = list(any)
}

/**
For the lesson, use `terraform console` and test that you can iterate over the keys
and values inside of planets_light_distance

> { for i, p in var.planets_light_distance : "${i}" => p }
{
  "Jupiter" = "34.95lm"
  "Mars" = "4.35lm"
  "Moon" = "1.3ls"
  "Saturn" = "1.18lh"
}
*/
variable "planets_light_distance" {
  type = map(any)
}

