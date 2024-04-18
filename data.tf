data "aws_subnet_ids" "selected_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    SubnetType = "Private"
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.environment]
  }
}

