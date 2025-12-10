# Utiliser une image de base avec OpenJDK 17
FROM openjdk:17-jdk-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR de l'application
# Le JAR sera créé lors de l'étape Package du pipeline
COPY target/timesheet-devops-1.0.jar app.jar

# Exposer le port 8082 (port de l'application Spring Boot)
EXPOSE 8082

# Commande pour démarrer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]

