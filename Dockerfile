FROM openjdk:8-jdk-alpine

COPY demo-devops-0.0.1.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]