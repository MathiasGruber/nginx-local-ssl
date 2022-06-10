# Use the official latest nginx image
FROM nginx:latest

# Requirements for installing mkcert, which creates local SSL certificates
RUN apt-get update && apt-get install -y libnss3-tools curl git build-essential gcc golang-go

# Install mkcert
RUN git clone https://github.com/FiloSottile/mkcert /root/mkcert
WORKDIR "/root/mkcert/"
RUN go build -ldflags "-X main.Version=$(git describe --tags)"

# Create certificate
RUN ./mkcert localhost *.localhost *.oauth2-proxy.localhost ::1

# Move the certificate files to nginx folder
RUN mkdir /etc/nginx/certs
RUN mv localhost+3.pem /etc/nginx/certs/server.crt
RUN mv localhost+3-key.pem /etc/nginx/certs/server.key