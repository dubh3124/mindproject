output "private-subnets" {
  value = [for subnet in aws_subnet.private-subnets : subnet.id ]
}

output "public-subnets" {
  value = [for subnet in aws_subnet.public-subnets : subnet.id ]
}

output "vpcid" {
  value = aws_vpc.nlvpc.id
}