######################################################################
#  Project Makefile
######################################################################

# The target name is the name of the project
BINARY  = $(shell basename $(CURDIR))
# The source files
SRC     = src/main.c
# The libopencm3 internal flag used for including the respective
# liboopencm3 contents and variables
LIBOPENCM3_YES = yes

all: elf bin

include ../../../Makefile.mk

