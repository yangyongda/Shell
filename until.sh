#! /bin/bash

num=20
until [ $num == 0 ]  #直到条件为真是停止
 do
  echo "num is $num"
  num=$[$num-1]
 done
