mkdir -p /var/lib/docker/storage/jenkins && chmod -Rf 777 /var/lib/docker/storage/jenkins

docker run -d \
--privileged \
--name jenkins \
--restart always \
-v /var/lib/docker/storage/jenkins:/var/jenkins_home \
-p 127.0.0.1:3002:8080 \
-p 50000:50000 \
registry.casjay.in/latest/jenkins:latest
