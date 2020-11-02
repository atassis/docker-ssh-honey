FROM alpine:3.6 as build
WORKDIR /ssh-honeypot/

## move key generation into entrypoint
RUN apk add --no-cache git libssh-dev gcc musl-dev openssl build-base openssh geoip curl netcat-openbsd clang json-c-dev libssh2-dev && \
  git clone https://github.com/droberson/ssh-honeypot.git . && make && \
  ssh-keygen -t rsa -f ./ssh-honeypot.rsa && \
  chmod 777 /ssh-honeypot/bin/ssh-honeypot

FROM alpine:3.6
RUN apk add --no-cache libssh-dev json-c-dev openssh curl netcat-openbsd
WORKDIR /ssh-honeypot/
COPY entrypoint.sh /entrypoint.sh
COPY --from=build /ssh-honeypot/bin/ssh-honeypot /bin/ssh-honeypot
COPY --from=build /ssh-honeypot/ssh-honeypot.rsa ./ssh-honeypot.rsa
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
