#! /bin/bash

#expr处理数学表达式

var1=10
var2=20
var3=`expr $var2 / $var1` #要将数学算式结果赋给一个变量需要使用``，``会先执行里面的命令
echo "result is $var3"



#使用$[operation] 来进行数学运算，它和expr等价
var4=100
var5=50
var6=45
var7=$[$var4 * ($var5 - $var6)]
echo "result is $var7"

exit 5  #退出状态码，可以通过$?来获取，退出状态码最大255
