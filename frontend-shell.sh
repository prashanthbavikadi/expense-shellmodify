#!?bin/bash

source ./common.sh
# here source is indicates when we are call from one script to another we use function

check_root

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "installing the nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling the nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting the nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting frontend code"

#check your repo and path
cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"