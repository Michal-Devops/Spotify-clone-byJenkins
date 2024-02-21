
FROM node:16-alpine


WORKDIR /app

COPY package*.json ./


RUN npm install


COPY postcss.config.js .
COPY tailwind.config.js .
COPY vite.config.js .

COPY ./public ./public
COPY ./src ./src
COPY index.html .

RUN npm run build

RUN npm install -g http-server

EXPOSE 80
CMD ["http-server", "dist", "-p", "80"]