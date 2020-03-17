######################################################################
#  Top Level: STM32F103C8T6 Projects
######################################################################

PROJECTS = projects/libopencm3/blink01

.PHONY = libopencm3 clobber_libopencm3 clean_libopencm3 libwwg

all:	libopencm3 libwwg
	for d in $(PROJECTS) ; do \
		$(MAKE) -C $$d ; \
	done
	$(MAKE) -$(MAKEFLAGS) -C ./include/rtos

clean:	clean_libopencm3
	for d in $(PROJECTS) ; do \
		$(MAKE) -C $$d clean ; \
	done
	$(MAKE) -$(MAKEFLAGS) -C ./include/rtos clean
	$(MAKE) -$(MAKEFLAGS) -C ./include/rtos/libwwg clean

clobber: clobber_libopencm3
	for d in $(PROJECTS) ; do \
		$(MAKE) -C $$d clobber ; \
	done
	$(MAKE) -$(MAKEFLAGS) -C ./include/rtos clobber
	$(MAKE) -$(MAKEFLAGS) -C ./include/rtos/libwwg clobber

clean_libopencm3: clobber_libopencm3

clobber_libopencm3:
	rm -f include/libopencm3/lib/libopencm3_stm32f1.a
	-$(MAKE) -$(MAKEFLAGS) -C ./include/libopencm3 clean

libopencm3: include/libopencm3/lib/libopencm3_stm32f1.a

include/libopencm3/lib/libopencm3_stm32f1.a:
	$(MAKE) -C include/libopencm3 TARGETS=stm32/f1

libwwg:
	$(MAKE) -C include/rtos/libwwg

