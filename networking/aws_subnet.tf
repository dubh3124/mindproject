resource "aws_subnet" "public-subnets" {
  for_each = {for subnet in var.public_subnet_configs : subnet.name => subnet}
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.nlvpc.id
  tags = {
    Name = each.value.name
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/test-eks-cluster"  =  "shared"
  }
}

resource "aws_subnet" "private-subnets" {
  for_each = {for subnet in var.private_subnet_configs : subnet.name => subnet}
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  vpc_id     = aws_vpc.nlvpc.id
  tags = {
    Name = each.value.name
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/test-eks-cluster"  =  "shared"
  }
}