#!/usr/bin/env bash

################################################################################
########## Run on CentOS 7.3                                          ##########
################################################################################

JUNIT4_URL=http://search.maven.org/remotecontent?filepath=junit/junit/4.12/junit-4.12.jar
JUNIT4_JAR=${JUNIT4_URL##*/}
HARMCREST_URL='http://search.maven.org/remotecontent?filepath=org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar'
HARMCREST_JAR=${HARMCREST_URL##*/}
MOCKITO_URL='http://jcenter.bintray.com/org/mockito/mockito-core/2.12.0/:mockito-core-2.12.0.jar'
################################################################################
#//1512184978444                                                               #
#function navi(e){                                                             #
#    location.href = e.target.href.replace('/:','/'); e.preventDefault();      #
#}                                                                             #
################################################################################
MOCKITO_URL=${MOCKITO_URL/\/:/\/}
MOCKITO_JAR=${MOCKITO_URL##*/}
BYTEBUDDY_URL='https://bintray.com/raphw/maven/download_file?file_path=net/bytebuddy/byte-buddy/1.7.9/byte-buddy-1.7.9.jar'
BYTEBUDDY_JAR=${BYTEBUDDY_URL##*/}
OBJENESIS_URL='https://bintray.com/easymock/distributions/download_file?file_path=objenesis-2.6-bin.zip'
OBJENESIS_ZIP=${OBJENESIS_URL##*=}
OBJENESIS_ZPATH='objenesis-2.6/objenesis-2.6.jar'
OBJENESIS_JAR=${OBJENESIS_ZPATH##*/}
################################################################################
#MongoDB Java Driver                                                           #
#http://mongodb.github.io/mongo-java-driver/                                   #
################################################################################
MONGO_URL=http://search.maven.org/remotecontent?filepath=org/mongodb/mongodb-driver/3.6.0/mongodb-driver-3.6.0.jar
MONGO_JAR=${MONGO_URL##*/}
BSON_URL=http://search.maven.org/remotecontent?filepath=org/mongodb/bson/3.6.0/bson-3.6.0.jar
BSON_JAR=${BSON_URL##*/}
MONGO_CORE_URL=http://search.maven.org/remotecontent?filepath=org/mongodb/mongodb-driver-core/3.6.0/mongodb-driver-core-3.6.0.jar
MONGO_CORE_JAR=${MONGO_CORE_URL##*/}

################################################################################
#Download JUnit and its dependencies                                           #
################################################################################
if [ ! -e "$JUNIT4_JAR" ] 
then
    curl "$JUNIT4_URL" --output "$JUNIT4_JAR"
fi

if [ ! -e "$HARMCREST_JAR" ] 
then
    curl "$HARMCREST_URL" --output "$HARMCREST_JAR"
fi

if [ ! -e "$MOCKITO_JAR" ]
then
    curl --location "$MOCKITO_URL" --output "$MOCKITO_JAR"
fi

if [ ! -e "$BYTEBUDDY_JAR" ]
then
    curl --location "$BYTEBUDDY_URL" --output "$BYTEBUDDY_JAR"
fi

if [ ! -e "$OBJENESIS_JAR" ]
then
    yum --assumeyes install unzip
    curl --location "$OBJENESIS_URL" -o "$OBJENESIS_ZIP"
    unzip -j "$OBJENESIS_ZIP" "$OBJENESIS_ZPATH"
    rm --force "$OBJENESIS_ZIP"
fi

################################################################################
#Download MongoDB Java Driver and its dependencies                             #
################################################################################
if [ ! -e "$MONGO_JAR" ]
then
    curl "$MONGO_URL" --output "$MONGO_JAR" 
fi
if [ ! -e "$BSON_JAR" ]
then
    curl "$BSON_URL" --output "$BSON_JAR" 
fi
if [ ! -e "$MONGO_CORE_JAR" ]
then
    curl "$MONGO_CORE_URL" --output "$MONGO_CORE_JAR" 
fi

javac BirthdayCalculation.java

CLASSPATH="."
CLASSPATH="$CLASSPATH:./$MONGO_JAR:./$BSON_JAR:./$MONGO_CORE_JAR"
javac -classpath "$CLASSPATH" TestCollection.java

CLASSPATH="$CLASSPATH:./$JUNIT4_JAR:./$MOCKITO_JAR"
javac -classpath "$CLASSPATH" Test_BirthdayCalculation.java

CLASSPATH="$CLASSPATH:./$HARMCREST_JAR:./$OBJENESIS_JAR:./$BYTEBUDDY_JAR"
java -classpath "$CLASSPATH" org.junit.runner.JUnitCore Test_BirthdayCalculation | grep --invert-match '^[[:blank:]]'

