FROM golang:1.15-buster AS src

ENV GO111MODULE=on CGO_ENABLED=0
WORKDIR /go/src/github.com/mpolden/echoip
RUN apt update && apt install -yy git
RUN git clone -q https://github.com/mpolden/echoip /go/src/github.com/mpolden/echoip
RUN cd /go/src/github.com/mpolden/echoip && make

ln -sf /opt/echoip/echoip /usr/local/bin/echoip
ln -sf /opt/echoip/echoip /usr/local/bin/ifconfig
sed -i "s|REPLACE_MODIFIED|$(date +'%Y-%m-%d at %H:%M')|g" /opt/echoip/html/index.html
