#!/bin/bash

source ./common.sh
check_root() # to call from one scrit from another acript we should keep in function i.e common.sh

echo "Please enter DB password:"
read -s mysql_root_password

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