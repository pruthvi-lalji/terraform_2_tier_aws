variable "var_region_name_tf" {
  default = "eu-west-1"
}

variable "var_global_key_name_tf" {
  default = "cyber-10x-plalji"
}

variable "var_ami_database_server_tf" {
  default = "ami-03fa06b015e630a7f"
}

variable "var_ami_linux_server_tf" {
  default = "ami-08ca3fed11864d6bb"
}

locals {
  vpc_id = "${aws_vpc.java10x_sakila_plalji_vpc_tf.id}"
}
variable "var_private_key_loc_tf" {
  default = "/home/vagrant/.ssh/cyber-10x-plalji.pem"
}
