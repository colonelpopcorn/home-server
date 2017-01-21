docker run --privileged  -d \
--dns 8.8.8.8 \
--restart=always \
--name transmission
-v /media/usb01:/data \
-v /etc/localtime:/etc/localtime:ro \
-e "OPENVPN_PROVIDER=" \
-e "OPENVPN_CONFIG=" \
-e "OPENVPN_USERNAME=" \
-e "OPENVPN_PASSWORD=" \
-p 9091:9091 \
haugene/transmission-openvpn
