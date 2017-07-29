#! /bin/bash

#调用步骤：1、source function.sh  2、add 2 3   3、echo $?

#source function.sh会使内部的函数可以在命令行上调用
# $?获取上一条命令执行的返回结果 
add()
{
   let "sum=$1+$2"  # let:用来执行算数运算和数值表达式测试
   return $sum
}

#另一种定义方式
function sub()
{
   let "sum=$1-$2"  # let:用来执行算数运算和数值表达式测试
   return $sum
}
