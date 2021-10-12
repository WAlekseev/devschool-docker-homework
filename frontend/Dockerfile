# # # # # # # # # 
#  Build Stage  #
# # # # # # # # # 

# Latest node and alpine as base image
FROM node:alpine as builder 

# Working directory
WORKDIR '/app'

# Copy the dependencies file for npm
COPY package.json .

# Install dependencies
RUN npm install

# Copy frontend code
COPY . .

# Build the project for production
RUN npm run build 

# # # # # # # # #
#  Final Stage  #
# # # # # # # # #

# Build final image for production
FROM nginx:alpine

#Copy production build files from builder phase to nginx
COPY --from=builder /app/build /usr/share/nginx/html

#Copy virtual host configuration file
COPY config/default.conf /etc/nginx/conf.d/default.conf
