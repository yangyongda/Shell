#! /bin/bash


# (()) :双括号可以支持高级数学表达式，可以在if语句中使用，也可以在脚本中的普通命令里使用来赋值

val1=10
if (( $val1 ** 2 > 90 )) # **:幂运算，(()) 中可以直接使用大于号
then
   (( val2=$val1 ** 2 ))
   echo "the square of $val1 is $val2"
fi

#后增
(( val1 ++ )) 
echo "val1 = $val1"

#后减
(( val1 -- )) 
echo "val1 = $val1"

#前增
(( ++ val1 )) 
echo "val1 = $val1"

#前减
(( -- val1 )) 
echo "val1 = $val1"
