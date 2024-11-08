# 🐋Learn Docker

## Descrição
Este repositório é dedicado ao aprendizado e prática de Docker com um projeto simples em ASP.NET Core.

## Dia 1 - Criando um Aplicativo ASP.NET Core com Docker

- **Objetivo:** Criar uma aplicação ASP.NET Core e executá-la em um contêiner Docker.
- **Passos Realizados:**
  1. **Criar um novo projeto ASP.NET Core**:
     ```bash
     dotnet new webapp -n MeuAppDocker
     cd MeuAppDocker
     ```
  2. **Criar um arquivo Dockerfile** na raiz do projeto.
  3. **Construir a imagem Docker**:
     ```bash
     docker build -t meuappdocker .
     ```
  4. **Executar o contêiner**:
     ```bash
     docker run -d -p 8080:80 --name meuappcontainer meuappdocker
     ```
  5. **Acessar a aplicação** no navegador: [http://localhost:8080](http://localhost:8080).

## Dia 2 - Lidando com Contêineres e Erros

- **Objetivo:** Aprender a gerenciar contêineres e resolver problemas comuns.
- **Passos Realizados:**
  1. **Verifiquei os contêineres em execução** com `docker ps`.
  2. **Resolvi um problema de contêiner zumbi** usando:
     ```bash
     docker rm -f meuappcontainer
     ```
  3. **Recriei o contêiner com a opção `--init`** para evitar processos zumbis:
     ```bash
     docker run -d -p 8080:80 --name meuappcontainer --init meuappdocker
     ```
  4. **Verifiquei se o contêiner estava em execução** e acessei a aplicação com sucesso.

## Dia 3 - Atualizando o Dockerfile e Acessando o Contêiner com Bash

- **Objetivo:** Modificar o `Dockerfile` para adicionar o bash, recriar o contêiner e explorar o contêiner.
- **Passos Realizados:**
  1. Atualizei o `Dockerfile` para incluir o bash:
     ```Dockerfile
     # Usando a imagem base do SDK do .NET para build
     FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
     WORKDIR /app
     COPY . .
     RUN dotnet publish -c Release -o out

     # Usando a imagem base do Runtime do .NET
     FROM mcr.microsoft.com/dotnet/aspnet:8.0
     WORKDIR /app
     RUN apt-get update && apt-get install -y bash
     COPY --from=build /app/out .
     EXPOSE 80
     ENTRYPOINT ["dotnet", "MeuAppDocker.dll"]
     ```
  2. Reconstruí a imagem Docker:
     ```bash
     docker build -t meuappdocker .
     ```
  3. Recriei o contêiner:
     ```bash
     docker rm -f meuappcontainer
     docker run -d -p 8080:80 --name meuappcontainer meuappdocker
     ```
  4. Acessei o contêiner com o comando:
     ```bash
     docker exec -it meuappcontainer /bin/bash
     ```

## Dia 4 - Configurando Variáveis de Ambiente

- **Objetivo:** Entender como configurar variáveis de ambiente dentro do Docker para tornar a aplicação mais flexível.
- **Passos Realizados:**
  1. **Atualizei o Dockerfile** para incluir variáveis de ambiente:
     ```Dockerfile
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
     ```
  2. **Reconstruí a imagem e recriei o contêiner**:
     ```bash
     docker build -t meuappdocker .
     docker rm -f meuappcontainer
     docker run -d -p 8080:80 --name meuappcontainer meuappdocker
     ```
  3. **Verifiquei a variável de ambiente dentro do contêiner**:
     ```bash
     docker exec -it meuappcontainer printenv ASPNETCORE_ENVIRONMENT
     ```
     - O valor retornado foi `Production`, confirmando que a variável foi configurada.

## Dia 5 - Persistindo Dados com Volumes

- **Objetivo:** Configurar volumes para persistir dados fora do contêiner e entender como manter os dados entre reinicializações.
- **Passos Realizados:**
  1. **Configurei um volume** ao iniciar o contêiner para que os dados sejam persistidos no host:
     ```bash
     docker run -d -p 8080:80 --name meuappcontainer -v $(pwd)/appdata:/app/data meuappdocker
     ```
  2. **Criei um diretório `/app/data`** dentro do contêiner para armazenar os dados persistentes da aplicação.
  3. **Testei a persistência de dados** criando um arquivo de teste dentro do contêiner:
     ```bash
     docker exec -it meuappcontainer touch /app/data/teste.txt
     ```
  4. **Verifiquei a persistência** ao remover e recriar o contêiner:
     ```bash
     docker rm -f meuappcontainer
     docker run -d -p 8080:80 --name meuappcontainer -v $(pwd)/appdata:/app/data meuappdocker
     ```
  5. O arquivo `teste.txt` permaneceu na pasta `appdata` no host, confirmando que o volume foi configurado corretamente.

  ## Dia 6 - Conectando Contêineres com Redes Docker

- **Objetivo:** Configurar uma rede Docker personalizada para conectar a aplicação ASP.NET ao contêiner SQL Server.
- **Passos Realizados:**

  1. **Criei uma rede Docker** para permitir a comunicação entre os contêineres da aplicação e do banco de dados:
     ```bash
     docker network create minha-rede-aspnet
     ```

  2. **Executei o contêiner do SQL Server** e o conectei à rede recém-criada:
     ```bash
     docker run -d \
       --network minha-rede-aspnet \
       --name sqlserver-container \
       -e "ACCEPT_EULA=Y" \
       -e "SA_PASSWORD=MinhaSenhaSegura123" \
       -p 1433:1433 \
       mcr.microsoft.com/mssql/server:2019-latest
     ```
     - **Nota:** Substituí `MinhaSenhaSegura123` por uma senha segura para o SQL Server.

  3. **Configurei a string de conexão** no arquivo `appsettings.json` da minha aplicação ASP.NET para usar o nome do contêiner SQL Server como servidor:
     ```json
     "ConnectionStrings": {
         "DefaultConnection": "Server=sqlserver-container;Database=MeuBancoDeDados;User Id=sa;Password=MinhaSenhaSegura123;"
     }
     ```

  4. **Construí a imagem Docker** da aplicação ASP.NET com o novo `Dockerfile`:
     ```bash
     docker build -t meuappaspnet .
     ```

  5. **Executei o contêiner da aplicação** e o conectei à mesma rede do SQL Server:
     ```bash
     docker run -d \
       --network minha-rede-aspnet \
       -p 5000:80 \
       --name meuapp-container \
       meuappaspnet
     ```
     - Assim, configurei a aplicação para estar acessível na porta `5000` do meu host.

  6. **Teste de comunicação**: Para garantir que os contêineres estavam se comunicando, usei o comando `ping` no contêiner da aplicação para verificar se ele conseguia alcançar o contêiner SQL Server:
     ```bash
     docker exec -it meuapp-container ping sqlserver-container
     ```
     - Como o `ping` respondeu normalmente, confirmei que a comunicação entre os contêineres estava funcionando.
