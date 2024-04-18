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
  handler       = "index.default"
  runtime       = var.lambda_runtime
  memory_size   = var.memory_size
  timeout       = var.lambda_timeout_in_seconds
  publish       = true
  architectures = var.architectures

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  source_code_hash               = filebase64sha256("${abspath(path.root)}/../../${var.zip_file_name == "" ? var.lambda_function_name : var.zip_file_name}.zip")

  vpc_config {
    subnet_ids         = data.aws_subnet_ids.selected_subnets.ids
    security_group_ids = [aws_security_group.sg_lambda.id]
  }

  environment {
    variables = merge(
      var.environment_variables,
      {
        "NODE_OPTIONS" : "--enable-source-maps" # Helpful for debugging
      }
    )
  }

  tracing_config {
    mode = var.tracing_enabled ? "Active" : "PassThrough"
  }

  layers = concat(
    var.architectures[0] == "x86_64" ? var.lambda_layers_x86 : var.lambda_layers_arm64,
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
