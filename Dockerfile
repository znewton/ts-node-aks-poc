FROM node:14
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --only=production

COPY dist ./dist

EXPOSE 80
ENV PORT=80
CMD [ "npm", "start" ];
