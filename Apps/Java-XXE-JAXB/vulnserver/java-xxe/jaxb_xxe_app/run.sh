#!/bin/bash
cd target/classes/
java -cp ".:../jaxb_xxe_app-1.0-SNAPSHOT.jar" com.hloverflow.jaxb_xxe_app.XXEApp
cd ../../
