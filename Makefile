##
# Makefile for common tasks
#
# @author akafael
##

###############################################################################
# Variables 
###############################################################################

OCTAVE = octave
MATLAB_DIR = src/matlab
MATLAB = matlab -nodesktop -nosplash -sd $(MATLAB_DIR) <

# LaTeX Report ----------------------------------------------------------------
TEX = pdflatex
TEXFLAGS = --enable-write18 --shell-escape
TEXSRC = $(wildcard src/tex/ex*.tex)
PDFOUTPUT = $(TEXSRC:.tex=.pdf)

# Markdown Notes --------------------------------------------------------------
SRC = $(wildcard src/jupyter/*.md)
OBJ = $(SRC:.md=.ipynb)
OUTPUT = $(addprefix notes/, $(notdir ${OBJ}))

###############################################################################
# Rules 
###############################################################################

# One rule to rule them all
all: ${PDFOUTPUT}

# Print help for Makefile commands
.PHONY: help
help:
	@echo "Use: make -f Makefile [OPTION]"
	@echo "\nOPTIONS"
	@sed Makefile -n -e "N;s/^# \(.*\)\n.PHONY:\(.*\)/ \2:\1/p;D" | column -ts:
	@echo ""

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
src/tex/%.pdf: src/tex/%.tex src/tex/%.pytexcode
	cd $(dir $<) && bibtex $(basename $(notdir $<))
	cd $(dir $<) && $(TEX) $(TEXFLAGS) $(notdir $<)

# Implicity Rule to Compile Python Code inside tex file
src/tex/%.pytexcode: src/tex/%.tex src/python/%.py src/tex/relat_capa.tex src/tex/relat_layout.tex src/tex/references.bib
	cd $(dir $<) &&\
	$(TEX) $(TEXFLAGS) $(notdir $<) &&\
   	pythontex $(notdir $<)

# Remove LaTeX Temporary files
.PHONY: clean-tex
clean-tex:
	rm -fv src/tex/*.aux src/tex/*.bbl src/tex/*.blg src/tex/*.log src/tex/*.idx src/tex/*.out src/tex/*.nav src/tex/*.snm src/tex/*.toc src/tex/*.vrb

# Remove Python Temporary files
.PHONY: clean-py
clean-py:
	rm -fv src/tex/*.py*
	rm -fvr src/tex/pythontex-files-*

# Remove Generated PDF Files
.PHONY = clean-pdf
clean-pdf: clean-tex
	rm -fv ${PDFOUTPUT}

# Simulation Scripts ----------------------------------------------------------

.PHONY: exsim1
exsim1: src/matlab/exsim1.m
	${OCTAVE} $<

