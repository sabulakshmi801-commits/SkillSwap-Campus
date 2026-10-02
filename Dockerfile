# Stage 1: Build the code using Ant
FROM ant:1.10-jdk11 AS builder
WORKDIR /app
COPY . .
RUN ant

# Stage 2: Run it on Tomcat
FROM tomcat:9.0-jdk11-openjdk
COPY --from=builder /app/dist/SkillSwapCampus.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]