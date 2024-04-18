resource "aws_security_group" "sg_lambda" {
  name        = "${var.lambda_function_name}-sg"
  description = "Security group for the ${var.lambda_function_name}"
  vpc_id      = data.aws_vpc.cnc_vpc.id

  egress {
    description = "MongoDB Atlas connectivity"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["<MongoDB_Atlas_CIDR>"] # TODO: Replace with actual CIDR of your MongoDB Atlas
  }

  #egress {
  #  description = "Allow all outbound traffic"
  #  from_port   = 0
  #  to_port     = 0
  #  protocol    = "-1"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  tags = {
    Name        = "${var.lambda_function_name}-SG"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}