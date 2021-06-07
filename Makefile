


NAME		=	42

CC			=	gcc
CCFLAG		=	-Wall -Wextra -Werror

SOURCES		=	

HEADERS		=	-I.
OBJECTS		=	$(SOURCES:.c=.o)

all		:	$(NAME)

$(NAME)	:	$(OBJECTS) $(HEADERS)
	$(CC) $(CCFLAG) $(HEADERS) $(OBJECTS) -o $(NAME)
	echo "\033[0;92mprogram file was created"


$(OBJ_DIR)%.o	:	$(SRC_DIR)%.c $(HEADERS)
	@$(CC) $(CCFLAG) -c -I$(HDR_DIR) $< -o $@

clean	:
	rm -rf $(OBJ_DIR)
	echo "\033[0;91mobject files was deleted"

fclean	:	clean
	rm -rf $(NAME)
	echo "\033[0;91m$(NAME) was deleted"


re		:	fclean $(NAME)

.PHONY	:	all clean fclean re
