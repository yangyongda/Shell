#! /bin/bash

# [] 和test的功能时等价的，都是用来判断表达式的真假
if [ 2 -ge 3 ]  # -ge表示大于等于 ，使用[]时和表达式之间要有空格
then
  echo "2>3"
else
  echo "2<3"
fi

#等价

if test 2 -ge 3  # -ge表示大于等于
then
  echo "2>3"
else
  echo "2<3"
fi
