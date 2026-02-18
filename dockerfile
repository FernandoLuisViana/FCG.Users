# Runtime (menor)
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["FCG.Users.API/FCG.Users.API.csproj", "FCG.Users.API/"]
COPY ["FCG.Users.Domain/FCG.Users.Domain.csproj", "FCG.Users.Domain/"]
COPY ["FCG.Users.Infra/FCG.Users.Infra.csproj", "FCG.Users.Infra/"]
COPY ["FCG.Users.Services/FCG.Users.Services.csproj", "FCG.Users.Services/"]
RUN dotnet restore "FCG.Users.API/FCG.Users.API.csproj"

COPY . .
WORKDIR "/src/FCG.Users.API"
RUN dotnet publish "FCG.Users.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore

# Final
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
USER 65532:65532
ENTRYPOINT ["dotnet", "FCG.Users.API.dll"]
