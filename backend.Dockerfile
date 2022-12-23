# Install Dependencies
FROM node:18.12.0 AS Dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci
# End of Install Dependencies
# ---------------------------------------------------------
# Run Testing
FROM backend_testing AS Testing

WORKDIR /app

ENV DB_CONNECTION_STRING mongodb://localhost:27017
ENV EMAIL_USER 123@outlook.com
ENV EMAIL_PASS password
ENV JWT_SECRET exmapleForJWTSecret
ENV PORT 3000
ENV FORGET_PASSWORD_SECRET example

ENV GOOGLE_CREDIENTIALS_CLIENT_ID_web 543234829301-2pgqtk6133g5k2l6nbhbfn1dq21ffvi0.apps.googleusercontent.com
ENV GOOGLE_CREDIENTIALS_CLIENT_ID_flutter_web 731962970730-93vd9ao2c9ckhmguioje6ar6jmjk3cic.apps.googleusercontent.com
ENV GOOGLE_CREDIENTIALS_CLIENT_ID_flutter_android 731962970730-eogvrnvtmkq777vvd7s5gumlguqql9o2.apps.googleusercontent.com
ENV SU_USERNAME admin_username
ENV SU_EMAIL admin_email
ENV SU_PASS admin_password


COPY --from=Dependencies /app/node_modules ./node_modules

COPY . .

RUN npm i mongodb-memory-server@8.9.3

RUN npm run test

#End of Tests
# ---------------------------------------------------------
# Build App
FROM node:18.12.0 AS Build

WORKDIR /app

COPY --from=Dependencies /app/node_modules ./node_modules

COPY . .

RUN npm run build

# Remove Not needed Dependencies in node_modules Folder
# RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force

# End of Building
# ---------------------------------------------------------
# Move Dependencies and App To Final Image
FROM node:18.12.0 AS Final

WORKDIR /app

COPY --from=Build /app/node_modules ./node_modules
COPY --from=Build /app/dist ./dist

EXPOSE 3000
# Start the server using the production build
CMD [ "node", "dist/main.js" ]

# End of Final Image