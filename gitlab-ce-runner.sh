mkdir -p /var/lib/docker/storage/gitlab/runner/config && chmod -Rf 777 /var/lib/docker/storage/gitlab/runner/config

docker run -d --name gitlab-runner --restart always \
-v /var/lib/docker/storage/gitlab/runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
registry.casjay.in/latest/gitlab-runner:latest 
