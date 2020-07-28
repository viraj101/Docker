FROM node:12.15.0-alpine AS build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
RUN npm cache verify
RUN rm -rf node_modules
COPY package.json /app/package.json
RUN npm install -g react-scripts@2.1.3 typescript@3.2.2 --silent
RUN npm install --silent
COPY . /app
RUN npm run build

FROM nginx:alpine AS runtime
COPY --from=build /app/build/ /usr/share/nginx/html/
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx-vhost.conf /etc/nginx/conf.d
COPY nginx/certs /etc/nginx/certs
COPY pumptest-ui-entrypoint.sh /
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/pumptest-ui-entrypoint.sh"]
