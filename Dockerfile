FROM node:16-alpine3.15

RUN npm install -g localtunnel

ENTRYPOINT ["node", "/usr/local/bin/lt"]