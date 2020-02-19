FROM mcr.microsoft.com/dotnet/core/sdk:3.1

# set up environment
ENV DOTNET_BUILD_DIR=/build_dir
	
# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install Sonar Scanner for .NET Core
ENV PATH="${PATH}:/root/.dotnet/tools"
RUN dotnet tool install -g dotnet-sonarscanner

# Install trx -> JUnit parser
RUN dotnet tool install -g trx2junit

# Install minver
RUN dotnet tool install -g minver-cli

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; \
	chmod +x /usr/local/bin/docker-compose; \
	docker-compose --version

WORKDIR $DOTNET_BUILD_DIR
