locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  # Merge tags 
  common_tags = read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))

  env_tags = {
    Component   = "ALB-ASG-Webserver-Cluster"
    Environment = local.environment_vars.locals.environment
    Team        = "DevOps"
  }
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:mackah666/terragrunt-test-modules.git//asg-elb-service?ref=v1.16.8"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name          = "webserver-example-${local.env}"
  instance_type = "t2.micro"

  ami_id = "ami-0f052119b3c7e61d1"

  min_size = 3
  max_size = 3

  server_port = 8080
  elb_port    = 80

  default_tags = merge(local.common_tags.locals.default_tags, local.env_tags)

}
