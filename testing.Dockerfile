FROM cypress/included

WORKDIR /e2e

COPY . .

CMD "npx" "cypress" "run" "--config video=false"