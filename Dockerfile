# Usando a imagem base do SDK do .NET para build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia os arquivos e compila a aplicação
COPY . .
RUN dotnet publish -c Release -o out

# Usando a imagem base do Runtime do .NET para otimizar a imagem final
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Instala o bash e sh
RUN apt-get update && apt-get install -y bash procps

# Copia os arquivos compilados da fase de build para a pasta atual
COPY --from=build /app/out .

# Expondo a porta para a aplicação
EXPOSE 80

# Define o ponto de entrada para a aplicação
ENTRYPOINT ["dotnet", "MeuAppDocker.dll"]
