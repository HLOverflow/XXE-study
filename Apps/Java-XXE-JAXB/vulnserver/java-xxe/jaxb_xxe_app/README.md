# Java XXE demonstration

Parser that is being used is JAXB (Java Architecture for XML Binding).

# Set up

1. run `mvn package`. This is to build the dependencies into a single jar file. Subsequent runs can use `mvn compile` to reduce overhead.
2. run `run.sh` which will include the dependency and run the App.java file.

# Customization of code

1. Customize the file at ./src/main/java/com/hloverflow/jaxb_xxe_app/App.java
2. run `mvn compile`. 
3. run `run.sh`.

# Clean up
1. run `mvn clean`. This will remove the entire target folder.
