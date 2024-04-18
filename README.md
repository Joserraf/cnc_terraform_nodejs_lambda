# Lambda with nodejs modules

This module contains the terraform definition for creating a nodejs lambda in AWS.

## How to use the module

```terraform
module "nodejs_lambda" {
  source                    = "github.com/otto-ec/cnc_terraform_nodejs_lambda?ref=v1.5.5"
  lambda_function_name      = var.lambda_name
  instance_role_arn         = data.aws_iam_role.instance_role.arn
  environment               = var.environment # Optional, you only need to set it if you want to have the lambda in a VPC
  layers                    = var.layers
  memory_size               = var.memory_size # Optional, default is 1024
  depends_on                = [module.sqs_queue]
  lambda_timeout_in_seconds = 60 # default is set to 30
  lambda_reserved_concurrent_executions = 10 # default is set to -1 unreserved
  tracing_enabled           = false # default is set to false
  environment_variables     = {
    VARIABLE_NAME = "some content"
  }
  additional_tags = {
    source_team       = "cnc"
  }
  zip_file_name             = "" # Optional, set it if the name of the zip file to upload is not equal to the lambda name
}
```
