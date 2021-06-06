#!/bin/bash

FILE="./.mf"
TYPE=0
PHONY=0

if [ -f $FILE ]; then
	rm -rf $FILE
fi
touch $FILE

echo -e "\n\n" >> $FILE


# this function is for write basic members in Makefile
# INPUT is user's input
# if the user didn't enter a input, 2nd parameter will be replaced as a defalut value\
# TLEN is '\t's wtiting time
function ft_member_querry()
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
		if [ $3 \> 0 ]; then
			echo -e "=\t${INPUT}.a" >> $FILE
		else
			echo -e "=\t${INPUT}" >> $FILE
		fi
	fi
}

# this function is for write basic folders in Makefile
# TLEN is '\t's wtiting time
# function folder_querry()
function ft_folder_querry()
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

function ft_type_querry()
{
	local INPUT
	echo -en "\033[32;1m?\033[0m \033[2m would like to make directories : src, obj, includes ? (y/n)\033[0m : "
	read INPUT
	if [ "$INPUT" == "y" ] ; then
		ft_folder_querry includes HDR HEADERS
		ft_folder_querry src SRC SOURCES
		ft_folder_querry obj OBJ OBJECTS
		TYPE=1
	else
		echo -e "SOURCES\t\t=\t\n" >> $FILE
		echo -e "HEADERS\t\t=\t-I." >> $FILE
		echo -e "OBJECTS\t\t=\t\$(SOURCES:.c=.o)\n" >> $FILE
		TYPE=0
	fi
}

function ft_ar_querry()
{
	echo -en "\033[32;1m?\033[0m \033[2m is this project for making a library ? (y/n)\033[0m : "
	read LIB
	if [ "$LIB" == "y" ]; then
		LIB=1
	else
		LIB=0
	fi
}

function ft_phony_querry()
{
	echo -en "\033[32;1m?\033[0m \033[2m Do you want .PHONY option ? (y/n)\033[0m : "
	read PHONY
	if [ "$PHONY" == "y" ]; then
		echo -en ".PHONY\t:\t\tall clean fclean re\n" >> $FILE
	fi
}



ft_ar_querry
ft_member_querry NAME "42" LIB
echo -en "\n" >> $FILE
ft_member_querry CC "gcc" 0
ft_member_querry CCFLAG "-Wall -Wextra -Werror" 0
echo -en "\n" >> $FILE
ft_type_querry


if [ $TYPE == 0 ]; then
	echo -en "all\t\t:\t\$(NAME)\n\n" >> $FILE
	echo -en "\$(NAME)\t:\t\$(OBJS)\n" >> $FILE
	if [ $LIB == 1 ]; then
		echo -en "\t\tar rcs \$(NAME) \$(OBJECTS)\n\n" >> $FILE
	else
		echo -en "\t\t\$(CC) \$(CCFLAG) \$(HEADERS)\n\n" >> $FILE
	fi
	echo -en "clean\t:\n\t\trm -rf \$(OBJECTS)\n\n" >> $FILE
	echo -en "fclean\t:\tclean\n\t\trm -rf \$(NAME)\n\n" >> $FILE
	echo -en "re\t\t:\tfclean \$(NAME)\n\n\n" >> $FILE
fi




ft_phony_querry

mv .mf Makefile