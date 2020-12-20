FROM node:alpine AS builder
WORKDIR /usr/src/app
ENV NODE_ENV=production
COPY package*.json .
RUN npm install
RUN npm install -g typescript
COPY src .
COPY tsconfig.json .
RUN npx tsc

FROM nginx:alpine 
WORKDIR /var/www/html
COPY . .
COPY --from=builder /usr/src/app/client.js .
CMD ["./app"]  