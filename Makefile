


NAME		=	libft.a

CC			=	gcc
CCFLAG		=	-Wall -Wextra -Werror

SOURCES		=	

HEADERS		=	-I.
OBJECTS		=	$(SOURCES:.c=.o)

all		:	$(NAME)

$(NAME)	:	$(OBJECTS)
		ar rcs $(NAME) $(OBJECTS)
		echo "\033[0;92mlibrary (.a) file was created"


clean	:
		rm -rf $(OBJECTS)
		echo "\033[0;91mobject files was deleted"


fclean	:	clean
		rm -rf $(NAME)
		echo "\033[0;91m$(NAME) was deleted"


re		:	fclean $(NAME)


.PHONY	:		all clean fclean re
