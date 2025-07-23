# Stage 1: Build the Jenkins plugin using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy plugin source into the container
COPY . .

# Build the plugin (skip tests for faster build, optional)
RUN mvn clean install -DskipTests

# Stage 2: Jenkins with the plugin installed
FROM jenkins/jenkins:lts-jdk17

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Install required plugins (add more if needed)
RUN jenkins-plugin-cli --plugins antisamy-markup-formatter

# Copy the custom-built plugin into Jenkins
COPY --from=builder /app/target/antisamy-markup-formatter.hpi /usr/share/jenkins/ref/plugins/antisamy-markup-formatter.hpi

# Expose default Jenkins ports
EXPOSE 8080
EXPOSE 50000
