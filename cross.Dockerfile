# Build App
FROM instrumentisto/flutter:3.3.7 AS Build

WORKDIR /app

COPY ./ /app

RUN flutter doctor

RUN flutter build web --dart-define=BASE_URL=${BASE_URL}

# End of Building
# ---------------------------------------------------------
# Move App To Final Image
FROM nginx:latest AS Final

COPY nginx.conf /etc/nginx/conf.d

COPY --from=Build /app/build/web/ /usr/share/nginx/html

EXPOSE 80

# End of Final Image