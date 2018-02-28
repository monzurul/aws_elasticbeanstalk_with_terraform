resource "aws_vpc_dhcp_options" "proddhcp" {
    domain_name = "${var.DnsZoneName}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "prod internal name"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.vpc-prod.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.proddhcp.id}"
}

/* DNS PART ZONE AND RECORDS */
/*resource "aws_route53_zone" "main" {
  name = "${var.DnsZoneName}"
  vpc_id = "${aws_vpc.vpc-prod.id}"
  comment = "Managed by terraform"
}

resource "aws_route53_record" "prod" {
   zone_id = "${aws_route53_zone.main.zone_id}"
   name = "prod.${var.DnsZoneName}"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.prod.private_ip}"]
}*/