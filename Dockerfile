FROM mcr.microsoft.com/dotnet/core/sdk:2.2

# set up environment
ENV DOTNET_BUILD_DIR=/build_dir
	
# This part is copied from the official OpenJDK JRE 8 Dockerfile 
# Source: https://github.com/docker-library/openjdk/blob/master/8-jre/slim/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home/jre

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
    echo 'deb http://deb.debian.org/debian stretch-backports main' \
      > /etc/apt/sources.list.d/stretch-backports.list; \
	apt-get update -y;\
	apt-get install -t \
		stretch-backports \
		openjdk-8-jre-headless \
		ca-certificates-java \
		-y; \
	rm -rf /var/lib/apt/lists/*; \
	\
# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

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
