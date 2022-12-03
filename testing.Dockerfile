FROM cypress/included:11.0.0

WORKDIR /e2e

COPY . .

CMD "npx" "cypress" "run" "--config" "video=false"