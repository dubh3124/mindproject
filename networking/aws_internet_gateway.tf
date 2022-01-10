resource "aws_internet_gateway" "nlpgw" {
  vpc_id = aws_vpc.nlvpc.id
}