#!/bin/bash


set -e

handle_error(){
    echo "Error occured at line number: $1, error command: $2"
}

trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR


USERID=$(id -u )
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE() {
    if [ $? -ne 0 ]
then
    echo -e "$2  $R FAILURE"
    exit 1
else 
    echo -e .."$2  $G SUCCESS"
fi

}

check_root(){
     if [ $USERID -ne 0 ]
     then 
         echo "please the run the root access"
         exit 1
     else
         echo "you are in root access"
     fi

}