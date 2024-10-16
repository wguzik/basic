# Build stage
FROM node:14-alpine AS build

WORKDIR /app

COPY package*.json ./
# Add these debug steps

RUN npm install

COPY . .
RUN npm run build

# Production stage
FROM node:14-alpine

WORKDIR /app

RUN npm install -g serve

COPY --from=build /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
