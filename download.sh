#!/bin/bash

YOCTO_DIR_NAME=RPi-Yocto
CUR_DIR=$(pwd)
echo "Setting up RPi-Yocto in [$CUR_DIR]"

mkdir -p $YOCTO_DIR_NAME
cd $YOCTO_DIR_NAME

echo -ne "Cloning ==>\e[34m poky\e[0m              Branch:\e[33m[rocko]\e[0m..."
git clone -b rocko git://git.yoctoproject.org/poky.git &> /dev/null
if test $? -ne 0; then
    echo -e "\e[31mFailed...\e[0m"
    exit 1
else
    echo -e "\e[32mSuccess...\e[0m"
fi

cd poky
echo -ne "Cloning ==>\e[34m meta-openembedded\e[0m Branch:\e[33m[rocko]\e[0m..."
git clone -b rocko git://git.openembedded.org/meta-openembedded &> /dev/null
if test $? -ne 0; then
    echo -e "\e[31mFailed...\e[0m"
    exit 2
else
    echo -e "\e[32mSuccess...\e[0m"
fi

echo -ne "Cloning ==>\e[34m meta-qt5\e[0m          Branch:\e[33m[rocko]\e[0m..."
git clone -b rocko https://github.com/meta-qt5/meta-qt5 &> /dev/null
if test $? -ne 0; then
    echo -e "\e[31mFailed...\e[0m"
    exit 3
else
    echo -e "\e[32mSuccess...\e[0m"
fi

echo -ne "Cloning ==>\e[34m meta-security5\e[0m    Branch:\e[33m[rocko]\e[0m..."
git clone -b rocko git://git.yoctoproject.org/meta-security &> /dev/null
if test $? -ne 0; then
    echo -e "\e[31mFailed...\e[0m"
    exit 3
else
    echo -e "\e[32mSuccess...\e[0m"
fi


echo -ne "Cloning ==>\e[34m meta-raspberrypi\e[0m  Branch:\e[33m[rocko]\e[0m..."
git clone -b rocko git://git.yoctoproject.org/meta-raspberrypi &> /dev/null
if test $? -ne 0; then
    echo -e "\e[31mFailed...\e[0m"
    exit 4
else
    echo -e "\e[32mSuccess...\e[0m"
fi

echo -ne "Cloning ==>\e[34m meta-rpi\e[0m          Branch:\e[33m[rocko]\e[0m..."
git clone https://github.com/jumpnow/meta-rpi.git &> /dev/null
if test $? -ne 0; then
    echo -e "\e[31mFailed...\e[0m"
    exit 5
else
    echo -e "\e[32mSuccess...\e[0m"
fi

cd $CUR_DIR
echo 'Creating build file...'
echo '#!/bin/bash'                                                              >  build.sh
chmod 755 build.sh
echo ''                                                                         >> build.sh
echo '# Current Directory'                                                      >> build.sh
echo "CUR_DIR=\"$CUR_DIR\""                                                     >> build.sh
echo "YOCTO_DIR_NAME=\"$YOCTO_DIR_NAME\""                                       >> build.sh
echo ''                                                                         >> build.sh
echo 'echo Building RPi-Yocto...'                                               >> build.sh
echo 'cd $YOCTO_DIR_NAME'                                                       >> build.sh
echo 'if test -d build; then'                                                   >> build.sh
echo '    echo "Old build directory found...Deleting..."'                       >> build.sh
echo '    rm -rf build'                                                         >> build.sh
echo 'fi'                                                                       >> build.sh
echo ''                                                                         >> build.sh
echo 'echo "Creating Yocto build configuration..."'                             >> build.sh
echo 'mkdir -p build'                                                           >> build.sh
echo 'source poky/oe-init-build-env build &> /dev/null'                         >> build.sh
echo 'if test $? -ne 0; then'                                                   >> build.sh
echo '    echo "oe-init-build-env failed..."'                                   >> build.sh
echo '    exit 1'                                                               >> build.sh
echo 'fi'                                                                       >> build.sh
echo ''                                                                         >> build.sh

# Creating bblayers.conf
echo 'echo "+------[ Creating bblayers.conf ]------+"'                                                      >> build.sh
echo 'BBLAYER_FILE=$CUR_DIR/$YOCTO_DIR_NAME/build/conf/bblayers.conf'                                       >> build.sh
echo 'echo "POKY_BBLAYERS_CONF_VERSION = \"2\""  > $BBLAYER_FILE'                                           >> build.sh
echo 'echo "" >> $BBLAYER_FILE'                                                                             >> build.sh
echo 'echo "BBPATH = \"\${TOPDIR}\""  >> $BBLAYER_FILE'                                                     >> build.sh
echo 'echo "BBFILES ?= \"\""  >> $BBLAYER_FILE'                                                             >> build.sh
echo 'echo ""  >> $BBLAYER_FILE'                                                                            >> build.sh
echo 'echo "BBLAYERS ?= \" \ "  >> $BBLAYER_FILE'                                                           >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta \\"  >> $BBLAYER_FILE'                                   >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-poky \\"  >> $BBLAYER_FILE'                              >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-openembedded/meta-oe \\"  >> $BBLAYER_FILE'              >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-openembedded/meta-multimedia \\"  >> $BBLAYER_FILE'      >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-openembedded/meta-networking \\"  >> $BBLAYER_FILE'      >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-openembedded/meta-perl \\"  >> $BBLAYER_FILE'            >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-openembedded/meta-python \\"  >> $BBLAYER_FILE'          >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-qt5 \\"  >> $BBLAYER_FILE'                               >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-raspberrypi \\"  >> $BBLAYER_FILE'                       >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-security \\"  >> $BBLAYER_FILE'                          >> build.sh
echo 'echo "    $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-rpi \\"  >> $BBLAYER_FILE'                               >> build.sh
echo 'echo "\""  >> $BBLAYER_FILE'                                                                          >> build.sh

# Creating local.conf
echo 'echo "+------[ Creating local.conf ]------+"'                                                         >> build.sh
echo 'LOCAL_FILE=$CUR_DIR/$YOCTO_DIR_NAME/build/conf/local.conf'                                            >> build.sh
echo 'cp $CUR_DIR/$YOCTO_DIR_NAME/poky/meta-rpi/conf/local.conf.sample $LOCAL_FILE'                         >> build.sh
#echo 'echo "MACHINE = \"raspberrypi3\" >> $LOCAL_FILE'                                                      >> build.sh
echo 'mkdir -p $CUR_DIR/$YOCTO_DIR_NAME/build/tmp-dir'                                                      >> build.sh
echo 'echo "TMPDIR = \"$CUR_DIR/$YOCTO_DIR_NAME/build/tmp-dir\"" >> $LOCAL_FILE'                             >> build.sh
echo 'mkdir -p $CUR_DIR/$YOCTO_DIR_NAME/build/dl'                                                           >> build.sh
echo 'echo "DL_DIR = \"$CUR_DIR/$YOCTO_DIR_NAME/build/dl\"" >> $LOCAL_FILE'                                  >> build.sh
echo 'mkdir -p $CUR_DIR/$YOCTO_DIR_NAME/build/sstate'                                                       >> build.sh
echo 'echo "SSTATE_DIR = \"$CUR_DIR/$YOCTO_DIR_NAME/build/sstate\"" >> $LOCAL_FILE'                          >> build.sh

# Re run the configuration
echo 'cd "$CUR_DIR/$YOCTO_DIR_NAME"'                            >> build.sh
echo 'source poky/oe-init-build-env build'                      >> build.sh
echo 'bitbake console-image'                                    >> build.sh
