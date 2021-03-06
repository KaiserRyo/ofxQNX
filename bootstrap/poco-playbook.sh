#!/bin/bash

# Get NDK_ROOT
source paths.make

# Bootstrap folder
BB_BOOTSTRAP_ROOT=$(pwd)
BB_BOOTSTRAP_ROOT=${BB_BOOTSTRAP_ROOT%/*}

# POCO
BB_POCO_URL=http://downloads.sourceforge.net/project/poco/sources/poco-1.4.3/poco-1.4.3p1.tar.gz
BB_POCO_FILE=poco-1.4.3p1.tar.gz
BB_POCO_FOLDER=poco-1.4.3p1

# Create download folder
mkdir -p "$BB_BOOTSTRAP_ROOT/bootstrap/downloads"
cd "$BB_BOOTSTRAP_ROOT/bootstrap/downloads"

# Build PlayBook platform
if [ -d "$BBNDK_PLAYBOOK_ROOT" ]; then

	# Patch syslog
	echo "Installing dummy syslog.h, target dir: $BBNDK_PLAYBOOK_ROOT/target/qnx6/usr/include/"
	cp ../poco/syslog.h $BBNDK_PLAYBOOK_ROOT/target/qnx6/usr/include/

	if [ ! -f $BBNDK_PLAYBOOK_ROOT/target/qnx6/usr/include/syslog.h ]; then
		echo "Trying again with sudo"
		sudo cp ../poco/syslog.h $BBNDK_PLAYBOOK_ROOT/target/qnx6/usr/include/

		if [ ! -f $BBNDK_PLAYBOOK_ROOT/target/qnx6/usr/include/syslog.h ]; then		
			echo "Please copy syslog.h manually to: $BBNDK_PLAYBOOK_ROOT/target/qnx6/usr/include/ "
			exit 1;
		fi
	fi

	# Download and unpack Poco
	if [ ! -f $BB_POCO_FILE ]; then
    		wget $BB_POCO_URL
	fi
	rm -Rf $BB_POCO_FOLDER
	tar -zxf $BB_POCO_FILE

	# Get build environment
	source "$BBNDK_PLAYBOOK_ROOT/bbndk-env.sh"

	# Build x86 target
	cd "$BB_BOOTSTRAP_ROOT/bootstrap/downloads/$BB_POCO_FOLDER"
	cp ../../poco/QNX-playbook-sim ./build/config
	./configure --config=QNX-playbook-sim --omit=NetSSL_OpenSSL,Crypto,Data/ODBC,Data/MySQL --no-tests --no-samples --static "--prefix=$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86"
	${QNX_HOST}/usr/bin/make -s -j4
        ${QNX_HOST}/usr/bin/make install

	cd "$BB_BOOTSTRAP_ROOT/libs"
	mv -f "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86/include" "$BB_BOOTSTRAP_ROOT/libs/poco"
        cd "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86/lib"
        mv * "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86"
        rm -Rf "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86/lib"
        rm -Rf "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86/bin"
        rm -Rf "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/X86/include"

        # Build ARM target
	cd "$BB_BOOTSTRAP_ROOT/bootstrap/downloads/$BB_POCO_FOLDER"
	${QNX_HOST}/usr/bin/make clean
	cp ../../poco/QNX-playbook-device ./build/config
	./configure --config=QNX-playbook-device --omit=NetSSL_OpenSSL,Crypto,Data/ODBC,Data/MySQL --no-tests --no-samples --static "--prefix=$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7"
	${QNX_HOST}/usr/bin/make -s -j4
	${QNX_HOST}/usr/bin/make install

	cd "$BB_BOOTSTRAP_ROOT/libs"
	mv -f "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7/include" "$BB_BOOTSTRAP_ROOT/libs/poco"
        cd "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7/lib"
        mv * "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7"
        rm -Rf "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7/lib"
        rm -Rf "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7/bin"
        rm -Rf "$BB_BOOTSTRAP_ROOT/libs/poco/libPlayBook/ARMv7/include"
fi
