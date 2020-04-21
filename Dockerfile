FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["aspnetcoreapp-docker-demo.csproj", "./"]
RUN dotnet restore "./aspnetcoreapp-docker-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspnetcoreapp-docker-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspnetcoreapp-docker-demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnetcoreapp-docker-demo.dll"]
