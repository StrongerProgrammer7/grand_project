FROM node:latest

WORKDIR /app

COPY ./ ./

RUN npm install

ADD start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]