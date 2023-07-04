provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = 1
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "nat gateway staging"
  }
}

resource "aws_route" "private_route" {
  count                  = 1
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}
