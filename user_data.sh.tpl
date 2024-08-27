#!/bin/bash
apt -y update
apt -y install apache2
service apache2 start

cat <<EOF > /var/www/html/index.html

<html>
<h2>Built by power of <font color="red"> Terraform </font> </h2> <br>

Server Owner is: ${f_name} ${l_name} <br>

%{for x in names ~}
Hello to ${x} from ${f_name} <br>
%{endfor ~}

EOF