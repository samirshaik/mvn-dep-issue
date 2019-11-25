# READ ME

## Execute following scripts to install the enterprise bom files
- ./resources/bom-parent/install-file.sh
- ./resources/bom-app1/install-file.sh

## Failed Scenario
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

## Pass scenario with a work-around
- update ./resources/bom-app1/pom.xml and un-comment <exclusions> section and rerun the command "mvn dependency:tree"
- notice that javaee-api doesn't get any transitive dependencies
```
[INFO] --- maven-dependency-plugin:2.8:tree (default-cli) @ my-app ---
[INFO] com.mycompany.app:my-app:jar:1.0.0-SNAPSHOT
[INFO] +- log4j:log4j:jar:1.2.17:provided
[INFO] +- javax:javaee-api:jar:7.0:provided
[INFO] \- junit:junit:jar:4.4:test
```
