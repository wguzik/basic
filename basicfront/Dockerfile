FROM node:14-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application files
COPY src ./src

FROM node:14-alpine AS runner

# Set up working directory
WORKDIR /app

# Copy built node modules and production files from builder
COPY --from=builder /app/node_modules ./src/node_modules
COPY --from=builder /app/src ./src

# Expose port 3000
EXPOSE 3000

# Set up environment variable
ENV LOCATION=default

# Start the application
CMD ["node", "src/app.js"]
