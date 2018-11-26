FROM openjdk:8-jre-slim
EXPOSE 8080
ADD kafka-producer-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT exec java -jar app.jar