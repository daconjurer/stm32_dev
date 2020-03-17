######################################################################
# Project.mk file for compiling new projects using libopencm3
######################################################################

PROJECT         ?= new_project
TOP_DIR         := $(dir $(abspath $(MAKEFILE_LIST)))
LIBOPENCM3_DIR  := $(TOP_DIR)../../include/libopencm3

# For debugging
print-%:
	@echo $*=$($*)

.PHONY: all

all: check setup license
	@echo "New project successfully created."

check:
	@echo "Checking environment..."
	@if [ ! -d $(LIBOPENCM3_DIR) ] ; then \
		echo "Directory $(LIBOPENCM3_DIR) is missing." ; \
		exit 2; \
	fi
	@if [ ! -f $(LIBOPENCM3_DIR)/Makefile ] ; then \
		echo "Directory $(LIBOPENCM3_DIR) is incomplete." ; \
		exit 2; \
	fi
	@if [ ! -f $(LIBOPENCM3_DIR)/lib/libopencm3_stm32f1.a ] ; then \
		echo "Library $(LIBOPENCM3_DIR)/lib/libopencm3_stm32f1.a missing." ; \
		echo "Make sure that the library is succesfully compiled." ; \
		exit 2; \
	fi
	@if [ "$(PROJECT)" = "new_project" ] ; then \
		echo "Default project name: new_project." ; \
	fi
	@if [ -d $(PROJECT) ] ; then \
		echo "Error: directory $(PROJECT) already exists; try another name." ; \
		exit 2 ; \
	fi
	@echo "Done"

setup:
	@echo "Setup..."
	@mkdir -p "$(PROJECT)/include"
	@mkdir -p "$(PROJECT)/src"
	@cp ./template/main.c $(PROJECT)/src/main.c
	@cp ./template/Makefile $(PROJECT)/.
	@echo "Done"

license:
	@cp $(LIBOPENCM3_DIR)/COPYING.LGPL3 $(PROJECT)/COPYING.LGPL3
	@echo "OpenCM3 License added."

