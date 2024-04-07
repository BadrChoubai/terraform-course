# Troubleshooting

In Terraform there are four errors which you might encounter and need to troubleshoot:

## 1. Language Errors

> Terraform encounters a syntax error in you configuration for the Terraform
> or HCL Language

To trouble shoot a language error, you can run one of several commands:

- `terraform fmt`
- `terraform validate`
- `terraform version`


## 2. State Errors

> The state of your remote resources  has changed from the expected state in your
> configuration file

To troubleshoot a language error, you can run one of several commands:

- `terraform refresh` - Deprecated: `>=v1.5.0` 
- `terraform apply` 
- `terraform apply -replace`

## 3. Core and Providers Errors

> Either a bug has occured with the core library or A provider's API has changed
> or does not work as expected due to emerging edge cases

To troubleshoot a core or provider error, you can:

- Inspect the lof output `TF_LOG`
- View GitHub Issues, and open one if you feel that you've discovered a bug that
  needs fixing

