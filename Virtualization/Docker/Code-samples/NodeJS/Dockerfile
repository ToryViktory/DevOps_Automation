# Set default versions of base images
ARG node_version=6.10.0

############### BUILD STAGE ###############
FROM node:${node_version} as BUILD

# Set working directory for container 
WORKDIR /usr/app

# Copy all app files
COPY . .        

# Install, update and build
RUN npm install 
# && npm run test && npm run build 

# Remove development dependencies
# RUN npm prune --production
# RUN npm install -g node-prune
# RUN node-prune

############### PACKAGE STAGE ###############
FROM node:${node_version}-alpine as PACKAGE
WORKDIR /usr/app
# COPY --from=BUILD /usr/app/package.json ./package.json
# COPY --from=BUILD /usr/app/package-lock.json ./package-lock.json
# COPY --from=BUILD /usr/app/node_modules ./node_modules
COPY --from=BUILD /usr/app/ .

EXPOSE 3000
CMD ["npm", "start"]
