# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Optimasi Cache: Download dependency duluan
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code dan build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime (Pake JRE biar kecil & aman)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy file jar hasil build tadi
COPY --from=build /app/target/*.jar app.jar

# Jalankan sebagai user non-root (Opsional tapi Pro)
# EXPOSE tetap di 8080 sesuai Spring Boot default
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]