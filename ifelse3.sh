#! /bin/bash

testuser=badtest
if grep $testuser /etc/passwd  #在passwd文件中查找用户
then
  echo "the files for user $testuser are:"
  ls -a /home/$testuser/.b*
else
  echo "user $testuser don't exist"
fi
