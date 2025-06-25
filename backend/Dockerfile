# Use an official OpenJDK runtime
FROM openjdk:21-jdk

# Set the working directory
WORKDIR /app

# Copy the JAR file (make sure your backend builds to this path)
COPY target/*.jar app.jar

# Expose the port that Spring Boot runs on
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "app.jar"]
