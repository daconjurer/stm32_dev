######################################################################
# Project.mk file for compiling new projects using FreeRTOS and
# libopencm3.
######################################################################

# FreeRTOS release (edit according to the release that is to be used)
FREERTOS ?= FreeRTOSv10.2.1

PROJECT         ?= new_project
PROJRTOS        = $(PROJECT)/rtos
TOP_DIR         := $(dir $(abspath $(MAKEFILE_LIST)))
LIBOPENCM3_DIR  := $(TOP_DIR)../../include/libopencm3
FREERTOS_DIR    := $(TOP_DIR)../../include/rtos/$(FREERTOS)

# For debugging
print-%:
	@echo $*=$($*)

.PHONY: all

all: check setup license kernel_src mem_mang port kernel_headers \
	$(PROJECT)/FreeRTOSConfig.h
	@echo "New project $(PROJECT) successfully created."

check:
	@echo "Checking FreeRTOS environment..."
	@if [ ! -d $(FREERTOS_DIR) ] ; then \
		echo "Directory $(FREERTOS_DIR) is missing." ; \
		exit 2; \
	fi
	@if [ ! -d $(FREERTOS_DIR)/FreeRTOS ] ; then \
		echo "Directory $(FREERTOS_DIR) is corrupted." ; \
		echo "FreeRTOS directory is missing." ; \
		exit 2; \
	fi
	@echo "Done"
	@echo "Checking libopencm3 environment..."
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

kernel_src:
	@for f in list.c queue.c tasks.c ; do \
		echo "cp '$(FREERTOS_DIR)/FreeRTOS/Source/$$f' '$(PROJRTOS)/src'" ; \
		cp "$(FREERTOS_DIR)/FreeRTOS/Source/$$f" "$(PROJRTOS)/src" ; \
	done

mem_mang:
	@for f in $(FREERTOS_DIR)/FreeRTOS/Source/portable/MemMang/heap_*.c ; do \
		echo "cp '$$f' '$(PROJRTOS)/src'" ; \
		cp "$$f" "$(PROJRTOS)/src" ; \
	done

port:
	cp "$(FREERTOS_DIR)/FreeRTOS/Source/portable/GCC/ARM_CM3/port.c" "$(PROJRTOS)/src" ; \
	cp "$(FREERTOS_DIR)/FreeRTOS/Source/portable/GCC/ARM_CM3/portmacro.h" "$(PROJRTOS)/include" ; \

kernel_headers:
	@for f in FreeRTOS.h mpu_prototypes.h projdefs.h stdint.readme StackMacros.h \
	event_groups.h mpu_wrappers.h queue.h task.h croutine.h list.h \
	portable.h semphr.h timers.h deprecated_definitions.h stack_macros.h ; do \
		cp "$(FREERTOS_DIR)/FreeRTOS/Source/include/$$f" "$(PROJRTOS)/include" ; \
	done

setup:
	@echo "Setup..."
	@mkdir -p "$(PROJECT)/include"
	@mkdir -p "$(PROJECT)/src"
	@cp ./template/alters.sed $(PROJECT)/.
	@cp ./template/main.c $(PROJECT)/src/main.c
	@cp ./template/Makefile $(PROJECT)/.
	@mkdir -p "$(PROJECT)/rtos/src"
	@mkdir -p "$(PROJECT)/rtos/include"
	@echo "Done"

license:
	@cp $(LIBOPENCM3_DIR)/COPYING.LGPL3 $(PROJECT)/COPYING.LGPL3
	@echo "OpenCM3 License added."

# We don't use stm32f10x_lib.h because libopencm3 provides our device driver 
# facilities. So we comment that line out of FreeRTOSConfig.h
#
$(PROJECT)/FreeRTOSConfig.h:
	@echo "Editing $(PROJRTOS)/FreeRTOSConfig.h"
	@sed <$(FREERTOS_DIR)/FreeRTOS/Demo/CORTEX_STM32F103_Primer_GCC/FreeRTOSConfig.h \
	>$(PROJECT)/include/FreeRTOSConfig.h -f $(RTOSDIR)template/alters.sed

