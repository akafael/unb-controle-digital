##
# Makefile for common tasks
#
# @author akafael
##

# Variables -------------------------------------------------------------------
SRC = $(wildcard src/jupyter/*.md)
OBJ = $(SRC:.md=.ipynb)
OUTPUT = $(addprefix notes/, $(notdir ${OBJ}))

# Rules -----------------------------------------------------------------------

# One rule to rule them all
all: ${OBJ} ${OUTPUT}

# Convert Markdown notes to Jupyter
src/jupyter/%.ipynb: src/jupyter/%.md
	pandoc $< -t ipynb -o $@

# Evaluate each ipynb
notes/%.ipynb: src/jupyter/%.ipynb
	jupyter nbconvert --execute $<

# Remove Generated Files
.PHONY: clean
clean:
	-rm -rfv ${OBJ}
	-rm -rfv ${OUTPUT}
