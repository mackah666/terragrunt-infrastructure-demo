locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  # Merge tags 
  common_tags = read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))

  env_tags = {
      Component      = "RDS"
      Environment    = local.environment_vars.locals.environment
      Team           = "The A Team"
  }
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:mackah666/terragrunt-test-modules.git//mysql?ref=v1.16.7"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name           = "mysql_${local.env}"
  instance_class = "db.t2.micro"

  allocated_storage = 100
  storage_type      = "standard"

  master_username = "admin"

  default_tags = merge(local.common_tags.locals.default_tags, local.env_tags)
  # TODO: To avoid storing your DB password in the code, set it as the environment variable TF_VAR_master_password
}
