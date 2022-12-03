FROM node:18.12.0-alpine AS Dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

CMD "npx" "cypress" "run" "--config video=false"