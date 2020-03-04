##
# Makefile for common tasks
##

# Variables -------------------------------------------------------------------
SRC = $(wildcard src/*.md)
OBJ = $(SRC:.md=.ipynb)


# Rules -----------------------------------------------------------------------

# One rule to rule them all
all: ${OBJ}

# Convert
src/%.ipynb: src/%.md
	pandoc $< -t ipynb -o $@

.PHONY: clean
clean:
	rm -rfv ${OBJ}
