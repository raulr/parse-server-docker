FROM node:argon
MAINTAINER Raul Rodriguez <raul@raulr.net>

RUN mkdir /app
WORKDIR /app

COPY package.json /app/package.json

RUN npm install

COPY index.js /app/index.js

EXPOSE 1337

CMD ["npm", "start"]