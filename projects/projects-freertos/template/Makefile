######################################################################
#  Project Makefile
######################################################################

# The target name is the name of the main function
TARGET  = $(shell basename $(CURDIR))
# The source files
SRC     = src/main.c rtos/src/tasks.c rtos/src/list.c rtos/src/heap_4.c \
	rtos/src/port.c rtos/src/opencm3.c

# Internal flag used for including the respective FreeRTOS contents
# and variables
FREERTOS_YES = yes

print-%:
	@echo $*=$($*)

include ../../../Makefile.mk

