#Subnet 01 - App Subnet
resource "aws_subnet" "java10x_sakila_plalji_subnet_app_tf" {
  vpc_id = "${var.var_vpc_id_tf}"
  cidr_block = "10.113.1.0/24"
  tags = {
    Name = "java10x_sakila_plalji_subnet_app"
  }
}


#Subnet 02 - Database Subnet
resource "aws_subnet" "java10x_sakila_plalji_subnet_db_tf" {
  vpc_id = "${var.var_vpc_id_tf}"
  cidr_block = "10.113.2.0/24"
  tags = {
    Name = "java10x_sakila_plalji_subnet_db"
  }
}


#Subnet 03 - Bastion Subnet
resource "aws_subnet" "java10x_sakila_plalji_subnet_bastion_tf" {
  vpc_id = "${var.var_vpc_id_tf}"
  cidr_block = "10.113.3.0/24"
  tags = {
    Name = "java10x_sakila_plalji_subnet_bastion"
  }
}

#Subnet 03 - Proxy Subnet
resource "aws_subnet" "java10x_sakila_plalji_subnet_proxy_tf" {
  vpc_id = "${var.var_vpc_id_tf}"
  cidr_block = "10.113.4.0/24"
  tags = {
    Name = "java10x_sakila_plalji_subnet_proxy"
  }
}
