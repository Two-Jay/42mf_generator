#!/bin/bash

FILE="./.mf"
_NAME="your project"
_CC="gcc"
_CCFLAG="-Wall -Wextra -Werror"

if [ -f $FILE ]; then
	rm -rf $FILE
fi
touch $FILE

echo -e "\n\n" >> $FILE


# this function is for write basic members in Makefile
# INPUT is user's input
# if the user didn't enter a input, 2nd parameter will be replaced as a defalut value\
# TLEN is '\t's wtiting time
function member_querry()
{
	local INPUT
	local TLEN
	if [ ${#1} \< 4 ]; then
		TLEN=3
	else
		TLEN=2
	fi
	read -p "(your project's $1) : " INPUT
	if [ "$INPUT" != "y" ] ; then
		echo -en "$1" >> $FILE
		printf "%${TLEN}s" | tr " " "\t" >> $FILE
		echo -e "=\t$2" >> $FILE
	else
		echo -en "$1" >> $FILE
		printf "%${TLEN}s" | tr " " "\t" >> $FILE
		echo -e "=\t${INPUT}" >> $FILE
	fi
}

# this function is for write basic folder members in Makefile
# INPUT is user's y/n input
# if the INPUT was y, a file named as $1 will be created and
# it's path will be written as a member in Makefile
# if the user didn't enter a input, this function will be ignored
# TLEN is '\t's wtiting time
function folder_querry()
{
	local INPUT
	local TLEN
	if [ ${#2} \< 4 ]; then
		TLEN=2
	else
		TLEN=1
	fi
	read -p "(would like to make $1 folder ? (y/n) ) : " INPUT
	if [ "$INPUT" == "y" ] ; then
		mkdir $1
		echo -en "$2_DIR" >> $FILE
		printf "%${TLEN}s" | tr " " "\t" >> $FILE
		echo -e "=\t./$1" >> $FILE
	else
		echo -en "$2_DIR" >> $FILE
		printf "%${TLEN}s" | tr " " "\t" >> $FILE
		echo -e "=\t" >> $FILE
	fi
}

member_querry NAME "your project"
echo -en "\n" >> $FILE
member_querry CC "gcc"
member_querry CCFLAG "-Wall -Wextra -Werror"

folder_querry includes INC
folder_querry src SRC
folder_querry obj OBJ


# read -p "would you like to make folder 'lib'? (y/n) : " lib
# if [ -z $lib -o "$lib" != "y" ] ; then
# 	lib="n"
# elif [ $lib -eq "y" ] ; then
# 	echo -e "lib\t:\t"$lib >> FILE
# fi

# read -p "would you like to make folder 'src'? (y/n)" src
# if [ -z $src -o $src -ne "y" ] ; then
#     src="n"
# fi

# read -p "would you like to make folder 'include'? (y/n)" inc
# if [ -z $src -o $src -ne "y" ] ; then
#     src="n"
# fi

# read -p "would you like to make folder 'obj'? (y/n)"
