output "output_subnet_app_id" {
  value = "${aws_subnet.java10x_sakila_plalji_subnet_app_tf.id}"
}

output "output_subnet_database_id" {
  value = "${aws_subnet.java10x_sakila_plalji_subnet_db_tf.id}"
}

output "output_subnet_bastion_id" {
  value = "${aws_subnet.java10x_sakila_plalji_subnet_bastion_tf.id}"
}

output "output_subnet_proxy_id" {
  value = "${aws_subnet.java10x_sakila_plalji_subnet_proxy_tf.id}"
}
