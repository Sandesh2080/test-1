FROM docker.io/library/tomcat:latest

# Fix for Tomcat 10+ (moves default manager/apps into the active folder)
RUN cp -r /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps/

# Use the wildcard to find the file regardless of the version number
# Renaming it to ROOT.war makes it the default app at http://localhost:8080/
COPY webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war
