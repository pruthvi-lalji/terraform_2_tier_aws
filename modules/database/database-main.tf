
#Database Subnet NACL
resource "aws_network_acl" "java10x_sakila_plalji_nacl-db" {
  vpc_id = "${var.var_vpc_id_tf}"

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "10.113.3.0/24"
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "10.113.1.0/24"
    from_port = 3306
    to_port = 3306
  }


    egress {
      protocol = "tcp"
      rule_no = 1000
      action = "allow"
      cidr_block = "10.113.1.0/24"
      from_port = 1024
      to_port = 65535
    }

    egress {
      protocol = "tcp"
      rule_no = 2000
      action = "allow"
      cidr_block = "10.113.3.0/24"
      from_port = 1024
      to_port = 65535
    }

    subnet_ids = ["${var.var_subnet_database_id_tf}"]

    tags = {
      Name = "java10x_sakila_plalji_nacl_db"
    }
}


#Security Group of Database
resource "aws_security_group" "java10x_sakila_plalji_sg_db_tf" {
  name = "java10x_sakila_plalji_sg_db"
  vpc_id = "${var.var_vpc_id_tf}"
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["10.113.3.0/24"]
  }
  ingress {
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_blocks = ["10.113.1.0/24"]
  }
  tags = {
    Name = "java10x_sakila_plalji_sg_db"
  }
}

#Database Instance
resource "aws_instance" "java10x_sakila_plalji_db_tf" {
  ami = "${var.var_ami_database_server_tf}"
  instance_type = "t2.micro"
  key_name = "${var.var_global_key_name_tf}"
  subnet_id = "${var.var_subnet_database_id_tf}"
  vpc_security_group_ids = [aws_security_group.java10x_sakila_plalji_sg_db_tf.id]
  tags = {
    Name = "java10x_sakila_plalji_db"
  }
}


#Route for database
resource "aws_route53_record" "java10x_sakila_plalji_r53_record_db_tf" {
  zone_id = "${var.var_route53_zone_id_tf}"
  name = "db"
  type = "A"
  ttl = "30"
  
  records = [aws_instance.java10x_sakila_plalji_db_tf.private_ip]
}
