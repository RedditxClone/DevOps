# Install Dependencies
FROM node:18.12.0 AS Dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci
# End of Install Dependencies
# ---------------------------------------------------------
# Run Testing
FROM node:18.12.0 AS Testing

WORKDIR /app

COPY --from=Dependencies /app/node_modules ./node_modules

COPY . .

RUN npm run test

# End of Tests
# ---------------------------------------------------------
# Build App
FROM node:18.12.0 AS Build

WORKDIR /app

COPY --from=Dependencies /app/node_modules ./node_modules

COPY . .

RUN npm run build

ENV NODE_ENV production

# Remove Not needed Dependencies in node_modules Folder
RUN npm ci --only=production && npm cache clean --force

# End of Building
# ---------------------------------------------------------
# Move App To Final Image
FROM nginx:latest AS Final

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=Build /app/dist /usr/share/nginx/html

EXPOSE 80

# End of Final Image