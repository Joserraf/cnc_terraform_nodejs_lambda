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
  default = "nodejs21.x"
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

variable "zip_file_name" {
  default = ""
}