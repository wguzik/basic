# Stage 1: Build React frontend
FROM node:20-alpine AS react-build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY public ./public
COPY src ./src
RUN npm run build

# Stage 2: Bundle Express server + all dependencies into a single file
FROM node:20-alpine AS server-build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY server.js ./
RUN npx @vercel/ncc build server.js -o dist --minify --quiet

# Stage 3: Minimal production image — no node_modules needed
FROM node:20-alpine

LABEL version="1.0"
LABEL description="Basic Gallery App"

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=server-build /app/dist/index.js ./server.js
COPY --from=react-build /app/build ./build

RUN chown -R appuser:appgroup /app

USER appuser

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

EXPOSE 3000

CMD ["node", "server.js"]
