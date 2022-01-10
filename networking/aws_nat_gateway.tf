##resource "aws_nat_gateway" "nlpnat" {
##  for_each = aws_subnet.public-subnets
##  subnet_id = each.value.id
##}
resource "aws_nat_gateway" "pub1" {
  allocation_id = aws_eip.nleip1.id
  subnet_id = aws_subnet.public-subnets["public-subnet-a"].id
}
resource "aws_nat_gateway" "pub2" {
  allocation_id = aws_eip.nleip2.id
  subnet_id = aws_subnet.public-subnets["public-subnet-b"].id
}
