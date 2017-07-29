#! /bin/bash

# -d:检查指定文件名是否存在并且是目录
if [ -d $HOME ]
then
   echo "your HOME directory exists"
   cd $HOME
   ls -a
else
   echo "there is a problem with your HOME directory"
fi


# -e:检查对象是否存在
if [ -e $HOME ]  #判断是否有HOME目录
then
   echo "OK on the directory! now check the file"
   if [ -e $HOME/testing ]  #判断HOME下是否有testing文件
   then
      echo "appending data to existing file"
      date >> $HOME/testing
   else
      echo "creating new file"
      date > $HOME/testing
   fi
else
   echo "you do not have a HOME directory"
fi


# -f:检查对象是否是个文件
if [ -e $HOME ]
then
   echo "the object exist. is it a object?"
   if [ -f $HOME ]
   then
     echo "YES, it is a file"
   else
     echo "NO, it isn't a file"
     if [ -f $HOME/.bash_history ]
     then 
       echo "this is a file"
     fi
   fi
else
   echo "the object does not exist"
fi

# -r:检查是否可读
pwfile=/etc/shadow
if [ -f $pwfile ]
then
  if [ -r $pwfile ] 
  then 
    tail $pwfile  # tail: 查看文件内容
  else
    echo "you unable to read this file"
  fi
else
  echo "the file $pwfile doesn't exist"
fi


# -s:检查文件是否为空，不为空返回true
file=t15test
touch $file   #创建文件
if [ -s $file ]

then
  echo "the file has data"
else
  echo "the file is empty"
fi
date > $file
if [ -s $file ]
then
  echo "the file has data"
else
  echo "the file is empty"
fi


# -w:判断用户是否对文件有可写权限
logfile=$HOME/test
touch $logfile
chmod u-w $logfile       #当前用户去除写权限
now=`date +%Y%m%d-%H%M`  #对当前时间进行格式化

if [ -w $logfile ]
then
   echo "the program run at :$now" > $logfile
   echo "the first attempt is successed"
else
   echo "the first attempt is failed"
fi

chmod u+w $logfile      #当前用户加上写权限
if [ -w $logfile ]
then
   echo "the program run at :$now" > $logfile
   echo "the second attempt is successed"
else
   echo "the second attempt is failed"
fi


# -x:判断用户是否对文件有可执行权限
script="/work/shell/operator/str_compare.sh"
chmod u-x $script     #当前用户去除写权限

if [ -x $script ]
then
   echo "the first attempt is successed"
else
   echo "the first attempt is failed"
fi

chmod u+x $script      #当前用户加上写权限
if [ -x $script ]
then
   echo "the second attempt is successed"
   source $script
else
   echo "the second attempt is failed"
fi
