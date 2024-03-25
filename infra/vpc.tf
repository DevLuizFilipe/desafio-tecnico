module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.2.0"
  count   = var.create_vpc ? length(var.vpc) : 0

  name                                 = var.vpc[count.index].name
  cidr_block                           = var.vpc[count.index].cidr_block
  vpc_assign_generated_ipv6_cidr_block = var.vpc[count.index].vpc_assign_generated_ipv6_cidr_block
  vpc_egress_only_internet_gateway     = var.vpc[count.index].vpc_egress_only_internet_gateway
  az_count                             = var.vpc[count.index].az_count

  subnets = {
    public = {
      name_prefix               = var.vpc[count.index].subnets.public.name_prefix
      netmask                   = var.vpc[count.index].subnets.public.netmask
      assign_ipv6_cidr          = var.vpc[count.index].subnets.public.assign_ipv6_cidr
      nat_gateway_configuration = var.vpc[count.index].subnets.public.nat_gateway_configuration
    }
    private = {
      name_prefix             = var.vpc[count.index].subnets.private.name_prefix
      netmask                 = var.vpc[count.index].subnets.private.netmask
      connect_to_public_natgw = var.vpc[count.index].subnets.private.connect_to_public_natgw
    }
  }
}
