sudo apt install gcc -y
sudo apt install make -y
sudo apt install curl -y
sudo apt install libpcre3 libpcre3-dev -y
sudo apt install libssl-dev -y
sudo apt install zlib1g-dev -y
curl https://nginx.org/download/nginx-1.28.0.tar.gz -o nginx-1.28.0.tar.gz
tar -xzvf nginx-1.28.0.tar.gz nginx-1.28.0
cd nginx-1.28.0
./configure --with-http_ssl_module
sudo make
sudo make install
cd ..
cat << EOF > nginx.service
[Unit]
Description=nginx - high performance web server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
ExecQuit=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

sudo mv nginx.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start nginx
sudo systemctl enable nginx
