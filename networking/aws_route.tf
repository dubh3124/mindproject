resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.nlvpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.nlpgw.id
}

resource "aws_route" "private_ngw1" {
  for_each = aws_subnet.private-subnets
  route_table_id         = aws_route_table.privateroute["private-subnet-a"].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.pub1.id
}
resource "aws_route" "private_ngw2" {
  route_table_id         = aws_route_table.privateroute["private-subnet-b"].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.pub2.id
}

