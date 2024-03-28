resource "aws_cloudwatch_log_group" "lambda_log_group" {
  count             = var.enabled ? 1 : 0
  retention_in_days = var.log_retention
  name              = "/aws/lambda/${var.lambda_function_name}"
}

locals {
  environment_map = merge(
    var.environment_variables,
    { NODE_OPTIONS = "--enable-source-maps" } // This is important to have stack traces with typescript
  )
}

resource "aws_lambda_function" "lambda" {
  filename      = "${abspath(path.root)}/../../${var.zip_file_name == "" ? var.lambda_function_name : var.zip_file_name}.zip"
  function_name = var.lambda_function_name
  role          = var.instance_role_arn
  memory_size   = var.memory_size
  handler       = "index.default"
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  source_code_hash = filebase64sha256("${abspath(path.root)}/../../${var.zip_file_name == "" ? var.lambda_function_name : var.zip_file_name}.zip")
  publish       = true

  runtime = var.lambda_runtime
  architectures = var.architectures

  dynamic "environment" {
    for_each = local.environment_map[*]
    content {
      variables = environment.value
    }
  }

  tags = merge(
    var.additional_tags
  )

  timeout = var.lambda_timeout_in_seconds

  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}
