FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY . /app
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk11
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080