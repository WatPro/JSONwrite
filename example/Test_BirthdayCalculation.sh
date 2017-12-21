#!/usr/bin/env bash

################################################################################
########## Run on CentOS 7.3                                          ##########
################################################################################

JUNIT4_URL=http://search.maven.org/remotecontent?filepath=junit/junit/4.12/junit-4.12.jar
JUNIT4_JAR=${JUNIT4_URL##*/}
HARMCREST_URL='http://search.maven.org/remotecontent?filepath=org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar'
HARMCREST_JAR=${HARMCREST_URL##*/}
JUNIT5_API_URL=http://search.maven.org/remotecontent?filepath=org/junit/jupiter/junit-jupiter-api/5.0.2/junit-jupiter-api-5.0.2.jar
JUNIT5_API_JAR=${JUNIT5_API_URL##*/}
APIGUARDIAN_URL=http://search.maven.org/remotecontent?filepath=org/apiguardian/apiguardian-api/1.0.0/apiguardian-api-1.0.0.jar
APIGUARDIAN_JAR=${APIGUARDIAN_URL##*/}
JUNIT5_CONSOLE_URL=https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.0.2/junit-platform-console-standalone-1.0.2.jar
JUNIT5_CONSOLE_JAR=${JUNIT5_CONSOLE_URL##*/}
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

function check_download () {
    if [ ! -e "$1" ]
    then
        curl --location "$2" --output "$3" 
    fi
}

################################################################################
#Download JUnit and its dependencies                                           #
################################################################################
check_download "$JUNIT4_JAR" "$JUNIT4_URL" "$JUNIT4_JAR"
check_download "$HARMCREST_JAR" "$HARMCREST_URL" "$HARMCREST_JAR"
#check_download "$JUNIT5_API_JAR" "$JUNIT5_API_URL" "$JUNIT5_API_JAR"
#check_download "$APIGUARDIAN_JAR" "$APIGUARDIAN_URL" "$APIGUARDIAN_JAR"
#check_download "$JUNIT5_CONSOLE_JAR" "$JUNIT5_CONSOLE_URL" "$JUNIT5_CONSOLE_JAR"
check_download "$MOCKITO_JAR" "$MOCKITO_URL" "$MOCKITO_JAR"
check_download "$BYTEBUDDY_JAR" "$BYTEBUDDY_URL" "$BYTEBUDDY_JAR" 

check_download "$OBJENESIS_JAR" "$OBJENESIS_URL" "$OBJENESIS_ZIP"
if [[ (! -e "$OBJENESIS_JAR") && (-e "$OBJENESIS_ZIP") ]]
then
    yum --assumeyes install unzip
    unzip -j "$OBJENESIS_ZIP" "$OBJENESIS_ZPATH"
    rm --force "$OBJENESIS_ZIP"
fi

################################################################################
#Download MongoDB Java Driver and its dependencies                             #
################################################################################
check_download "$MONGO_JAR" "$MONGO_URL" "$MONGO_JAR"
check_download "$BSON_JAR" "$BSON_URL" "$BSON_JAR"
check_download "$MONGO_CORE_JAR" "$MONGO_CORE_URL" "$MONGO_CORE_JAR"

javac BirthdayCalculation.java

CLASSPATH="."
CLASSPATH="$CLASSPATH:./$MONGO_JAR:./$BSON_JAR:./$MONGO_CORE_JAR"
javac -classpath "$CLASSPATH" TestCollection.java

CLASSPATH="$CLASSPATH:./$JUNIT4_JAR:./$MOCKITO_JAR"
javac -classpath "$CLASSPATH" Test_BirthdayCalculation.java

CLASSPATH="$CLASSPATH:./$HARMCREST_JAR:./$OBJENESIS_JAR:./$BYTEBUDDY_JAR"
java -classpath "$CLASSPATH" org.junit.runner.JUnitCore Test_BirthdayCalculation | grep --invert-match '^[[:blank:]]'

