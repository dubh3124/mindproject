resource "aws_route_table" "privateroute" {
  for_each = aws_subnet.private-subnets
  vpc_id = aws_vpc.nlvpc.id
  tags = {
    Name = "${var.project_alias}-${each.key}-route-table"
  }
}