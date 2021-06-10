#!/bin/bash

FILE="./.mf"
BC="./.breadcrumb.txt"
DIR_INPUT=0
LIB_INPUT=0
PHONY_INPUT=0

function ft_input_querry()
{
	echo -en "\033[32;1m?\033[0m \033[2m would you like to make some directories : src, obj, includes ? (y/n)\033[0m : "
	read DIR_INPUT
	echo -en "\033[32;1m?\033[0m \033[2m is this project for making a library (.a file) ? (y/n)\033[0m : "
	read LIB_INPUT
	echo -en "\033[32;1m?\033[0m \033[2m Do you want .PHONY option ? (y/n)\033[0m : "
	read PHONY_INPUT
}


# this function is for write basic members in Makefile
# INPUT is user's input
# if the user didn't enter a input, 2nd parameter will be replaced칟ㅁㄱ as a defalut value\
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
	mkdir -p $1
	echo -en "$2_DIR" >> $FILE
	printf "%${TLEN}s" | tr " " "\t" >> $FILE
	echo -e "=\t./$1/" >> $FILE
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

function ft_do_mkdir()
{
	if [ "$DIR_INPUT" == "y" ] ; then
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


function ft_check_dup_and_finish()
{
	if [ -f "./Makefile" ]; then
		echo -en "\033[91;1m!\033[0m \033[1;91m Makefile is already existent, would you like to overwrite it? (y/n)\033[0m : "
		read CHECK
		if [ "${CHECK}" == "y" ]; then
			chmod 755 .mf
			mv .mf Makefile
			echo -en "\033[0;94m * * * Makefile was created in your project's directory * * * \033[0m\n"
			echo -en "\033[0;94m * * *     ᕕ( ᐛ )ᕗ           Have a good CODING time ! * * * \033[0m\n"
		else
			rm -rf .mf
			echo -en "\033[91;1m!\033[0m \033[1;31m the process was canceled \033[0m\n"
		fi
	else
		chmod 755 .mf
		mv .mf Makefile
		echo -en "\033[0;94m * * * Makefile was created in your project's directory * * * \033[0m\n"
		echo -en "\033[0;94m * * *     ᕕ( ᐛ )ᕗ           Have a good CODING time ! * * * \033[0m\n"
	fi
}

function ft_write_mk_instruction_with_dir()
{
	echo -en "all\t\t\t:\t\$(NAME)\n\n" >> $FILE
	if [ "$LIB_INPUT" == "y" ]; then
		echo -en "\$(NAME)\t\t:\t\$(OBJ_DIR) \$(OBJECTS)\n" >> $FILE
		echo -en "\t\tar -rcs \$(NAME) \$(OBJECTS)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo -n "@echo \"\033[0;92m* \$(NAME) library file was created *\033[0m\"" >> $FILE
		echo -en "\n\n" >> $FILE
	else
		echo -en "\$(NAME)\t\t:\t\$(OBJ_DIR) \$(OBJECTS)\n" >> $FILE
		echo -en "\t\t\$(CC) \$(CCFLAG) \$(OBJECTS) -o \$(NAME)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo -n "@echo \"\033[0;92m* \$(NAME) program file was created\033[0m *\"" >> $FILE
		echo -en "\n\n" >> $FILE
	fi
	echo -en "\$(OBJ_DIR)%.o : \$(SRC_DIR)%.c\n\t\t@\$(CC) \$(CCFLAGS) -c \$< -o \$@\n\n" >> $FILE
	echo -en "clean\t\t:\n\t\trm -rf \$(OBJECTS)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo -n "@echo \"\033[0;91m* \$(NAME) object files was deleted *\033[0m\"" >> $FILE
	echo -en "\n\nfclean\t\t:\tclean\n\t\trm -rf \$(NAME)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo -n "@echo \"\033[0;91m* \$(NAME) was deleted *\033[0m\"" >> $FILE
	echo -en "\n\nre\t\t\t:\tfclean \$(NAME)\n\n" >> $FILE
	if [ "$PHONY_INPUT" == "y" ]; then
		echo -en ".PHONY\t\t:\tall clean fclean re\n" >> $FILE
	fi
}

function ft_write_mk_instruction_without_dir()
{
	echo -en "all\t\t\t:\t\$(NAME)\n\n" >> $FILE
	if [ "$LIB_INPUT" == "y" ]; then
		echo -en "\$(NAME)\t\t:\t\$(OBJECTS)\n" >> $FILE
		echo -en "\t\tar -rcs \$(NAME) \$(OBJECTS)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo -n "@echo \"\033[0;92m* \$(NAME) library file was created *\033[0m\"" >> $FILE
		echo -en "\n" >> $FILE
	else
		echo -en "\$(NAME)\t\t:\t\$(OBJECTS)\n" >> $FILE
		echo -en "\t\t\$(CC) \$(CCFLAG) \$(HEADERS) \$(OBJECTS) -o \$(NAME)\n" >> $FILE
		echo -en "\t\t" >> $FILE
		echo -n "@echo \"\033[0;92m* \$(NAME) program file was created *\033[0m\"" >> $FILE
		echo -en "\n\n" >> $FILE
	fi
	# echo -en "\$(OBJ_DIR)%.o\t:\t\$(SRC_DIR)%.c \$(HEADERS)\n" >> $FILE
	# echo -en "\t@\$(CC) \$(CCFLAG) -c -I\$(HDR_DIR) \$< -o \$@\n\n" >> $FILE
	echo -en "clean\t\t:\n\t\trm -rf \$(OBJECTS)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo -n "@echo \"\033[0;91m* \$(NAME) object files was deleted *\033[0m\"" >> $FILE
	echo -en "\n\nfclean\t\t:\tclean\n\t\trm -rf \$(NAME)\n" >> $FILE
	echo -en "\t\t" >> $FILE
	echo -n "@echo \"\033[0;91m* \$(NAME) was deleted* \033[0m\"" >> $FILE
	echo -en "\n\nre\t\t\t:\tfclean all\n\n" >> $FILE
	if [ "$PHONY_INPUT" == "y" ]; then
		echo -en ".PHONY\t\t:\tall clean fclean re\n" >> $FILE
	fi
}


echo -en "\033[0;94m \ * * * * * * * * * * * * * * * * * * * * * *  cccccccccccodO0XNWNKOkxxkxxdolcccccccccc \n"
echo -en "\033[0;94m \ *                                         *  ccccccccoddkKWWMMMMNX0dllooddddolccccccc \n"
echo -en "\033[0;94m \ *       \(^ .^)/                          *  cccccldOXXkod0NMMMMMMMNOdlccclodddlccccc \n"
echo -en "\033[0;94m \ *                                         *  ccccoONWMMN0dld0NMMMMMMWNOdlccccldxdlccc \n"
echo -en "\033[0;94m \ *                     \(^0 ^)/            *  ccldOXWMMMMMN0dld0NMMMMMMWXkocccccoxxlcc \n"
echo -en "\033[0;94m \ *   All hail                              *  clxOdd0NMMMMMWNOdlx0XWMMMWXOollccccldxoc \n"
echo -en "\033[0;94m \ *      the Coalition GAM                  *  cxXWKxod0NMMMMMWNOdooxKNNOdoxKKkocccldxl \n"
echo -en "\033[0;94m \ *                                         *  oKWMMWKxox0NMMMMMWXOxooddoxKWMMWXkocclxd \n"
echo -en "\033[0;94m \ *             .                           *  xNMMMMMWKxox0WMMMMMWWXOoco0WMMMMMWXkoldx \n"
echo -en "\033[0;94m \ *      ,,            ,,                   *  xKNWMMMMMN0xoxKWMMMMMMWXkooxKWMMMMMWKkxk \n"
echo -en "\033[0;94m \ *                            ,            *  xxdONWMMMMMN0doxKWMMMMMMWXkookXWMMMMMWNO \n"
echo -en "\033[0;94m \ *    Makefile_generator                   *  xxdONWMMMMMN0doxKWMMMMMMWXkookXWMMMMMWNO \n"
echo -en "\033[0;94m \ *             for 42_network's  \         *  dxlldONMMMMMWXxclxKWMMMMMMWXkookXWMMMMWO \n"
echo -en "\033[0;94m \ *       ,,         students               *  oxdccldONWMWKxodxdok0KWMMMMMWKkookXWMMXd \n"
echo -en "\033[0;94m \ *                                         *  cdxocccldO0xod0NWNOdookXWMMMMMWKxookXNkl \n"
echo -en "\033[0;94m \ *             .                  .        *  ccdxocccclllkNMMMMWNKOdokXWMMMMMWKxdkklc \n"
echo -en "\033[0;94m \ *                        ,,               *  cccoxdlccccld0NMMMMMMWNOdokXWMMMMMN0dlcc \n"
echo -en "\033[0;94m \ *                                         *  ccccldxdlcccclxKWMMMMMMWXkookXWMWXOocccc \n"
echo -en "\033[0;94m \ *                                         *  ccccccldxdolccclxKWMMMMMMWXkdxKKkolccccc \n"
echo -en "\033[0;94m \ *                                         *  cccccccclodddddoodkXWWMMWWNKkdolcccccccc \n"
echo -en "\033[0;94m \ * * * * * * * * * * * * * * * * * * * * * *  ccccccccccccldxxxxxOKKXK0kxolccccccccccc \n"

## main
if [ -f $FILE ]; then
	rm -rf $FILE
fi
touch $FILE
echo -e "\n\n" >> $FILE
ft_member_querry NAME "42" LIB
echo -en "\n" >> $FILE
ft_member_querry CC "gcc" 0
ft_member_querry CCFLAG "-Wall -Wextra -Werror" 0
ft_input_querry
echo -en "\n" >> $FILE
ft_do_mkdir

if [ "$DIR_INPUT" == "y" ]; then
	ft_write_mk_instruction_with_dir
else
	ft_write_mk_instruction_without_dir
fi
ft_check_dup_and_finish

if [ -f $BC ]; then
	rm -rf $BC
fi
touch $BC
echo -e "this user had used 42mf_generator to make Makefile.\nlink: https://github.com/Two-Jay/42mf_generator\n" >> $BC
echo -e "if you find this file during an evaluation of C-Piscine rush or subjects in la piscine," >> $BC
echo -e "it is up to you whether you give a fail as cheating to the evaluatee or not." >> $BC