FROM jenkins/jenkins:lts-jdk17

USER root

# Optional: install curl if needed
RUN apt-get update && apt-get install -y curl

# Ensure correct permissions
RUN chown -R jenkins:jenkins /usr/share/jenkins

USER jenkins

# Install the unique-id plugin (corrected character encoding)
RUN jenkins-plugin-cli --plugins unique-id
