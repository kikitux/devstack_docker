sudo apt-get install -y nginx

[ -f /etc/nginx/sites-enabled/default ] && sudo rm /etc/nginx/sites-enabled/default

for i in 1 2 3 4 5 ; do
  cat <<EOF | sudo tee -a /etc/nginx/sites-enabled/demo >/dev/null
server {
        listen 888$i ;
        server_name localhost;

        location / {
                proxy_pass http://10.0.0.$i:80/;
        }

}
EOF
done

sudo service nginx restart 2>/dev/null
