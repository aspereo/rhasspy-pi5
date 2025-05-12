FROM arm64v8/openjdk:8-jre

RUN apt-get update && apt-get install -y curl \
    && curl -L https://github.com/marytts/marytts/releases/download/v5.2/marytts-5.2.zip -o marytts.zip \
    && unzip marytts.zip -d /opt \
    && rm marytts.zip

WORKDIR /opt/marytts-5.2
EXPOSE 59125
CMD ["java", "-Xmx1g", "-cp", "lib/*:marytts-5.2.jar", "marytts.server.Mary"]
