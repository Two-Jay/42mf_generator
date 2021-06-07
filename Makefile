# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jekim <jekim@student.42seoul.kr>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/07 13:49:00 by jekim             #+#    #+#              #
#    Updated: 2021/06/07 13:49:03 by jekim            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		=	42

CC			=	gcc
CCFLAG		=	-Wall -Wextra -Werror

HDR_DIR		=	./includes
HDR_FILE	=	

HEADERS		=	$(addprefix $(HDR_DIR), $(HDR_FILE))


SRC_DIR		=	./src
SRC_FILE	=	

SOURCES		=	$(addprefix $(SRC_DIR), $(SRC_FILE))


OBJ_DIR		=	./obj
OBJ_FILE	=	$(patsubst %.c, %.o, $(SRC_FILE))
OBJECTS		=	$(addprefix $(OBJ_DIR), $(OBJ_FILE))


all		:	$(NAME)

$(NAME)	:	$(OBJECTS) $(HEADERS)
		$(CC) $(CCFLAG) $(HEADERS) $(OBJECTS) -o $(NAME)
		echo "\033[0;92mprogram file was created"


$(OBJ_DIR)%.o	:	$(SRC_DIR)%.c	$(HEADERS)
		@$(CC) $(CCFLAG) -c -I$(HDR_DIR) $< -o $@clean	:
		rm -rf $(OBJ_DIR)
		echo "\033[0;91mobject files was deleted"

fclean	:	clean
		rm -rf $(NAME)
		echo "\033[0;91m$(NAME) was deleted"


re		:	fclean $(NAME)


.PHONY	:		all clean fclean re
