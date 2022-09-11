FROM eclipse-temurin:18.0.1_10-jdk-jammy
RUN groupadd -r spring && useradd spring -g spring
USER spring:spring
ARG JAR_FILE=target/demo-app.jar
COPY ${JAR_FILE} demo-app.jar
ENTRYPOINT java $JAVA_OPTS -jar demo-app.jar