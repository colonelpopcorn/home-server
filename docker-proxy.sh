docker run -d \
--link transmission:transmission \
--name nginx_proxy \
-p 8080:8080 \
haugene/transmission-openvpn-proxy
