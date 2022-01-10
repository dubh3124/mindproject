resource "aws_route_table_association" "publicsubnetassoc" {
  for_each = aws_subnet.public-subnets
  route_table_id = aws_vpc.nlvpc.main_route_table_id
  subnet_id = each.value.id
}

resource "aws_route_table_association" "privatesubnetassoc" {
  for_each = aws_subnet.private-subnets
  route_table_id = aws_route_table.privateroute[each.key].id
  subnet_id = each.value.id
}