output "igw_id" {
  value       = aws_internet_gateway.this.id
  description = "The ID of the Internet Gateway"
}

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "The CIDR block of the VPC"
}

output "vpc_main_route_table_id" {
  value       = aws_vpc.this.main_route_table_id
  description = "The ID of the main route table associated with this VPC"
}

output "vpc_default_route_table_id" {
  value       = aws_vpc.this.default_route_table_id
  description = "The ID of the route table created by default on VPC creation"
}

output "vpc_public_route_table_id" {
  value       = aws_route_table.public_subnet_route_table.id
  description = "The ID of the route table associated with the public subnets of this VPC"
}

output "vpc_private_route_table_ids" {
  value       =  ["${aws_route_table.private_subnet_route_table.*.id}"]
  description = "The IDs of the route tables associated with each provate subnet of this VPC"
}

output "vpc_default_network_acl_id" {
  value       = aws_vpc.this.default_network_acl_id
  description = "The ID of the network ACL created by default on VPC creation"
}

output "vpc_default_security_group_id" {
  value       = aws_vpc.this.default_security_group_id
  description = "The ID of the security group created by default on VPC creation"
}

output "vpc_ipv6_association_id" {
  value       = aws_vpc.this.ipv6_association_id
  description = "The association ID for the IPv6 CIDR block"
}

output "ipv6_cidr_block" {
  value       = aws_vpc.this.ipv6_cidr_block
  description = "The IPv6 CIDR block"
}

output "vpc_s3_endpoint_id" {
  value       = aws_vpc_endpoint.this.id
  description = "The ID of the S3 endpont associated to this VPC"
}

output "vpc_public_subnet" {
  value       =  ["${aws_subnet.public_subnet.*.id}"]
  description = "The IDs of the public subnets of this VPC"
}

output "vpc_private_subnet" {
  value       =  ["${aws_subnet.private_subnet.*.id}"]
  description = "The IDs of the private subnets of this VPC"
}

output "vpc_nat_eip" {
  value       =  ["${aws_eip.public_subnet_nat_eip.*.id}"]
  description = "The IDs of the NAT EIPs of this VPC"
}

output "vpc_nat" {
  value       =  ["${aws_nat_gateway.public_subnet_nat.*.id}"]
  description = "The IDs of the NATs of this VPC"
}

