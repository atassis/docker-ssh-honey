FROM alpine as build
WORKDIR /ssh-honeypot/

RUN apk add --no-cache build-base clang git gcc json-c-dev libssh-dev && \
  git clone https://github.com/droberson/ssh-honeypot.git . && make && \
  chmod 777 /ssh-honeypot/bin/ssh-honeypot

FROM alpine
RUN apk add --no-cache libssh-dev json-c-dev openssh
COPY --from=build /ssh-honeypot/bin/ssh-honeypot /bin/ssh-honeypot
EXPOSE 22
CMD ssh-keygen -t rsa -f ./ssh-honeypot.rsa && ssh-honeypot -r ./ssh-honeypot.rsa -p 22 -u nobody
