# nginx-local-ssl
Docker image for nginx set up with SSL for localhost

# Use in docker compose
Typically I use this image in docker-compose as an nginx proxy as follows

```
nginx:
    container_name: nginx
    image: nanomathias/nginx-local-ssl
    ports:
        - "${NGINX_PORT}:${NGINX_PORT}"
    volumes:
        - ../nginx/template.conf:/etc/nginx/conf.d/mysite.template:ro
    environment:
        # Used in base.conf to retain normal env variables
        # see: https://serverfault.com/questions/577370/how-can-i-use-environment-variables-in-nginx-conf
        - DOLLAR=$$
    env_file:
        - .env
    # Insert env variables,
    # see: https://serverfault.com/questions/577370/how-can-i-use-environment-variables-in-nginx-conf
    command: sh -c "echo 'Substituting env vars, and starting nginx' &&
        envsubst < /etc/nginx/conf.d/mysite.template > /etc/nginx/conf.d/default.conf &&
        exec nginx -g 'daemon off;'"
```

# Build locally
```
# Setup docker builder
docker buildx create --name mybuilder --driver-opt network=host --use

# Build docker image (multi-arch version)
docker buildx build \
    --push \
    --tag nanomathias/nginx-local-ssl:release-1.0.1 \
    --platform linux/amd64,linux/arm64 .
```