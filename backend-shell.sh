#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
Y="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please provide DB password:"
read  mysql_root_password #if you put -s password cannot displed while entering


VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2 ...$R FAILURE $N"
        exit 1
    else
        echo -e "$2 ...$G SUCCESS $N"
    fi
}


if [ $USERID -ne 0 ]
then 
    echo "please run this script with root access"
    exit 1  # manually exit if error comes.
else 
    echo "you are in superuser"
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling the Nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enableing the Nodejs:20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing the nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then 
    useradd expense &>>$LOGFILE
    VALIDATE $? "please create the user if not exit" 
else
    echo "Already user is existed ...$Y SKPPING FOR NOW $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "unzipping the file"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Unzipping the backend file"

cd /app
npm  install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"

#check your repo and path
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload >>$LOGFILE
VALIDATE $? "Reloading the deamon"

systemctl start backend >>$LOGFILE
VALIDATE $? "Starting backend"

systemctl enable backend  >>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Client"

mysql -h 172.31.93.44 -uroot -p${mysql_root_password} < /app/schema/backend.sql 
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"