#!/bin/bash
#
#Android编译脚本
#

# 设置环境变量
export ANDROID_JAVA_HOME=/usr/lib/jvm/java-6-sun/		# JAVA JDK路径
SOURCE_DIR=$(cd `dirname $0` ; pwd)				# 设置当前目录为源码路径  `dirname $0`：返回当前目录，$0:返回脚本文件名
												# 进入当前目录，使用pwd返回当前路径， 所以SOURCE_DIR为当前目录的路径

RELEASE_DIR=${SOURCE_DIR}/out/release				# 最终镜像文件释放目录
TARGET_DIR=${SOURCE_DIR}/out/target/product/smdkv210		# Android镜像的编译目标目录
KERNEL_DIR=${SOURCE_DIR}/kernel				# Linux源码目录
UBOOT_CONFIG=x210_sd_config					# uboot配置文件
KERNEL_CONFIG=x210_android_inand_defconfig			# Linux内核配置文件
FILESYSTEM_CONFIG=full_smdkv210-eng				# 指定Android编译目标

# 提取CPU内核数
CPU_NUM=$(cat /proc/cpuinfo |grep processor|wc -l)
CPU_NUM=$((CPU_NUM+1))

cd ${SOURCE_DIR};
source ${SOURCE_DIR}/build/envsetup.sh
lunch ${FILESYSTEM_CONFIG}

# 设置环境变量函数，在Android源码目录创建镜像释放目录和映像的目标目录
setup_environment()
{
	cd ${SOURCE_DIR};
	mkdir -p ${RELEASE_DIR} || return 1;	#创建目录成功后就不会执行return 1(或运算:前面的执行成功，后面的就不执行)
	mkdir -p ${TARGET_DIR} || return 1;
}

# 清除整个源码包编译结果
build_clean()
{
	# 清除Android编译结果
	cd ${SOURCE_DIR};
	make clean || return 1;

	# 清除uboot编译结果
	cd ${SOURCE_DIR}/uboot || return 1
	make distclean || return 1;

	# 清除Linux编译结果
	cd ${SOURCE_DIR}/kernel || return 1
	make distclean || return 1

	return 0
}

# 编译uboot源码
build_uboot()
{
	cd ${SOURCE_DIR}/uboot || return 1
	make distclean || return 1;
	make ${UBOOT_CONFIG} || return 1;			# 使用默认的配置文件${UBOOT_CONFIG}编译
	make -j${CPU_NUM}

  if [ -f u-boot.bin ]; then					#判断 u-boot.bin是不是常规文件
		cp u-boot.bin ${RELEASE_DIR}/u-boot.bin		# 将编译生成的u-boot.bin文件拷贝到${RELEASE_DIR}目录
		echo "^_^ u-boot.bin is finished successful!"
	else
		echo "make error,cann't compile u-boot.bin!"
		exit
	fi

	return 0
}

# 编译Linux内核源码
build_kernel()
{
	cd ${SOURCE_DIR}/kernel || return 1
	make ${KERNEL_CONFIG} || return 1			# 使用默认的配置文件${KERNEL_CONFIG}编译
	make -j${threads} || return 1
	dd if=${SOURCE_DIR}/kernel/arch/arm/boot/zImage of=${RELEASE_DIR}/zImage bs=2048 count=8192 conv=sync;	# 将编译生成的zImage文件拷贝到${RELEASE_DIR}目录，dd命令用于复制文件并对原文件的内容进行转换和格式化处理

	echo "" >&2
	echo "^_^ android kernel for inand path: ${RELEASE_DIR}/zImage" >&2

	return 0
}

# 编译Android源码，生成文件系统镜像
build_rootfs()
{
	cd ${SOURCE_DIR} || return 1

	rm ${TARGET_DIR}/ramdisk.img > /dev/null #把/dev/null看作"黑洞". 它非常等价于一个只写文件. 所有写入它的内容都会永远丢失，所以rm的输出都会消失
	rm ${TARGET_DIR}/uramdisk.img > /dev/null 
	rm ${TARGET_DIR}/system.img >/dev/null  
	rm ${TARGET_DIR}/obj/PACKAGING/systemimage_intermediates/system.img > /dev/null 
	rm ${TARGET_DIR}/root -fr > /dev/null 
	rm ${TARGET_DIR}/system -fr > /dev/null 
	make -j${threads} || return 1
	cp ${TARGET_DIR}/system.img ${RELEASE_DIR}/system.img

	#echo "" >&2
	#echo "^_^ system path: ${RELEASE_DIR}/system.tar" >&2
	${SOURCE_DIR}/uboot/tools/mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "uramdisk" -d ${TARGET_DIR}/ramdisk.img ${TARGET_DIR}/uramdisk.img
	rm ${TARGET_DIR}/ramdisk.img > /dev/null
	mv ${TARGET_DIR}/uramdisk.img ${RELEASE_DIR}/ramdisk.img
	return 0
}

# 设置默认编译选项
threads=4;
uboot=no;
kernel=no;
rootfs=no;
clean=no;

# 直接执行mk脚本编译，将默认编译uboot，kernel，Android
if [ -z $1 ]; then  #判断参数1长度是否为0
	uboot=yes
    kernel=yes
	rootfs=yes
fi

while [ "$1" ]; do
    case "$1" in
	-j=*)							# 编译选项后加-j=*参数（*为数字），将设置编译线程数
		x=$1
		threads=${x#-j=}
		;;
	-c|--clean)						# 编译选项后加-c参数，将清除整个源码包编译结果
		clean=yes
		;;
	-u|--uboot)						# 编译选项后加-u参数，将编译uboot源码
		uboot=yes
	    	;;
	-k|--kernel)						# 编译选项后加-k参数，将编译Linux内核源码
	    	kernel=yes
	    	;;
	-r|--rootfs)						# 编译选项后加-r参数，将编译Android源码，生成文件系统镜像
	    	rootfs=yes
	    	;;
	-a|--all)						# 编译选项后加-a参数，将编译所有源码：uboot，kernel，Android
	    	uboot=yes
	    	kernel=yes
	    	rootfs=yes
	    	;;
	-h|--help)						# 编译选项后加-h参数，将显示帮助信息
	    	cat >&2 <<EOF
Usage: build.sh [OPTION]
Build script for compile the source of telechips project.

  	-j=n                 	using n threads when building source project (example: -j=16)
  	-c, --clean   		clean all building file
  	-u, --uboot   		build uboot from source file
  	-k, --kernel		build kernel and using default config file
  	-r, --rootfs         	build Root filesystem from source file
  	-a, --all            	build all, include anything
  	-h, --help           	display this help and exit
EOF
	    	exit 0
	    	;;
	*)
		echo "mk: Unrecognised option $1" >&2
		exit 1
		;;
    	esac
    	shift
done

setup_environment || exit 1

if [ "${uboot}" = yes ]; then
	build_uboot || exit 1
fi

if [ "${kernel}" = yes ]; then
	build_kernel || exit 1
fi

if [ "${rootfs}" = yes ]; then
	build_rootfs || exit 1
fi

if [ "${clean}" = yes ]; then
	build_clean || exit 1
fi

exit 0

