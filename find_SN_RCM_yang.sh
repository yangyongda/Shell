#!/bin/bash

a=0
count=0
echo -n "please input file name: "
read filename
cat "$filename" | while read line        #���ζ�ȡ�ļ���ÿһ��
do
  SN=`echo "$line" | cut -d \, -f 1`		  #���ݶ���(,)�ָ��ַ�������ȡ�õ�һ���ַ���(��SN)
  #len=${#SN}
  #len=$[$len-2]
  #SN=${SN:1:$len}
  #echo "$SN"
  result=`grep -c $SN "$filename"`       #���Ҹ��ļ����Ƿ����ظ���SN
  if [ $result -ge 2 ]									 #������صĽ������2˵�����ظ���
  then
     ((count++))
     if [ $count == 1 ]
     then
        array[$count]=$SN
        #echo ${array[$count]}
        echo "SN:$SN is repeat, repeat number is $result!"     #����ظ���SN
        linecontent=`grep $SN "$filename"`										 #�����ظ�������
        echo "$linecontent" | while read line
				do
  	   		 RCM=`echo "$line" | cut -d \, -f 8`								 #��ȡ�ظ���SN��Ӧ��RCMֵ
           echo "	RCM:$RCM"
        done
     else																											 #��ֹ��һ�λ�ȡ����ͬSN�����
        for (( a=1; a < $count; a++ ))
				do
          if [ "${array[$a]}" = $SN ]
          then
            break
          fi  
				done
        if [ $count == $a ]																	 #���count��a���˵�������Ѿ��ҹ����ظ�SN
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



