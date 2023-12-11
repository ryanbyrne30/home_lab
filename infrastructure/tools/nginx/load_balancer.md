# Set Up an NGINX Load Balancer

[Reference](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/infrastructure-setup/nginx-load-balancer)

## Install NGINX

```bash
sudo apt install nginx
```

## Create Self-Signed TLS Certificate

```bash
sudo mkdir -p /etc/nginx/certs
sudo chmod 700 /etc/nginx/certs

sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/certs/server.crt -keyout /etc/nginx/certs/server.key

sudo chmod 400 /etc/nginx/certs/server.key
```

## [Create NGINX Load Balancer Configuration](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/)

### [Configuration for Rancher](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/infrastructure-setup/nginx-load-balancer#create-nginx-configuration)

Create a file `nginx.conf` and replace `IP_NODE_1`, `IP_NODE_2`, `IP_NODE_3` with the IPs of your nodes.

```nginx
# nginx.conf
load_module /usr/lib/nginx/modules/ngx_stream_module.so;

worker_processes 4;
worker_rlimit_nofile 40000;

events {
    worker_connections 8192;
}

stream {
    upstream rancher_servers_http {
        least_conn;
        server <IP_NODE_1>:80 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:80 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:80 max_fails=3 fail_timeout=5s;
    }
    server {
        listen 80;
        proxy_pass rancher_servers_http;
    }

}

http {

    upstream rancher_servers_https {
        least_conn;
        server <IP_NODE_1>:443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:443 max_fails=3 fail_timeout=5s;
    }
    server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/certs/server.crt;
        ssl_certificate_key /etc/nginx/certs/server.key;
        location / {
            proxy_pass https://rancher_servers_https;
            proxy_set_header Host rancher.homelab; # DNS for server
            proxy_ssl_server_name on;
            proxy_ssl_name rancher.homelab; # DNS for server
        }
    }
}
```

Save `nginx.conf` to your load balancer at `/etc/nginx/nginx.conf`.

Load the updates to NGINX

```bash
nginx -t
nginx -s reload
```
