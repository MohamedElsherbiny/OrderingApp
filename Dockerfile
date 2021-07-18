FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY OrderingApp.sln .
COPY Ordering.Calc.Api/*.csproj ./Ordering.Calc.Api/
COPY Ordering.Calc.Api/*.config ./Ordering.Calc.Api/
RUN nuget restore

# copy everything else and build app
COPY Ordering.Calc.Api/. ./Ordering.Calc.Api/
WORKDIR /app/Ordering.Calc.Api
RUN msbuild /p:Configuration=Release -r:False


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/Ordering.Calc.Api/. ./