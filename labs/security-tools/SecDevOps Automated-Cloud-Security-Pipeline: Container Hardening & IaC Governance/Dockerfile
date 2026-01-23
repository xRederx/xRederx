FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache git python3 make g++
RUN git clone https://github.com/juice-shop/juice-shop.git .

RUN npm pkg set overrides.lodash=^4.17.12
RUN npm pkg set overrides.crypto-js=4.2.0

RUN npm install --omit=dev

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

CMD ["npm", "start"]

# Build the image:
#   docker build -t juice-shop-secure .
# Scan the image with Trivy:
#   trivy image --format json juice-shop-secure > trivy-results.json