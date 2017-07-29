#! /bin/bash


#如果命令执行成功返回0（执行成功返回0,执行失败返回非0,但是并不代表0就是true）
if date  
then 
  echo "it worked"
fi

#执行失败返回一个非0退出状态码
if adbdf
then 
  echo "wo don't work"
fi
echo "wo are outside of if statement"


