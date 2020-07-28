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


.Net dockerfile

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["KSB_PumpTest2_ConfigurationService.csproj", "./"]
COPY KSB_PumpTest2_DataAccess/packages /packages
RUN dotnet nuget add source -n LocalPackages /packages
RUN dotnet restore "KSB_PumpTest2_ConfigurationService.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "KSB_PumpTest2_ConfigurationService.csproj" -c Release -o /app/build

FROM build AS testrun
RUN dotnet test Tests/

FROM build AS publish
RUN dotnet publish "KSB_PumpTest2_ConfigurationService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KSB_PumpTest2_ConfigurationService.dll"]
