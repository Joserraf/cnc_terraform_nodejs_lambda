data "aws_subnets" "private_subnets" {
  count = length(var.environment) > 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc[0].id]
  }
  tags = {
    SubnetType = "Private"
  }
}

data "aws_vpc" "vpc" {
  count = length(var.environment) > 0 ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.environment]
  }
}

