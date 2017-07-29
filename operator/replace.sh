#! /bin/bash

#替换操作符 :-  :=  :?   

#如果varname存在并且非null,则返回varname的值,否则返回hello
#varname="welcome to quanzhou"
echo ${varname:-"hello"} 

#如果varname1存在并且非null,则返回varname1的值,否则先将varname1的值赋为quanzhou,然后返回varname1的值
#varname1="welcome to China"
echo ${varname1:="quanzhou"}
echo $varname1


#如果varname2存在并且非null,则返回varname2的值,否则打印varname2 is null,并退出脚本
varname2="hi, my name is yang"
echo ${varname2:?"varname2 is null"}
echo "if varname2 is null, this line not output!"


#如果varname2存在并且非null,则返回nice to meet you too,否则返回null
#主要用来测试变量是否存在
#varname3="nice to meet you"
echo ${varname3:+"nice to meet you too"}
