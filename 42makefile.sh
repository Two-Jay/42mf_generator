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
	echo -en "$2_DIR" >> $FILE
	printf "%${TLEN}s" | tr " " "\t" >> $FILE
	echo -e "=\t./$1" >> $FILE
	echo -en "$2_FILE" >> $FILE
	printf "%1s" | tr " " "\t" >> $FILE
	if [ "$1" == "obj" ]; then
		echo -en "=\t" >> $FILE
		echo "\$(patsubst %.c, %.o, \$(SRC_FILE))" >> $FILE
	else
		echo -e "=\t\n" >> $FILE
	fi
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
	echo -en "\033[32;1m?\033[0m \033[2m is this project for making a library (.a file) ? (y/n)\033[0m : "
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
	if [ $LIB == 1 ]; then
		echo -en "\$(NAME)\t:\t\$(OBJECTS)\n" >> $FILE
		echo -en "\t\tar rcs \$(NAME) \$(OBJECTS)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo "echo \"\033[0;92mlibrary (.a) file was created\"" >> $FILE
		echo -en "\n\n" >> $FILE
	else
		echo -en "\$(NAME)\t:\t\$(OBJECTS)\n" >> $FILE
		echo -en "\t\t\$(CC) \$(CCFLAG) \$(HEADERS) \$(OBJECTS) -o \$(NAME)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo "echo \"\033[0;92mprogram file was created\"" >> $FILE
		echo -en "\n\n" >> $FILE
	fi
	echo -en "clean\t:\n\t\trm -rf \$(OBJECTS)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo "echo \"\033[0;91mobject files was deleted\"" >> $FILE
	echo -en "\n\nfclean\t:\tclean\n\t\trm -rf \$(NAME)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo "echo \"\033[0;91m\$(NAME) was deleted\"" >> $FILE
	echo -en "\n\nre\t\t:\tfclean \$(NAME)\n\n\n" >> $FILE
else
	echo -en "all\t\t:\t\$(NAME)\n\n" >> $FILE
	echo -en "\$(NAME)\t:\t\$(OBJECTS)\n" >> $FILE
	if [ $LIB == 1 ]; then
		echo -en "\$(NAME)\t:\t\$(OBJECTS)\n" >> $FILE
		echo -en "\t\tar rcs \$(NAME) \$(OBJECTS)\n\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo "echo \"\033[0;92mlibrary (.a) file was created\"" >> $FILE
		echo -en "\n\n" >> $FILE
	else
		echo -en "\$(NAME)\t:\t\$(OBJECTS) \$(HEADERS)\n" >> $FILE
		echo -en "\t\t\$(CC) \$(CCFLAG) \$(HEADERS) \$(OBJECTS) -o \$(NAME)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo "echo \"\033[0;92mprogram file was created\"" >> $FILE
		echo -en "\n\n" >> $FILE
	fi
	echo -en "\$(OBJ_DIR)%.o\t:\t\$(SRC_DIR)%.c\t\$(HEADERS)\n" >> $FILE
	echo -en "\t\t@\$(CC) \$(CCFLAG) -c -I\$(HDR_DIR) \$< -o \$@" >> $FILE
	echo -en "clean\t:\n\t\trm -rf \$(OBJ_DIR)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo -n "echo \"\033[0;91mobject files was deleted\"" >> $FILE
	echo -en "\n\nfclean\t:\tclean\n\t\trm -rf \$(NAME)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo "echo \"\033[0;91m\$(NAME) was deleted\"" >> $FILE
	echo -en "\n\nre\t\t:\tfclean \$(NAME)\n\n\n" >> $FILE
fi

ft_phony_querry

if [ -f "./Makefile" ]; then
	echo -en "\033[32;1m?\033[0m \033[2;91m Makefile is already existent, would you like to overwrite it? (y/n)\033[0m : "
	read CHECK
	if [ "${CHECK}" == "y" ]; then
		chmod 755 .mf
		mv .mf Makefile
	else
		rm -rf .mf
	fi
else
	chmod 755 .mf
	mv .mf Makefile
fi