#!/bin/bash

FILE="./.mf"
TYPE=0

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
	echo -en "\033[32;1m?\033[0m \033[2m(your project's $1)\033[0m : "
	read INPUT
	if [ -z "$INPUT" ] ; then
		echo -en "$1" >> $FILE
		printf "%${TLEN}s" | tr " " "\t" >> $FILE
		echo -e "=\t$2" >> $FILE
	else
		echo -en "$1" >> $FILE
		printf "%${TLEN}s" | tr " " "\t" >> $FILE
		echo -e "=\t${INPUT}" >> $FILE
	fi
}

# this function is for write basic folders in Makefile
# TLEN is '\t's wtiting time
# function folder_querry()
function folder_querry()
{
	local TLEN
	if [ ${#2} \< 4 ]; then
		TLEN=2
	else
		TLEN=1
	fi
	mkdir $1
	echo -en "$2_FILE" >> $FILE
	printf "%1s" | tr " " "\t" >> $FILE
	echo -e "=\t\n" >> $FILE
	echo -en "$2_DIR" >> $FILE
	printf "%${TLEN}s" | tr " " "\t" >> $FILE
	echo -e "=\t./$1" >> $FILE
	echo -en "$3" >> $FILE
	printf "%${TLEN}s" | tr " " "\t" >> $FILE
	echo -en "=\t" >> $FILE
	echo "\$(addprefix \$($2_DIR), \$($2_FILE))" >> $FILE
	echo -en "\n\n" >> $FILE
}

function type_querry()
{
	local INPUT
	echo -en "\033[32;1m?\033[0m \033[2m would like to make directories : src, obj, includes ? (y/n)\033[0m : "
	read INPUT
	if [ "$INPUT" == "y" ] ; then
		folder_querry includes HDR HEADERS
		folder_querry src SRC SOURCES
		folder_querry obj OBJ OBJECTS
		TYPE=1
	else
		echo -e "SRCS\t\t=\t\n" >> $FILE
		echo -e "HEAD\t\t=\t-I." >> $FILE
		echo -e "OBJS\t\t=\t\$(SRCS:.c=.o)\n" >> $FILE
		TYPE=0
	fi
}

member_querry NAME "42"
echo -en "\n" >> $FILE
member_querry CC "gcc"
member_querry CCFLAG "-Wall -Wextra -Werror"
echo -en "\n" >> $FILE
type_querry

# mv .mf Makefile

# SRCS			=	
# OBJS			= $(SRCS:.c=.o)