FROM node:18.12.0-alpine AS Dependencies

WORKDIR /e2e

COPY package*.json ./

RUN npm ci

COPY . .

CMD "npx" "cypress" "run" "--config video=false"