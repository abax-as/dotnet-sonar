FROM mcr.microsoft.com/dotnet/core/sdk:3.1.102-alpine3.10

# set up environment
ENV DOTNET_BUILD_DIR=/build_dir

RUN apk --no-cache add openjdk11-jre-headless --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN apk --no-cache --update add git less openssh && \
    rm -rf /var/lib/apt/lists/*

# Install Sonar Scanner, trx2junit and minver
ENV PATH="${PATH}:/root/.dotnet/tools"
RUN dotnet tool install -g dotnet-sonarscanner; \
    dotnet tool install -g trx2junit; \
    dotnet tool install -g minver-cli

WORKDIR $DOTNET_BUILD_DIR
