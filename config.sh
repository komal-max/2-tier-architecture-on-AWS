 #!/bin/bash

 sudo yum update

 sudo yum -y install httpd
 sudo systemctl start httpd 
 sudo systemctl enable httpd 
 sudo systemctl status httpd 
 echo "<html><body><h1>Hello there!</h1></body></html>" > /var/www/html/index.html

