#!/bin/bash

USERID=$(id -u )
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE() {
    if [ $? -ne 0 ]
then
    echo -e "$2  $R FAILURE"
    exit1
else 
    echo -e .."$2  $G SUCCESS"
fi

}

if [ $USERID -ne 0 ]
then 
    echo "please the run the root access"
    exit2
else
    echo "you are in root access"
fi

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld  &>>LOGFILE
VALIDATE $? "Enabling the MYSQL server"
 
systemctl start mysqld &>>LOGFILE
VALIDATE $?  "Starting  the MYSQL server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root password"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature 
mysql -h 172.31.93.44 -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MYSQL  Root Password setup"
else 
    echo -e "MYSQL root password is already setup ...$Y SKIP $N"
fi         