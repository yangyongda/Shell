#! /bin/bash

for file in `find *.sh`  #遍历所有以.sh结尾的文件
do
   echo $file
done

for test in aaa bbb ccc ddd eee
do
   echo $test
done 

#遍历/home/yang下的所有目录和文件
for file1 in /home/yang/*
do 
   if [ -d "$file1" ] #判断是不是目录
   then 
     echo "$file1 is the directory"
   elif [ -f "$file1" ]  #判断是不是文件
   then
     echo "$file1 is the file"
   fi
done

#使用for和(())配合实现C风格for语句
for (( i=0; i<10; i++ ))
do
   echo "number is $i"
done
