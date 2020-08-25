# Use the official latest nginx image
FROM nginx:latest

# Requirements for installing mkcert, which creates local SSL certificates
RUN apt-get update && apt-get install -y libnss3-tools curl git build-essential gcc

# Change locale to avoid linuxbrew error
RUN apt-get install -y locales && localedef -i en_US -f UTF-8 en_US.UTF-8

# Create a user which is not root, so we can install linuxbrew
RUN useradd --system -s /sbin/nologin myuser
RUN mkdir /home/myuser
RUN mkdir /home/myuser/.linuxbrew
RUN chown -R myuser:myuser /home/myuser
USER myuser

# Install linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH="/home/myuser/.linuxbrew/bin:${PATH}"
RUN echo $PATH

# Install mkcert
USER root
RUN brew install mkcert
RUN mkcert -install

# Create certificate
RUN mkcert localhost ::1

# Move the certificate files to nginx folder
RUN mkdir /etc/nginx/certs
RUN mv localhost+1.pem /etc/nginx/certs/server.crt
RUN mv localhost+1-key.pem /etc/nginx/certs/server.key