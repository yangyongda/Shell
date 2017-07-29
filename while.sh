#! /bin/bash

num=20

while [ $num != 0 ]
do 
   echo "num is $num"
   num=$[$num-1]   	#算数运算
done

val=10
while [ $val -gt 0 ] #左大于右
do
   echo $val
   val=$[ $val - 1 ]
done
