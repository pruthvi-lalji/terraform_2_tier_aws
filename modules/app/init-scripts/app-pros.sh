#!/usr/bin/env bash
touch "application.properties"
echo "spring.datasource.url=jdbc:mysql://db.plalji_cyber:3306/sakila" | tee -a "application.properties"
echo "spring.datasource.username=root" | tee -a "application.properties"
echo "spring.datasource.password=root" | tee -a  "application.properties"
