FROM maven:3.6.3-jdk-8 as builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM tomcat:9.0-jdk8

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/FSkills.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
