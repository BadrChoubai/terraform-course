# Team Workflows

As a team and its requirements grow, its publishing workflow will evolve. Below
is a workflow for which teams may start off producing infrastructure-as-code:

> The Terraform workflow has three steps:
>
> 1. Write - Author infrastructure as code
> 2. Plan - Preview change before applying them
> 3. Apply - Provision reproducible infrastructure

### Individual Practitioner

1. Write
   - Write configuration in editor of choice
   - Store configuration in a version-control system (GitHub, GitLab, etc.)
   - Repeatedly run `terraform plan` and `terraform validate` to find syntax
     errors
   - Maintain a tight feedback-loop between editing configuration and running test
     commands
2. Plan
   - When the developer is confident with their work in their write step they can
     commit their code to the repository
3. Apply
   - They will run terraform apply and be prompted to review their plan
   - After their final review they will approve the changes and await provisioning
   - After a successful provision they will push their local commits (as the statfile
     has been created/updated) to the remote repository

### Team

1. Write
   - Each team member writes code locally on their machine
   - Each team member stores their code in separate branches
   - Branches will allow an opportunity to resolve conflict when changes are
     merged to the `main` branch
   - `terraform plan` can be used as a quick feedback loop for small teams
   - For larger teams credentials may need to be managed
     - A CI/CD process can be setup to store those in its running environment,
       team members can push to their branch on a frequent basis to run terraform
       plan inside of it.
2. Plan
   - When a branch is ready to be incorporated, a pull request can be made with
     the Execution Plan generated and displayed in the changes for review.
3. Apply
   - To apply the changes the merge should be approved to kick off the build server
     that runs the `terraform apply` command

#### Operation Concerns

- Setup and maintain a CI/CD pipeline
- Solve for storing the state file
- Limited access controls no granularity over which actions are allowed to be
  performed by individual members
- Solve for storing and injecting secrets into the build server runtime environment
- Managing multiple environments can make overhead increase dramatically

### Terraform Cloud (#AD)

Terraform Cloud can streamline the CI/CD effort from the previous structure and
includes several features for securing builds and making your infrastructure code
auditable.

1. Write
   - A team will use Terraform Cloud as their remote backend
   - Input variables will be stored on it, instead of local machines
   - Terraform Cloud integrates with your VCS to quickly setup a CI/CD pipeline
   - Team members can write code to their branch and commit normally
2. Plan
   - A pull request is created by a team member and Terraform Cloud will generate
     the speculative plan for review in the VCS. Teams can review and comment on the
     plan in Terraform Cloud
3. Apply
   - After the pull request is merged, Terraform Cloud's runtime environment will
     perform the `terraform apply` and a team member will be able to confirm and apply
     the changes
