##
# Makefile for common tasks
#
# @author akafael
##

###############################################################################
# Variables 
###############################################################################

OCTAVE = octave

# LaTeX Report ----------------------------------------------------------------
TEX = pdflatex
TEXFLAGS = --enable-write18 --shell-escape
PDFOUTPUT = exsim1.pdf

# Markdown Notes --------------------------------------------------------------
SRC = $(wildcard src/jupyter/*.md)
OBJ = $(SRC:.md=.ipynb)
OUTPUT = $(addprefix notes/, $(notdir ${OBJ}))

###############################################################################
# Rules 
###############################################################################

# One rule to rule them all
all: ${OBJ} ${OUTPUT}

# Notes -----------------------------------------------------------------------

# Convert Markdown notes to Jupyter
src/jupyter/%.ipynb: src/jupyter/%.md
	pandoc $< -t ipynb -o $@

# Evaluate each ipynb
notes/%.ipynb: src/jupyter/%.ipynb
	jupyter nbconvert --execute $<

# Remove Generated Files
.PHONY: clean
clean-notes:
	-rm -rfv ${OBJ}
	-rm -rfv ${OUTPUT}


# LaTeX Reports ---------------------------------------------------------------

# Generated Reports
.PHONY: report
report: ${PDFOUTPUT}

# Implicity Rule to Compile texfile
src/tex/%.pdf: src/tex/%.tex
	cd $(dir $<) && $(TEX) $(TEXFLAGS) $(notdir $<)

# Remove LaTeX Temporary files
.PHONY: clean-tex
clean-tex:
	rm -f $(NAME).aux $(NAME).bbl $(NAME).blg $(NAME).log $(NAME).idx $(NAME).out \ 
	$(NAME).nav $(NAME).snm $(NAME).toc $(NAME).vrb

.PHONY = clean-all
clean-pdf: clean-tex
	rm -f $(NAME).pdf

# Simulation Scripts ----------------------------------------------------------

.PHONY: exsim1
exsim1: src/matlab/exsim1.m
	${OCTAVE} $<


