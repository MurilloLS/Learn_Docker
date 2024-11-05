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
- **Principais Ações:**
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

