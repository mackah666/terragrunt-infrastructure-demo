locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  # https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example.git
  source = "git@github.com:mackah666/terragrunt-test-modules.git//iam-user?ref=v1.14.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name = "yusef.ackah"
  create_iam_user_login_profile = true
  create_iam_access_key         = true
  pgp_key = "keybase:test"
}
