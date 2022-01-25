provider "aws" {
    region = "${var.var_region_name_tf}"
}

#Creating a VPC
resource "aws_vpc" "java10x_sakila_plalji_vpc_tf" {
    cidr_block = "10.113.0.0/16"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "java10x_sakila_plalji_vpc"
    }
}

#DNS Routing
resource "aws_route53_zone" "java10x_sakila_plalji_r53_zone_tf" {
  name = "plalji_cyber"

  vpc {
    vpc_id = "${local.vpc_id}"
  }
  tags = {
    Name = "java10x_sakila_plalji_r53_zone"
  }
}

#Internet gateway
resource "aws_internet_gateway" "java10x_sakila_plalji_igw_tf" {
  vpc_id = "${local.vpc_id}"

  tags = {
    Name = " java10x_sakila_plalji_igw"
  }
}

#Route Table - gives access to public network
resource "aws_route_table" "java10x_sakila_plalji_rt_tf" {
  vpc_id = aws_vpc.java10x_sakila_plalji_vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.java10x_sakila_plalji_igw_tf.id
  }
  tags =  {
    Name = "java10x_sakila_plalji_rt"
  }
}

module "subnets_module" {
  source = "./modules/subnets"
  var_vpc_id_tf = "${local.vpc_id}"
}

module "database_module" {
  source = "./modules/database"
  var_vpc_id_tf = "${local.vpc_id}"
  var_subnet_database_id_tf = "${module.subnets_module.output_subnet_database_id}"
  var_route53_zone_id_tf = aws_route53_zone.java10x_sakila_plalji_r53_zone_tf.id
  var_global_key_name_tf = "${var.var_global_key_name_tf}"
  var_ami_database_server_tf  = "${var.var_ami_database_server_tf}"
}

module "bastion_module" {
  source = "./modules/bastion"
  var_vpc_id_tf = "${local.vpc_id}"
  var_subnet_bastion_id_tf = "${module.subnets_module.output_subnet_bastion_id}"
  var_route53_zone_id_tf = aws_route53_zone.java10x_sakila_plalji_r53_zone_tf.id
  var_global_key_name_tf = "${var.var_global_key_name_tf}"
  var_ami_linux_server_tf = "${var.var_ami_linux_server_tf}"
  var_route_table_id_tf = aws_route_table.java10x_sakila_plalji_rt_tf.id
}

module "app_module" {
  source = "./modules/app"
  var_depends_on_database = module.database_module.output_database_instance_id_tf
  var_vpc_id_tf = "${local.vpc_id}"
  var_subnet_app_id_tf = "${module.subnets_module.output_subnet_app_id}"
  var_route53_zone_id_tf = aws_route53_zone.java10x_sakila_plalji_r53_zone_tf.id
  var_global_key_name_tf = "${var.var_global_key_name_tf}"
  var_ami_linux_server_tf = "${var.var_ami_linux_server_tf}"
  var_route_table_id_tf = aws_route_table.java10x_sakila_plalji_rt_tf.id
  var_private_key_loc_tf = var.var_private_key_loc_tf
}

module "proxy_modules" {
  source = "./modules/proxy"
  var_app_instance_id_tf = module.app_module.output_app_instance_id_tf
  var_vpc_id_tf = "${local.vpc_id}"
  var_subnet_proxy_id_tf = "${module.subnets_module.output_subnet_proxy_id}"
  var_global_key_name_tf = "${var.var_global_key_name_tf}"
  var_ami_linux_server_tf = "${var.var_ami_linux_server_tf}"
  var_route_table_id_tf = aws_route_table.java10x_sakila_plalji_rt_tf.id
  var_private_key_loc_tf = "${var.var_private_key_loc_tf}"

}
