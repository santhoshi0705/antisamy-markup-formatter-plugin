# Stage 1: Build the plugin using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy plugin source code
COPY . .

# Build the plugin (skip tests if desired)
RUN mvn clean install -DskipTests

# Stage 2: Create Jenkins with the plugin installed
FROM jenkins/jenkins:lts-jdk17

# Set environment variables
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Install required plugins
RUN jenkins-plugin-cli --plugins gitlab-plugin git git-client workflow-aggregator credentials

# Copy the built plugin (.hpi) from the builder stage to Jenkins plugins directory
COPY --from=builder /app/target/gitlab-plugin.hpi /usr/share/jenkins/ref/plugins/gitlab-plugin.hpi

# Expose default Jenkins port
EXPOSE 8080

# Default entrypoint is Jenkins
