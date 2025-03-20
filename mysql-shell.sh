#!/bin/bash

source ./common.sh
# here source is indicates when we are call from one script to another we use function

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-serdever -y &>>LOGFILE


systemctl enable mysqld  &>>LOGFILE

 
systemctl start mysqld &>>LOGFILE


mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE


# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature 
mysql -h 172.31.93.44 -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    
else 
    echo -e "MYSQL root password is already setup ...$Y SKIP $N"
fi         