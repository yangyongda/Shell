#! /bin/bash

# shift:变量数减1, 位置3的移动到位置2, 位置2移动到位置1, 位置1被删除 （所有参数的位置移动一位）
count=1
while [ -n "$1" ]
do 
   echo "parameter #$count: $1"
   count=$[ $count + 1 ]  #变量加1
   shift  
done
