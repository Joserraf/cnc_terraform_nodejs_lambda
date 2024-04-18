resource "aws_security_group" "sg_lambda" {
  count = length(var.environment) > 0 ? 1 : 0
  name        = "${var.lambda_function_name}-sg"
  description = "Security group for the ${var.lambda_function_name}"
  vpc_id      = data.aws_vpc.vpc[0].id

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    function = var.lambda_function_name
  }
}