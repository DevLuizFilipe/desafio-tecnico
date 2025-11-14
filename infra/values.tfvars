######################## General Values ########################
region   = "us-west-2"
env      = "production"
app_name = "Comments"
######################## ECR Values ############################
create_ecr = true
ecr = [{
  name = "comments"
}]

######################## VPC Values ############################
create_vpc = true
vpc = [
  {
    name                                 = "app-vpc"
    cidr_block                           = "10.0.0.0/16"
    vpc_assign_generated_ipv6_cidr_block = true
    vpc_egress_only_internet_gateway     = true
    az_count                             = 3

    subnets = {
      public = {
        name_prefix               = "public"
        netmask                   = 24
        assign_ipv6_cidr          = true
        nat_gateway_configuration = "single_az"
      }
      private = {
        name_prefix             = "private"
        netmask                 = 24
        connect_to_public_natgw = true
      }
    }
  }
]

######################## ECS Values ###########################
create_ecs = true
ecs = [
  {
    desired_count      = 1 #Number of service replicas to run
    name               = "comments"
    container_cpu      = 256
    container_memory   = 512
    container_port     = 8000
    image_url          = "092801936354.dkr.ecr.us-west-2.amazonaws.com/comments:latest"
    public_subnets     = "public*"
    private_subnets    = "private*"
    remote_cidr_blocks = ["0.0.0.0/0"] #CIDR block to allow traffic from
    service_name       = "comments"
  }
]

######################## S3 Values ###########################
bucket_name = "squad-desafio-tecnico-devops"
