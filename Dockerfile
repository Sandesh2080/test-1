FROM docker.io/library/tomcat:latest
# Change this:
COPY webapp/target/webapp.war /usr/local/tomcat/webapps

# To this (using a wildcard is safer if the name varies):
COPY webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war
