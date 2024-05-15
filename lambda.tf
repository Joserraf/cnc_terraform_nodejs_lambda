resource "aws_cloudwatch_log_group" "lambda_log_group" {
  retention_in_days = var.log_retention
  name              = "/aws/lambda/${var.lambda_function_name}"
}

resource "aws_lambda_function" "lambda" {
  filename      = "${abspath(path.root)}/../../${var.zip_file_name == "" ? var.lambda_function_name : var.zip_file_name}.zip"
  function_name = var.lambda_function_name
  role          = var.instance_role_arn
  handler       = "index.default"
  runtime       = var.lambda_runtime
  memory_size   = var.memory_size
  timeout       = var.lambda_timeout_in_seconds
  publish       = true
  architectures = var.architectures

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  source_code_hash               = filebase64sha256("${abspath(path.root)}/../../${var.zip_file_name == "" ? var.lambda_function_name : var.zip_file_name}.zip")

  environment {
    variables = merge(
      var.environment_variables,
      {
        "NODE_OPTIONS" : "--enable-source-maps" # Helpful for debugging
        "NODE_ENV" : var.environment
      }
    )
  }

  tracing_config {
    mode = var.tracing_enabled ? "Active" : "PassThrough"
  }

  layers = concat(
    var.lambda_layers_arm64,
    var.lambda_layers
  )

  tags = merge(
    var.additional_tags,
    {
      "Environment" : var.environment
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}
