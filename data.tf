data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cnc_vpc.id]
  }
  tags = {
    SubnetType = "Private"
  }
}

data "aws_vpc" "cnc_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.environment]
  }
}