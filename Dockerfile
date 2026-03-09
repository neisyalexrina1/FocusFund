# Build stage
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:10.1-jdk11

# Delete existing ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR file and rename to ROOT.war to serve at /
COPY --from=build /app/target/FocusFund-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Render provides the port in the $PORT environment variable.
# Tomcat by default listens on 8080. We need to replace 8080 with $PORT in sever.xml before starting.
CMD sed -i "s/port=\"8080\"/port=\"${PORT:-8080}\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
