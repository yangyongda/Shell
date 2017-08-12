#!/bin/bash
#
#Android����ű�
#

# ���û�������
export ANDROID_JAVA_HOME=/usr/lib/jvm/java-6-sun/		# JAVA JDK·��
SOURCE_DIR=$(cd `dirname $0` ; pwd)				# ���õ�ǰĿ¼ΪԴ��·��  `dirname $0`�����ص�ǰĿ¼��$0:���ؽű��ļ���
												# ���뵱ǰĿ¼��ʹ��pwd���ص�ǰ·���� ����SOURCE_DIRΪ��ǰĿ¼��·��

RELEASE_DIR=${SOURCE_DIR}/out/release				# ���վ����ļ��ͷ�Ŀ¼
TARGET_DIR=${SOURCE_DIR}/out/target/product/smdkv210		# Android����ı���Ŀ��Ŀ¼
KERNEL_DIR=${SOURCE_DIR}/kernel				# LinuxԴ��Ŀ¼
UBOOT_CONFIG=x210_sd_config					# uboot�����ļ�
KERNEL_CONFIG=x210_android_inand_defconfig			# Linux�ں������ļ�
FILESYSTEM_CONFIG=full_smdkv210-eng				# ָ��Android����Ŀ��

# ��ȡCPU�ں���
CPU_NUM=$(cat /proc/cpuinfo |grep processor|wc -l)
CPU_NUM=$((CPU_NUM+1))

cd ${SOURCE_DIR};
source ${SOURCE_DIR}/build/envsetup.sh
lunch ${FILESYSTEM_CONFIG}

# ���û���������������AndroidԴ��Ŀ¼���������ͷ�Ŀ¼��ӳ���Ŀ��Ŀ¼
setup_environment()
{
	cd ${SOURCE_DIR};
	mkdir -p ${RELEASE_DIR} || return 1;	#����Ŀ¼�ɹ���Ͳ���ִ��return 1(������:ǰ���ִ�гɹ�������ľͲ�ִ��)
	mkdir -p ${TARGET_DIR} || return 1;
}

# �������Դ���������
build_clean()
{
	# ���Android������
	cd ${SOURCE_DIR};
	make clean || return 1;

	# ���uboot������
	cd ${SOURCE_DIR}/uboot || return 1
	make distclean || return 1;

	# ���Linux������
	cd ${SOURCE_DIR}/kernel || return 1
	make distclean || return 1

	return 0
}

# ����ubootԴ��
build_uboot()
{
	cd ${SOURCE_DIR}/uboot || return 1
	make distclean || return 1;
	make ${UBOOT_CONFIG} || return 1;			# ʹ��Ĭ�ϵ������ļ�${UBOOT_CONFIG}����
	make -j${CPU_NUM}

  if [ -f u-boot.bin ]; then					#�ж� u-boot.bin�ǲ��ǳ����ļ�
		cp u-boot.bin ${RELEASE_DIR}/u-boot.bin		# ���������ɵ�u-boot.bin�ļ�������${RELEASE_DIR}Ŀ¼
		echo "^_^ u-boot.bin is finished successful!"
	else
		echo "make error,cann't compile u-boot.bin!"
		exit
	fi

	return 0
}

# ����Linux�ں�Դ��
build_kernel()
{
	cd ${SOURCE_DIR}/kernel || return 1
	make ${KERNEL_CONFIG} || return 1			# ʹ��Ĭ�ϵ������ļ�${KERNEL_CONFIG}����
	make -j${threads} || return 1
	dd if=${SOURCE_DIR}/kernel/arch/arm/boot/zImage of=${RELEASE_DIR}/zImage bs=2048 count=8192 conv=sync;	# ���������ɵ�zImage�ļ�������${RELEASE_DIR}Ŀ¼��dd�������ڸ����ļ�����ԭ�ļ������ݽ���ת���͸�ʽ������

	echo "" >&2
	echo "^_^ android kernel for inand path: ${RELEASE_DIR}/zImage" >&2

	return 0
}

# ����AndroidԴ�룬�����ļ�ϵͳ����
build_rootfs()
{
	cd ${SOURCE_DIR} || return 1

	rm ${TARGET_DIR}/ramdisk.img > /dev/null #��/dev/null����"�ڶ�". ���ǳ��ȼ���һ��ֻд�ļ�. ����д���������ݶ�����Զ��ʧ������rm�����������ʧ
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

# ����Ĭ�ϱ���ѡ��
threads=4;
uboot=no;
kernel=no;
rootfs=no;
clean=no;

# ֱ��ִ��mk�ű����룬��Ĭ�ϱ���uboot��kernel��Android
if [ -z $1 ]; then  #�жϲ���1�����Ƿ�Ϊ0
	uboot=yes
    kernel=yes
	rootfs=yes
fi

while [ "$1" ]; do
    case "$1" in
	-j=*)							# ����ѡ����-j=*������*Ϊ���֣��������ñ����߳���
		x=$1
		threads=${x#-j=}
		;;
	-c|--clean)						# ����ѡ����-c���������������Դ���������
		clean=yes
		;;
	-u|--uboot)						# ����ѡ����-u������������ubootԴ��
		uboot=yes
	    	;;
	-k|--kernel)						# ����ѡ����-k������������Linux�ں�Դ��
	    	kernel=yes
	    	;;
	-r|--rootfs)						# ����ѡ����-r������������AndroidԴ�룬�����ļ�ϵͳ����
	    	rootfs=yes
	    	;;
	-a|--all)						# ����ѡ����-a����������������Դ�룺uboot��kernel��Android
	    	uboot=yes
	    	kernel=yes
	    	rootfs=yes
	    	;;
	-h|--help)						# ����ѡ����-h����������ʾ������Ϣ
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

