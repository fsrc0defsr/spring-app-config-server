# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS build

COPY settings.xml /root/.m2/settings.xml

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Package
FROM openjdk:17-jdk-slim

# Создание непривилегированного пользователя
RUN useradd -m springuser

# Устанавливаем рабочую директорию и копируем приложение
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Изменяем права доступа к файлам и директориям
RUN chown -R springuser:springuser /app

# Меняем пользователя
USER springuser

EXPOSE 8888
ENTRYPOINT ["java", "-jar", "app.jar"]
