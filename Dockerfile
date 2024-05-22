FROM eclipse-temurin:17-jdk-focal
LABEL maintainer= "krishna kumara y"
COPY target/web-services.jar web-services.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "web-services.jar"]
