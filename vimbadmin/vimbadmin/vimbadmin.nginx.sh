cat <<EOF
server {
  server_name $VIMBADMIN_DOMAIN;

  access_log /dev/stdout;
  error_log /dev/stderr;

  root /var/www/vimbadmin/public;
  index index.php;

  location ~ /\.ht {
    deny  all;
  }

  location / {
    if (!-f \$request_filename) {
      rewrite ^(.*)$ /index.php?q=$1 last;
      break;
    }
  }

  location ~* ^.+.(css|js|jpeg|jpg|gif|png|ico) {
    expires 30d;
  }

  location ~ \.php$ {
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    # fastcgi_param HTTPS on;
    include fastcgi_params;
    fastcgi_param SERVER_NAME \$server_name;
  }
}
EOF