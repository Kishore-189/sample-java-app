# Use an official Maven image to build the Spring Boot app
FROM maven:eclipse-temurin AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .

# Download Maven dependencies
RUN mvn dependency:go-offline -B

# Copy the source code to the Docker image
COPY src ./src

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# Use an official OpenJDK runtime as a base image for running the Spring Boot app
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the jar file from the build stage  
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080 (the default port for Spring Boot apps)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]