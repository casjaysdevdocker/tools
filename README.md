## 👋 Welcome to tools 🚀  

tools README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update tools
```
  
## Install and run container
  
```shell
dockerHome="/srv/$USER/docker/casjaysdevdocker/tools/tools/latest/rootfs"
mkdir -p "/srv/$USER/docker/tools/rootfs"
git clone "https://github.com/dockermgr/tools" "$HOME/.local/share/CasjaysDev/dockermgr/tools"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/tools/rootfs/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-tools-latest \
--hostname tools \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/tools:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/tools
    container_name: casjaysdevdocker-tools
    environment:
      - TZ=America/New_York
      - HOSTNAME=tools
    volumes:
      - "/srv/$USER/docker/casjaysdevdocker/tools/tools/latest/rootfs/data:/data:z"
      - "/srv/$USER/docker/casjaysdevdocker/tools/tools/latest/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/tools
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/tools" "$HOME/Projects/github/casjaysdevdocker/tools"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/tools"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  
