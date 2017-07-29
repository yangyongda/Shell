#! /bin/bash


#break
num=20

while [ $num != 0 ]
do 
   echo "num is $num"
   num=$[$num-1]   	#算数运算
   if [ $num = 4 ]
   then
     break;
   fi
done

#continue
num1=20

while [ $num1 != 0 ]
do 
   if [ $num1 = 4 ]
   then
     num1=$[$num1-1]   	#算数运算
     continue
   fi
   echo "num is $num1"
   num1=$[$num1-1]   	#算数运算
done

