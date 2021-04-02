 #!/bin/sh
#crea directorio de configuracion de qBittorent

mkdir -p /config/qBittorrent

#comprueba si existe un archivo de cofiguracion, si no existe crea el por defecto

[[ ! -e /config/qBittorrent/qBittorrent.conf ]] && 	cp /root/defaults/qBittorrent.conf /config/qBittorrent/qBittorrent.conf
[[ $PUID && $GUID ]] && adduser --no-create-home --uid $PUID -D -h /config  abc abc && chown $PUID:$GUID /config -R && chown $PUID:$GUID /downloads -R

# comprueba si existe el archivo de configuracióon de ovpn, si existe crea el enlace y configura la red,
# si no existe sale

if [ -e /etc/openvpn/clients/client.ovpn ]; then
	printf "\n\nEjecutando openvpn\n\n"
	openvpn --config /etc/openvpn/clients/client.ovpn --daemon
	sleep 5
	export INTERFACE=eth0
	export LOCALIP=$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)
	export SUBNET=$( echo $LOCALIP | cut -d "." -f 0-3).0/16
	export GATEWAY=$( echo $LOCALIP | cut -d "." -f 0-3).1
	ip route flush table 100
	ip route flush cache
	ip rule add from $LOCALIP table 100
	ip route add table 100 $SUBNET dev $INTERFACE
	ip route add table 100 default via $GATEWAY
else
	printf "\n\nNo existe el archivo de configuracion de openvpn\nSaliendo...\n\n"
	exit 1
fi

printf "\n\nEjecutando qBittorrent\n\n"

	if [ $PORT ] && [ $GUID  ] && [ $PUID ]; then
		su abc -c "qbittorrent-nox --webui-port=$PORT"
		exit 0
	else
		qbittorrent-nox --webui-port=$PORT
		exit 0
	fi

	

	if [ $GUID  ] && [ $PUID ]; then 
		su abc -c "qbittorrent-nox --webui-port=7070"
		exit 0
	else
		qbittorrent-nox --webui-port=7070
		exit 0
	fi
	