# secure-qbittorent
**secure-qbitorrent**, es una imagen docker que combina openvpn y qbittorrent para encriptar el trafico peer to peer

### Uso:
### Docker CLI

 ```
docker run -d \
  --name=secure-qbittorrent \
  --privileged \
  -e PUID=1000 \
  -e GUID=1000 \
  -e PORT=7070 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -p 7070:7070 \
  -v /path/to/appdata/config:/config \
  -v /path/to/downloads:/downloads \
  -v /path/to/openvpn_config_files:/etc/openvpn/clients
  --restart unless-stopped \
  secure-qbittorrent
```

### Docker Compose

```
version: "2.1"
services:
  secure-qbittorrent:
    image: secure-qbittorrent
    container_name: secure-qbittorrent
    restart: unless-stopped
    privileged: true
    environment:
      - PUID=1000
      - GUID=1000
      - PORT=7070
    volumes:
      - /path/to/appdata/config:/config
      - /path/to/downloads:/downloads
      - /path/to/openvpn_config_files:/etc/openvpn/clients
	ports:
      - 7070:7070
      - 6881:6881
      - 6881:6881/udp
```

### Parametros
La imagen acepta los siguientes parámetros de configuración.

Parametro | Uso
-------- | -----
--privileged | Da privilegios elevado al contenedot (necesario para creear tun0)
-e PUID=1000 | Para UserID (explicación más abajo)
-e GUID=1000 | Para GroupID (explicación más abajo)
-e PORT=7070 | Para cambiar el puerto de la interfaz web
-p 6881:6881 |Puero para la conección tcp
-p 6881:6881/udp | Puerto para la conección udp
-p 7070:7070 | Interfaz http (debe ser el mismo que PORT)
-v /config| contiene la configuración relevante
-v /downloads | carpeta de descargas
-v /etc/openvpn/clients| contiene los archivos de configuración de openvpn 

### Identificadores de usuario y grupo

Cuando se utilizan volúmenes (indicadores -v), pueden surgir problemas de permisos entre el sistema operativo host y el contenedor, evitamos este problema permitiéndole especificar el PUID del usuario y el GUID del grupo.

Asegúrese de que todos los directorios de volumen en el host sean propiedad del mismo usuario que especifique y cualquier problema de permisos desaparecerá como por arte de magia.


### Configuración de openvpn

openvpn espera encontrar  la configuración de openvpn en en */etc/openvpn/clients* el archivo  de configuracón **debe** llamarse `client.ovpn`  asegúrese de definir correctamente el volumen   `-v /path/to/openvpn_config_files:/etc/openvpn/clients` , de lo contrario openvpn no funcionara. 

### Configuración de qBittorrent
La interfaz web está en <su-ip>: 8080 y el nombre de usuario / contraseña predeterminados es `admin / adminadmin`.

Cambie el nombre de usuario / contraseña a través de la sconfiguración de la interfaz web.

**Variable PORT**

Debido a problemas con CSRF y la asignación de puertos, si necesita modificar el puerto para la interfaz web, debe cambiar ambos lados del conmutador -p 8080 Y establecer la variable PORT en el nuevo puerto.

Por ejemplo, para configurar el puerto en 8090, debe configurar -p 8090: 8090 y -e PORT = 8090

Esto debería aliviar el problema de la "pantalla blanca".

Si no tiene interfaz web, consulte el archivo */config/qBittorrent/qBittorrent.conf* y edite o agregue las siguientes líneas
````
WebUI\Dirección = *
WebUI\ServerDomains = *
````

