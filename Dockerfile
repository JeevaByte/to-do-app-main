# -----------------------------
# Stage 1: Build the React app
# -----------------------------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy only the frontend package files first (better caching)
COPY frontend/package*.json ./frontend/

# Install dependencies
RUN cd frontend && npm install

# Copy full frontend source
COPY frontend ./frontend

# Build React app
RUN cd frontend && npm run build



# -----------------------------
# Stage 2: Serve with NGINX
# -----------------------------
FROM nginx:alpine

# Copy build output from builder stage
COPY --from=builder /app/frontend/build /usr/share/nginx/html

EXPOSE 80

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
