# Use the official latest nginx image
FROM nginx:latest

# Requirements for installing mkcert, which creates local SSL certificates
RUN apt-get update && apt-get install -y libnss3-tools curl git build-essential gcc

# Change locale to avoid linuxbrew error
RUN apt-get install -y locales && localedef -i en_US -f UTF-8 en_US.UTF-8

# Install linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin/:${PATH}"
RUN echo $PATH

# Install mkcert
RUN brew install mkcert
RUN mkcert -install

# Create certificate
RUN mkcert localhost *.localhost *.oauth2-proxy.localhost ::1

# Move the certificate files to nginx folder
RUN mkdir /etc/nginx/certs
RUN mv localhost+3.pem /etc/nginx/certs/server.crt
RUN mv localhost+3-key.pem /etc/nginx/certs/server.key