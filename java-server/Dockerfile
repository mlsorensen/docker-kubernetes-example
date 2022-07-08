FROM maven:3.6.0-jdk-11-slim AS builder
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:11-jre-slim
COPY --from=builder /home/app/target/java-server*.jar /usr/local/lib/app.jar
CMD ["java","-cp","/usr/local/lib/app.jar", "com.turboio.App"]
