FROM nginx:alpine
WORKDIR /home/gaffclant/gaffclant.dev/
COPY . .
COPY nginx.conf /etc/nginx/nginx.conf
