#!/bin/sh

cd /tmp     #直接./echo.sh目录不会改变; 使用source echo.sh会改变目录
echo "hello world!"
echo	    #输出换行符
echo -n "hello everyone!"  # -n:不输出行尾的换行符
