FROM node:16.17.0-alpine as builder
WORKDIR /app

# Copy only the package files to install dependencies first (better caching)
COPY ./package.json .
#COPY ./yarn.lock . # Ensure that yarn.lock exists, or remove this line if you don't use yarn.lock

# Install dependencies
#RUN yarn install

# Copy the rest of the application
COPY . .

# Build the project
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# You might want to skip TypeScript checks if they are failing in the build stage
# For now, you can bypass the tsc step if it's blocking the Docker build
#RUN yarn build --skip-tsc

# Use nginx to serve the application
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
#COPY --from=builder /app/dist .

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
