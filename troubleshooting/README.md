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

> The state of your remote resources has changed from the expected state in your
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

## Debugging in Terraform

> Terraform has detailed logs that you can enable by setting the TF_LOG environment
> variable to any value. Enabling this setting causes detailed logs to appear on stderr.
>
> You can set TF_LOG to one of the log levels (in order of decreasing verbosity)
> TRACE, DEBUG, INFO, WARN or ERROR to change the verbosity of the logs.
>
> Setting TF_LOG to JSON outputs logs at the TRACE level or higher, and uses a
> parseable JSON encoding as the formatting.
>
> ---
>
> [Debugging Documentation](https://developer.hashicorp.com/terraform/internals/debugging)

Logging can be enabled separately for `TF_LOG_CORE` and `TF_LOG_PROVIDER` if you'd
like to selectively enable it. Setting the path for logging output is done using the
`TF_LOG_PATH` environment variable.

If terraform crashes, a log file is saved with the debug logs from the session
as well as the panic message and backtrace to a file called: `crash.log`
