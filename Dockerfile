FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT=Production
COPY --from=build /app/out .
EXPOSE 80
ENTRYPOINT ["dotnet", "MeuAppDocker.dll"]
