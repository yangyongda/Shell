#! /bin/bash

val1=12
val2=11

# -gt:左边是否大于右边
if [ $val1 -gt 5 ]
then 
  echo "The test val $val1 greater than 5"
fi

# -lt:左边是否小于右边
if [ $val2 -lt 5 ]
then 
  echo "The test val $val2 lower than 5"
fi
# -eq:左右的值是否相等,相等返回true
if [ $val1 -eq $val2 ]
then 
  echo "the value are equal"
else
  echo "the value are different"
fi


# -ne:左右的值不相等返回true
if [ $val1 -ne $val2 ]
then 
   echo "the value are different"
else
   echo "the value are equal"
fi

# -ge:左值大于等于右值时返回true
if [ $val1 -ge $val2 ]
then 
   echo "The test val $val1 greater than or equal $val2"
else
   echo "The test val $val1 lower than $val2"
fi

# -le:左值小于等于右值时返回true
if [ $val1 -le $val2 ]
then 
   echo "The test val $val1 lower than or equal $val2"
else
   echo "The test val $val1 greater than $val2"
fi
