sudo yum install httpd -y
sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_unified 1
sudo apachectl start
sudo systemctl enable httpd
sudo apachectl configtest
sudo firewall-offline-cmd --add-port=80/tcp
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
sudo bash -c 'echo This is compute test page from 02 >> /var/www/html/index.html'
