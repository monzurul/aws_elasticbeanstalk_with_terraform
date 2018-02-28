resource "aws_subnet" "PublicAZA" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  cidr_block = "${var.Subnet-Public-AzA-CIDR}"
  map_public_ip_on_launch = true
  tags {
        Name = "PublicAZA"
  }
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_subnet" "PublicAZB" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  cidr_block = "${var.Subnet-Public-AzB-CIDR}"
  map_public_ip_on_launch = true
  tags {
        Name = "PublicAZB"
  }
 availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_route_table_association" "PublicAZA" {
    subnet_id = "${aws_subnet.PublicAZA.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "PublicAZB" {
    subnet_id = "${aws_subnet.PublicAZB.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "PrivateAZA" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  cidr_block = "${var.Subnet-Private-AzA-CIDR}"
  tags {
        Name = "PrivateAZA"
  }
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_subnet" "PrivateAZB" {
  vpc_id = "${aws_vpc.vpc-prod.id}"
  cidr_block = "${var.Subnet-Private-AzB-CIDR}"
  tags {
        Name = "PrivateAZB"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_route_table_association" "PrivateAZA" {
    subnet_id = "${aws_subnet.PrivateAZA.id}"
    route_table_id = "${aws_route_table.private.id}"
}
resource "aws_route_table_association" "PrivateAZB" {
    subnet_id = "${aws_subnet.PrivateAZB.id}"
    route_table_id = "${aws_route_table.private.id}"
}