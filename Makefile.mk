######################################################################
# Adapted from libopencm3
######################################################################

ARM_TOOLCHAIN   ?= arm-none-eabi

TOP_DIR 	      := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
LIBOPENCM3_DIR  := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/include/libopencm3)

# Compile using the defined macro STM32F1
DEFS        += -DSTM32F1

FP_FLAGS    ?= -msoft-float
ARCH_FLAGS  = -mthumb -mcpu=cortex-m3 $(FP_FLAGS) -mfix-cortex-m3-ldrd
ASFLAGS     = -mthumb -mcpu=cortex-m3

# Toolchain variables
CC       := $(ARM_TOOLCHAIN)-gcc
CXX      := $(ARM_TOOLCHAIN)-g++
LD       := $(ARM_TOOLCHAIN)-gcc
AR       := $(ARM_TOOLCHAIN)-ar
AS       := $(ARM_TOOLCHAIN)-as
OBJCOPY  := $(ARM_TOOLCHAIN)-objcopy
SIZE     := $(ARM_TOOLCHAIN)-size
OBJDUMP  := $(ARM_TOOLCHAIN)-objdump
GDB      := $(ARM_TOOLCHAIN)-gdb

STFLASH          = $(shell which st-flash)
STYLECHECK       := /checkpatch.pl
STYLECHECKFLAGS  := --no-tree -f --terse --mailback
STYLECHECKFILES  := $(shell find . -name '*.[ch]')
OPT              := -Os -g
CSTD             ?= -std=c99

OBJS_1  = $(patsubst %.c,%.o,$(SRC))
OBJS_2  = $(patsubst %.asm,%.o,$(OBJS_1))
OBJS   = $(patsubst %.cpp,%.o,$(OBJS_2))

LDSCRIPT  ?= $(TOP_DIR)stm32f103c8t6.ld

TGT_CFLAGS  := $(OPT) $(CSTD)
TGT_CFLAGS  += $(ARCH_FLAGS)
TGT_CFLAGS  += -Wextra -Wshadow -Wimplicit-function-declaration
TGT_CFLAGS  += -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes
TGT_CFLAGS  += -fno-common -ffunction-sections -fdata-sections
TGT_CFLAGS  += -I$(LIBOPENCM3_DIR)/include
ifeq ($(FREERTOS_YES), yes)
	TGT_CFLAGS  += -I$(TOP_DIR)include/rtos/libwwg/include
	TGT_CFLAGS  += -I$(TOP_DIR)projects/projects-freertos/$(TARGET)/rtos/include
	TGT_CFLAGS  += -I$(TOP_DIR)projects/projects-freertos/$(TARGET)/include
endif

TGT_CXXFLAGS  := $(OPT) $(CXXSTD)
TGT_CXXFLAGS  += $(ARCH_FLAGS)
TGT_CXXFLAGS  += -Wextra -Wshadow -Wredundant-decls  -Weffc++
TGT_CXXFLAGS  += -fno-common -ffunction-sections -fdata-sections

TGT_CPPFLAGS  := -MD
TGT_CPPFLAGS  += -Wall -Wundef
TGT_CPPFLAGS  += $(DEFS)
TGT_CPPFLAGS  += -I$(LIBOPENCM3_DIR)/include
ifeq ($(FREERTOS_YES), yes)
	TGT_CPPFLAGS  += -I$(TOP_DIR)include/rtos/libwwg/include
	TGT_CPPFLAGS  += -I$(TOP_DIR)projects/projects-freertos/$(TARGET)/rtos/include
	TGT_CPPFLAGS  += -I$(TOP_DIR)projects/projects-freertos/$(TARGET)/include
endif

TGT_LDFLAGS  := --static -nostartfiles
TGT_LDFLAGS  += -T$(LDSCRIPT)
TGT_LDFLAGS  += $(ARCH_FLAGS)
TGT_LDFLAGS  += -Wl,-Map=$(*).map
TGT_LDFLAGS  += -Wl,--gc-sections

LDLIBS  := -specs=nosys.specs
LDLIBS  += -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group
LDLIBS  += -L$(LIBOPENCM3_DIR)/lib -lopencm3_stm32f1
ifeq ($(FREERTOS_YES), yes)
	LDLIBS  += -L$(TOP_DIR)include/rtos/libwwg -lwwg
endif

.SUFFIXES:	.elf .bin .hex .srec .list .map .images
.SECONDEXPANSION:
.SECONDARY:

elf:	$(DEPS) $(TARGET).elf
bin:	$(DEPS) $(TARGET).bin
hex:	$(DEPS) $(TARGET).hex
srec:	$(DEPS) $(TARGET).srec
list:	$(DEPS) $(TARGET).list

print-%:
	@echo $*=$($*)

.PHONY: images clean elf bin hex srec list all

%.images: %.bin %.hex %.srec %.list %.map
	@#printf "*** $* images generated ***\n"

%.bin: %.elf
	@#printf "  OBJCOPY $(*).bin\n"
	$(OBJCOPY) -Obinary $(*).elf $(*).bin

%.hex: %.elf
	@#printf "  OBJCOPY $(*).hex\n"
	$(OBJCOPY) -Oihex $(*).elf $(*).hex

%.srec: %.elf
	@#printf "  OBJCOPY $(*).srec\n"
	$(OBJCOPY) -Osrec $(*).elf $(*).srec

%.list: %.elf
	@#printf "  OBJDUMP $(*).list\n"
	$(OBJDUMP) -S $(*).elf > $(*).list

%.elf %map: $(OBJS) $(LDSCRIPT)
	@printf " LD $(*).c\n"
	$(LD) $(TGT_LDFLAGS) $(LDFLAGS) $(OBJS) $(LDLIBS) -o $(*).elf
	@printf " SIZE $(*).c\n"
	$(SIZE) $(TARGET).elf

%.o: %.c
	@printf " CC $(*).c\n"
	$(CC) $(TGT_CFLAGS) $(CFLAGS) $(TGT_CPPFLAGS) $(CPPFLAGS) -o $(*).o -c $(*).c

%.o: %.cxx
	@#printf "  CXX     $(*).cxx\n"
	$(CXX) $(TGT_CXXFLAGS) $(CXXFLAGS) $(TGT_CPPFLAGS) $(CPPFLAGS) -o $(*).o -c $(*).cxx

%.o: %.cpp
	@#printf "  CXX     $(*).cpp\n"
	$(CXX) $(TGT_CXXFLAGS) $(CXXFLAGS) $(TGT_CPPFLAGS) $(CPPFLAGS) -o $(*).o -c $(*).cpp

%.o: %.asm
	$(AS) $(ASFLAGS) -o $*.o -c $<

clean:
	@#printf "  CLEAN\n"
	$(RM) *.o *.d generated.* $(OBJS) $(patsubst %.o,%.d,$(OBJS))

clobber: clean
	rm -f *.elf *.bin *.hex *.srec *.list *.map $(CLOBBER)

# Flash 64k Device
flash:	$(TARGET).bin
	$(STFLASH) $(FLASHSIZE) write $(TARGET).bin 0x8000000

# Flash 128k Device
bigflash: $(TARGET).bin
	$(STFLASH) --flash=128k write $(TARGET).bin 0x8000000

-include $(OBJS:.o=.d)

