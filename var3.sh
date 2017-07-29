#! /bin/bash
#全局变量和局部变量的使用

num=123

fun1()
{
   num=321     #修改了全局变量的值
   echo $num
}

fun2()
{
   local num=456  #声明为局部变量
   echo ${num}
}

echo $num
fun1          #调用函数,不需要括号
echo $num
fun2
echo $num
