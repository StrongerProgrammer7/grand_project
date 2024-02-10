FROM node:latest

WORKDIR /app

COPY ./ ./

EXPOSE 443
EXPOSE 444

RUN npm install

ADD start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]