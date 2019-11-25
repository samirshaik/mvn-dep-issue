#!/bin/bash

# Update settings.xml file and replace <!--ENTER THE PASSWORD HERE--> with real password
mvn install:install-file -Dfile=./pom.xml -DpomFile=./pom.xml -Dpackaging=pom
