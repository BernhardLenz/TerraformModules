variable "region" {
  description = "The region to deploy to (us-east-1 is the default). "
  type        = string
  default     = "us-east-1"
}

locals {
  
  vpc = {
    cidr = "10.0.0.0/16"
    name = "PrdUsE1Vpc"
    ig_name = "PrdUsE1VpcInternetGateway"
    s3_endpoint_name = "PrdUsE1VpcS3Endpoint"
    public_subnets_routetable_name = "PrdUsE1VpcPublicSubnetRouteTable"

    azs = [ 
      { 
        az = "${var.region}a"
        public_subnet = {
      	  cidr = "10.0.129.0/21"
      	  name = "PrdUsE1APublicSubnet"
      	  nat_name = "PrdUsE1APublicSubnetNatGateway"
      	  nat_eip_name = "PrdUsE1APublicSubnetNatGatewayEip"
        }
        private_subnet = {
        	cidr = "10.0.0.0/21"
        	name = "PrdUsE1APrivateSubnet"
        	routetable_name = "PrdUsE1APrivateRouteTable"
        }
      },
      { 
        az = "${var.region}b"
        public_subnet = {
      	  cidr = "10.0.130.0/21"
      	  name = "PrdUsE1BPublicSubnet"
      	  nat_name = "PrdUsE1BPublicSubnetNatGateway"
      	  nat_eip_name = "PrdUsE1BPublicSubnetNatGatewayEip"
        }
        private_subnet = {
        	cidr = "10.0.1.0/21"
        	name = "PrdUsE1BPrivateSubnet"
        	routetable_name = "PrdUsE1BPrivateRouteTable"
        }
      }
      
    ]
  }
}

resource "aws_vpc" "this" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = local.vpc.cidr
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    Name = local.vpc.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = local.vpc.ig_name
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.us-east-1.s3"   ##########
  tags = {
    Name = local.vpc.s3_endpoint_name
  }
}

resource "aws_subnet" "public_subnet" {
  count      = length(local.vpc.azs)
  #cidr_block = element(values(local.subnets.*.public.subnet_cidr), count.index)
  cidr_block = local.vpc.azs[count.index].public_subnet.cidr
  vpc_id     = aws_vpc.this.id

  map_public_ip_on_launch = true
  availability_zone       = local.vpc.azs[count.index].az

  tags = {
    Name = local.vpc.azs[count.index].public_subnet.name
  }
}

resource "aws_subnet" "private_subnet" {
  count      = length(local.vpc.azs)
  cidr_block = local.vpc.azs[count.index].private_subnet.cidr
  vpc_id     = aws_vpc.this.id

  map_public_ip_on_launch = false
  availability_zone       = local.vpc.azs[count.index].az

  tags = {
    Name = local.vpc.azs[count.index].private_subnet.name
  }
}

resource "aws_eip" "public_subnet_nat_eip" {
  count      = length(local.vpc.azs)
  vpc  = true
  tags = { 
    Name = local.vpc.azs[count.index].public_subnet.nat_eip_name
  }
}

resource "aws_nat_gateway" "public_subnet_nat" {
  count      = length(local.vpc.azs)
  subnet_id     = aws_subnet.public_subnet[count.index].id
  allocation_id = aws_eip.public_subnet_nat_eip[count.index].id
  #depends_on    = [aws_internet_gateway.this[count.]
  tags = {
    Name = local.vpc.azs[count.index].public_subnet.nat_name
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.this.id
  route = [
    {
      cidr_block                = "0.0.0.0/0"
      gateway_id                = aws_internet_gateway.this.id
      nat_gateway_id            = ""
      ipv6_cidr_block           = ""
      egress_only_gateway_id    = ""
      instance_id               = ""
      network_interface_id      = ""
      transit_gateway_id        = ""
      vpc_peering_connection_id = ""
    },
  ]
  tags = {
    Name = local.vpc.public_subnets_routetable_name
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  count      = length(local.vpc.azs)
  vpc_id = aws_vpc.this.id
  route = [
    {
      cidr_block                = "0.0.0.0/0"
      nat_gateway_id            = aws_nat_gateway.public_subnet_nat[count.index].id
      gateway_id                = ""
      ipv6_cidr_block           = ""
      egress_only_gateway_id    = ""
      instance_id               = ""
      network_interface_id      = ""
      transit_gateway_id        = ""
      vpc_peering_connection_id = ""
    },
  ]
  tags = {
    Name = local.vpc.azs[count.index].private_subnet.routetable_name
  }
}

resource "aws_route_table_association" "public_route_table_public_subnet_association" {
  count      = length(local.vpc.azs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "private_route_table_private_subnet_association" {
  count      = length(local.vpc.azs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_route_table[count.index].id
}
