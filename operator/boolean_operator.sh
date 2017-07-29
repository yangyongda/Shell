#! /bin/bash


# && :两个条件都成立返回true
if [ -d $HOME ] && [ -w $HOME/testing ]
then
   echo "the file exist and you can write"
else
   echo "you can not write"
fi


# || :两个条件有一个成立就返回true
if [ -d $HOME ] || [ -w $HOME/testing ]
then
   echo "the dirctory exist or you can write file"
else
   echo "the dirctory not exist and you can not write file"
fi
