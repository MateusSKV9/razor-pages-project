# Passo 1: Usar a imagem base do .NET SDK
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Passo 2: Usar a imagem do .NET SDK para build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["RazorPagesProject/RazorPagesProject.csproj", "RazorPagesProject/"]
RUN dotnet restore "RazorPagesProject/RazorPagesProject.csproj"
COPY . .
WORKDIR "/src/RazorPagesProject"
RUN dotnet build "RazorPagesProject.csproj" -c Release -o /app/build

# Passo 3: Publicar a aplicação
FROM build AS publish
RUN dotnet publish "RazorPagesProject.csproj" -c Release -o /app/publish

# Passo 4: Criar a imagem final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RazorPagesProject.dll"]
