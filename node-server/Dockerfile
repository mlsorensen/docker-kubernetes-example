FROM node:latest

ADD VERSION .

WORKDIR /app

ADD express_server.js /app
ADD redis_test.js /app

RUN npm install express
RUN npm install redis

CMD ["node", "/app/express_server.js"]
