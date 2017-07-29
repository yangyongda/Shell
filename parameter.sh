#! /bin/bash

testfunc()
{
   echo "$# parameters"  # $#表示传入的参数的个数
   echo "$@"             # $@表示所有参数的内容
}

testfunc a b c      #调用并传入三个参数
testfunc a "b c"    #传入两个参数
