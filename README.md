All our external dependencies are defined in enterprise pom. We do not want to define scope of the dependencies in the enterprise pom cause we have applications that are deployed both to Tomcat and JBoss. As we all know couple of dependencies come bundled out of the box in JBoss but may not exist in Tomcat default installation. 

bom-parent is the parent of all the application specific enterprise poms. We then created a second level enterprise pom for each app, in the example below its bom-app1. All the projects inherit the app specific enterprise poms.

Sample project with detail instructions and comments available on GitHub

**GitHub : https://github.com/samirshaik/mvn-dep-issue.git**

**Problem:**
In the app specific enterprise pom we would just like to define scope of the dependency declared in dependencyManagement section in the first level enterprise pom. But this is not possible as Maven forces us to declare the version of the dependencies re-declared in the app specific enterprise pom. We went ahead and used the same version property as is declared in first level enterprise pom and every thing worked, except that we lost all the properties of the parent dependency like the exclusion of all the transitive dependencies. 

To us this is very genuine requirement but looks like dependencyManagement the way its designed today, doesn't consider the virtues of inheritance.

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    	<modelVersion>4.0.0</modelVersion>
    
    	<groupId>com.samir.enterprise</groupId>
    	<artifactId>bom-parent</artifactId>
    	<version>1.0.0</version>
    	<packaging>pom</packaging>
    	<name>Enterprise BOM</name>
    
    	<properties>
    		<log4j.version>1.2.17</log4j.version>
    	</properties>
    
    	<dependencies>
    		<dependency>
    			<groupId>log4j</groupId>
    			<artifactId>log4j</artifactId>
    			<version>${log4j.version}</version>
    			<exclusions>
    				<exclusion>
    					<groupId>*</groupId>
    					<artifactId>*</artifactId>
    				</exclusion>
    			</exclusions>
    		</dependency>
    	</dependencies>
    </project>

Below is sample snippet of the child BOM, which should let me define the scope of the dependency and inherit all the features of the parent. 

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    	<modelVersion>4.0.0</modelVersion>
    
    	<parent>
    		<groupId>com.samir.enterprise</groupId>
    		<artifactId>bom-parent</artifactId>
    		<version>1.0.0</version>
    	</parent>
    	
    	<groupId>com.samir.enterprise</groupId>
    	<artifactId>bom-app1</artifactId>
    	<version>1.0.0</version>
    	<packaging>pom</packaging>
    	<name>Enterprise Child BOM</name>
    
    	<dependencies>
    		<dependency>
    			<groupId>log4j</groupId>
    			<artifactId>log4j</artifactId>
    			<scope>provided</scope>
    		</dependency>
    	</dependencies>
    </project>


## Execute following scripts to install the enterprise bom files in local .m2 repository
- ./resources/bom-parent/install-file.sh
- ./resources/bom-app1/install-file.sh

## Failed scenario : javaee-api has exclusions added to ban all transitive dependencies in bom-parent
- run command "mvn dependency:tree"
- notice that javaee-api gets all transitive dependencies
```
[INFO] --- maven-dependency-plugin:2.8:tree (default-cli) @ my-app ---
[INFO] com.mycompany.app:my-app:jar:1.0.0-SNAPSHOT
[INFO] +- log4j:log4j:jar:1.2.17:provided
[INFO] +- javax:javaee-api:jar:7.0:provided
[INFO] |  \- com.sun.mail:javax.mail:jar:1.5.0:provided
[INFO] |     \- javax.activation:activation:jar:1.1:provided
[INFO] \- junit:junit:jar:4.4:test
```

## Pass scenario with a work-around : after explicitly redeclaring exclusion in direct parent bom-app1
- update ./resources/bom-app1/pom.xml and un-comment <exclusions> section and rerun the command "mvn dependency:tree"
- notice that javaee-api doesn't get any transitive dependencies
```
[INFO] --- maven-dependency-plugin:2.8:tree (default-cli) @ my-app ---
[INFO] com.mycompany.app:my-app:jar:1.0.0-SNAPSHOT
[INFO] +- log4j:log4j:jar:1.2.17:provided
[INFO] +- javax:javaee-api:jar:7.0:provided
[INFO] \- junit:junit:jar:4.4:test
```


Stackoverflow : https://stackoverflow.com/questions/59013845/maven-dependencymangement-doesnt-inherit-the-virtue-of-dependencies-in-the-pare
