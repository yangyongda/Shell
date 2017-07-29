#! /bin/bash

var=123
echo '$var'  #单引号中的变量不能获取值，输出为$var
echo "$var"  #双引号中的变量可以获取值，输出为123

#以下两种变量使用都是OK的，但是推荐第二种
var2=hello
echo $var2  
echo ${var2}
