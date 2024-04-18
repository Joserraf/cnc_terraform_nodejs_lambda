variable "lambda_function_name" { type = string }
variable "instance_role_arn" { type = string }

variable "environment_variables" {
  type    = map(string)
  default = null
}

variable "additional_tags" {
  default     = {}
  description = "Additional lambda tags"
  type        = map(string)
}

variable "lambda_timeout_in_seconds" {
  type    = number
  default = 30
}

variable "lambda_runtime" {
  type    = string
  default = "nodejs16.x"
}

variable "architectures" {
  type    = list(string)
  default = ["x86_64"]
}

variable "lambda_reserved_concurrent_executions" {
  type    = number
  default = -1
}

variable "memory_size" {
  description = "lambda memory size"
  default     = 1024
}
variable "log_retention" {
  description = "log retention in cloudwatch in days"
  default     = "14"
  type        = string
}

variable "enabled" {
  default     = true
  type        = bool
  description = "Workaround until count on modules work. ⚠️ Use only for testing purpose ⚠️"
}

variable "environment" {
  description = "Set this to the name of the vpc if a vpc_config for the Lambda is needed."
  default     = ""
  type        = string
}

variable "lambda_layers" {
  type    = list(string)
  default = [""]
}

variable "lambda_layers_x86" {
  type    = list(string)
  default =       [
    // see here for last version: https://docs.aws.amazon.com/systems-manager/latest/userguide/ps-integration-lambda-extensions.html#ps-integration-lambda-extensions-add
    "arn:aws:lambda:eu-central-1:187925254637:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11",
    // see here for last version: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-integration-lambda-extensions-versions.html#appconfig-integration-lambda-extensions-enabling-x86-64
    "arn:aws:lambda:eu-central-1:066940009817:layer:AWS-AppConfig-Extension:93",
    // see here for last version: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:eu-central-1:580247275435:layer:LambdaInsightsExtension:38"
  ]
}

variable "lambda_layers_arm64" {
  type    = list(string)
  default =       [
    // see here for last version: https://docs.aws.amazon.com/systems-manager/latest/userguide/ps-integration-lambda-extensions.html#ps-integration-lambda-extensions-add
    "arn:aws:lambda:eu-central-1:187925254637:layer:AWS-Parameters-and-Secrets-Lambda-Extension-Arm64:11",
    // see here for last version: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-integration-lambda-extensions-versions.html#appconfig-integration-lambda-extensions-enabling-ARM64
    "arn:aws:lambda:eu-central-1:066940009817:layer:AWS-AppConfig-Extension-Arm64:36",
    // see here for last version: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsARM.html
    "arn:aws:lambda:eu-central-1:580247275435:layer:LambdaInsightsExtension-Arm64:5"
  ]
}

variable "zip_file_name" {
  default = ""
}

variable "tracing_enabled" {
  default = false
}