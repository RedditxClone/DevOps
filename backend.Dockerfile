# Install Dependencies
FROM node:18.12.0-alpine AS Dependencies

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

RUN npm i mongodb-memory-server@7

RUN npm run test

#End of Tests
# ---------------------------------------------------------
# Build App
FROM node:18.12.0-alpine AS Build

WORKDIR /app

COPY --from=Dependencies /app/node_modules ./node_modules

COPY . .

RUN npm run build

# Remove Not needed Dependencies in node_modules Folder
# RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force

# End of Building
# ---------------------------------------------------------
# Move Dependencies and App To Final Image
FROM node:18.12.0-alpine AS Final

WORKDIR /app

COPY --from=Build /app/node_modules ./node_modules
COPY --from=Build /app/dist ./dist

EXPOSE 3000
# Start the server using the production build
CMD [ "node", "dist/main.js" ]

# End of Final Image