#! /bin/bash

# 执行./parameter2.sh a b c

echo "$# parameters"  # $#表示传入的参数的个数
echo "$@"             # $@表示所有参数的内容
echo $1   	      #获取第一个参数
echo $2		      #获取第二个参数

