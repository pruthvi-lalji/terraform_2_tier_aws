#Association of route tables to Subnet
resource "aws_route_table_association" "java10x_sakila_plalji_rt_assoc_app_tf" {
  subnet_id = "${var.var_subnet_app_id_tf}"
  route_table_id = "${var.var_route_table_id_tf}"
}



#Creation  on Network Access Control List (nacl)
#App NACL
resource "aws_network_acl" "java10x_sakila_plalji_nacl-app" {
  vpc_id = "${var.var_vpc_id_tf}"

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "81.103.182.32/32"
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "10.113.4.0/24"
    from_port = 8080
    to_port = 8080
  }

  ingress {
    protocol = "tcp"
    rule_no = 300
    action = "allow"
    cidr_block = "10.113.4.0/24"
    from_port = 80
    to_port = 80
  }

  ingress {
    protocol = "tcp"
    rule_no = 400
    action = "allow"
    cidr_block = "10.113.4.0/24"
    from_port = 443
    to_port = 443
  }

  ingress {
    protocol = "tcp"
    rule_no = 500
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    }

    egress {
      protocol = "tcp"
      rule_no = 100
      action = "allow"
      cidr_block = "10.113.2.0/24"
      from_port = 3306
      to_port = 3306
    }

    egress {
      protocol = "tcp"
      rule_no = 300
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 80
      to_port = 80
    }

    egress {
      protocol = "tcp"
      rule_no = 200
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 443
      to_port = 443
    }
    egress {
      protocol = "tcp"
      rule_no = 400
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 8080
      to_port = 8080
    }

    egress {
      protocol = "tcp"
      rule_no = 1000
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 1024
      to_port = 65535
    }

    subnet_ids = ["${var.var_subnet_app_id_tf}"]

  tags = {
    Name = "java10x_sakila_plalji_nacl_app"
  }
}



#Security Groups

#SG for app
resource "aws_security_group" "java10x_sakila_plalji_sg_app_tf" {
  name = "java10x_sakila_plalji_sg_app"
  vpc_id = "${var.var_vpc_id_tf}"
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = ["10.113.4.0/24"]
  }

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["81.103.182.32/32"]
  }
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["10.113.4.0/24"]
  }
  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["10.113.4.0/24"]
  }

  egress {
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_blocks = ["10.113.2.0/24"]
  }
  egress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "java10x_sakila_plalji_sg_app"
  }
}



#App Instance
resource "aws_instance" "java10x_sakila_plalji_app_tf" {
  ami = "${var.var_ami_linux_server_tf}"
  instance_type = "t2.micro"
  key_name = "${var.var_global_key_name_tf}"
  subnet_id = "${var.var_subnet_app_id_tf}"
  vpc_security_group_ids = [aws_security_group.java10x_sakila_plalji_sg_app_tf.id]
  associate_public_ip_address = true
  depends_on = [var.var_depends_on_database]
#Connection type, ssh to self
    connection {
    type = "ssh"
     host = self.public_ip
     user = "ubuntu"
    private_key = file("${var.var_private_key_loc_tf}")
   }


   #Run script them/Copy them into the host machine
   provisioner "file" {
     source = "./modules/app/init-scripts/docker-install.sh"
     destination = "/home/ubuntu/docker-install.sh"
   }


  provisioner "file" {
    source = "./modules/app/init-scripts/app-pros.sh"
    destination = "/home/ubuntu/app-pros.sh"
  }


  provisioner "file" {
    source = "./modules/app/init-scripts/app-run.sh"
    destination = "/home/ubuntu/app-run.sh"
  }


  provisioner "remote-exec" {
    #Allow the commands to run after creating the instance
    inline = [
    "chmod 744 /home/ubuntu/app-pros.sh",
    "/home/ubuntu/app-pros.sh"
    ]
  }

  provisioner "remote-exec" {
    #Allow the commands to run after creating the instance
    inline = [
    "chmod 744 /home/ubuntu/docker-install.sh",
    "/home/ubuntu/docker-install.sh",
    ]
  }

  provisioner "remote-exec" {
    #Allow the commands to run after creating the instance
    inline = [
    "chmod 744 /home/ubuntu/app-run.sh",
    "/home/ubuntu/app-run.sh"
    ]
  }
#
  tags = {
    Name = "java10x_sakila_plalji_app"
  }
}



#Route for app
resource "aws_route53_record" "java10x_sakila_plalji_r53_record_app_tf" {
  zone_id = "${var.var_route53_zone_id_tf}"
  name = "www"
  type = "A"
  ttl = "30"
  records = [aws_instance.java10x_sakila_plalji_app_tf.private_ip]
}
