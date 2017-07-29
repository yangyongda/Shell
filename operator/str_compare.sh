#! /bin/bash

str1="hello"
str2="hello"


#等于
if [ $str1 = $str2 ]   # =两边要有空格
then 
   echo "str1 = str2"
else
   echo "str1 != str2"
fi

#不等于
if [ $str1 != $str2 ]
then 
   echo "str1 != str2"
else
   echo "str1 = str2"
fi


#检查字符串长度是否为0,不为0返回true
str3="a"

if [ -n "$str3" ]	#此处要加双引号，否则会一直为true
then 
   echo "str3 is not null"
else
   echo "str3 is null"
fi

#检查字符串长度是否为0,为0返回true
#str4="a"

if [ -z "$str4" ]	#此处要加双引号，否则会一直为true
then 
   echo "str4 is null"
else
   echo "str4 is not null"
fi


# [[ ]]:字符串比较的高级特性
if [[ $USER == y* ]]  #判断USER是否是以y开头
then
   echo "Hello, $USER"
else
   echo "Sorry, I don't know you"
fi

