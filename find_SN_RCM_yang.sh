#!/bin/bash

a=0
count=0
echo -n "please input file name: "
read filename
cat "$filename" | while read line        #依次读取文件的每一行
do
  SN=`echo "$line" | cut -d \, -f 1`		  #根据逗号(,)分割字符串，并取得第一个字符串(即SN)
  #len=${#SN}
  #len=$[$len-2]
  #SN=${SN:1:$len}
  #echo "$SN"
  result=`grep -c $SN "$filename"`       #查找该文件中是否有重复的SN
  if [ $result -ge 2 ]									 #如果返回的结果大于2说明有重复的
  then
     ((count++))
     if [ $count == 1 ]
     then
        array[$count]=$SN
        #echo ${array[$count]}
        echo "SN:$SN is repeat, repeat number is $result!"     #输出重复的SN
        linecontent=`grep $SN "$filename"`										 #返回重复的内容
        echo "$linecontent" | while read line
				do
  	   		 RCM=`echo "$line" | cut -d \, -f 8`								 #获取重复的SN对应的RCM值
           echo "	RCM:$RCM"
        done
     else																											 #防止下一次获取到相同SN又输出
        for (( a=1; a < $count; a++ ))
				do
          if [ "${array[$a]}" = $SN ]
          then
            break
          fi  
				done
        if [ $count == $a ]																	 #如果count和a相等说明不是已经找过的重复SN
        then
           array[$count]=$SN
           echo "SN:$SN is repeat, repeat number is $result!"
           linecontent=`grep $SN "$filename"`
           echo "$linecontent" | while read line
	   			 do
  	     		 RCM=`echo "$line" | cut -d \, -f 8`
             echo "	RCM:$RCM"
           done
        fi
     fi
  fi
done


cat "$filename" | while read line
do
  RCM=`echo "$line" | cut -d \, -f 8`
  result=`grep -c $RCM "$filename"`
  if [ $result -ge 2 ]
  then
     ((count++))
     if [ $count == 1 ]
     then
        array[$count]=$RCM
        echo "RCM:$RCM is repeat, repeat number is $result!"
        linecontent=`grep $RCM "$filename"`
        echo "$linecontent" | while read line
	do
  	   SN=`echo "$line" | cut -d \, -f 1`
           echo "	SN:$SN"
        done
        #echo "$linecontent"
     else
        for (( a=1; a < $count; a++ ))
	do
          if [ "${array[$a]}" = $RCM ]
          then
            break
          fi  
	done
        if [ $count == $a ]
        then
           array[$count]=$RCM
           echo "RCM:$RCM is repeat, repeat number is $result!"
           linecontent=`grep $RCM "$filename"`
           echo "$linecontent" | while read line
	   do
  	     SN=`echo "$line" | cut -d \, -f 1`
             echo "	SN:$SN"
           done
        fi
     fi
  fi
done



