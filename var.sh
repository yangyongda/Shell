#! /bin/bash
var="hello world!!"  #变量赋值时等号两边不能有空格，赋值内容有空格要加引号
var2=hello!          #没有空格可以不加引号，但是推荐使用加引号的方式
int1=100
int2=200
echo $var            #使用$可以获取变量的值
echo $var2
echo $(($int1+$int2)) #整数运算，此处必须两个括号，写成$($int1+$int2)会出错
