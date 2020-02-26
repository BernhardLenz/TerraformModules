
vpc = {
  cidr = "10.0.0.0/16"
  name = "TstUsE1Vpc"
  ig_name = "TstUsE1VpcInternetGateway"
  s3_endpoint_name = "TstUsE1VpcS3Endpoint"
  public_subnets_routetable_name = "TstUsE1VpcPublicSubnetRouteTable"
  default_route_table_name = "TstUsE1VpcMainRouteTable"

  azs = [ 
    { 
      az = "us-east-1a"
      public_subnet = {
    	  cidr = "10.0.129.0/24"
    	  name = "TstUsE1APublicSubnet"
    	  nat_name = "TstUsE1APublicSubnetNatGateway"
    	  nat_eip_name = "TstUsE1APublicSubnetNatGatewayEip"
      }
      private_subnet = {
      	cidr = "10.0.0.0/24"
      	name = "TstUsE1APrivateSubnet"
      	routetable_name = "TstUsE1APrivateRouteTable"
      }
    },
    { 
      az = "us-east-1b"
      public_subnet = {
    	  cidr = "10.0.130.0/24"
    	  name = "TstUsE1BPublicSubnet"
    	  nat_name = "TstUsE1BPublicSubnetNatGateway"
    	  nat_eip_name = "TstUsE1BPublicSubnetNatGatewayEip"
      }
      private_subnet = {
      	cidr = "10.0.1.0/24"
      	name = "TstUsE1BPrivateSubnet"
      	routetable_name = "TstUsE1BPrivateRouteTable"
      }
    }
  ]
}
