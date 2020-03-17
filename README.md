# stm32_dev
This repo collects development tools, examples, and reference on
embedded systems development using the STM32 "Blue Pill" MCU. The
setup includes Bare Metal, Mbed, libopencm3 and FreeRTOS applications.

The Makefile in the root directory is for compiling libopencm3 and FreeRTOS,
while the top level Makefile.mk file in the root directory is for compiling the
projects; this file is required no matter what library is used.

## Prerequisites

* **libopencm3** For development using the libopencm3 firmware library,
you should download it from [here](https://github.com/libopencm3/libopencm3)
and follow their Installation instructions.

* **FreeRTOS** In order to use the Real-Time capabilities from FreeRTOS,
download the version of your preference from [here](https://www.freertos.org)
as a zip file. Unzip and you are all set.

Note: This setup assumes you have an *include* folder in the root
directory of this repo and the ```libopencm3``` and ```rtos/FreeRTOSvX.X.X```
folders are placed inside *include*.

## Examples

Soon to become...

## Acknowledgements
This repo is strongly based on the
[stm32f103cc8t6](https://github.com/ve3wwg/stm32f103c8t6)
repo by **Warren Gay** - [ve3wwg](https://github.com/ve3wwg).

## Authors

* **Victor Sandoval** - [daconjurer](https://github.com/daconjurer)

## Note

This project is just a collection of resources that I find useful and
use myself for the projects using the Blue Pill board, and is strongly
based on the [stm32f103cc8t6](https://github.com/ve3wwg/stm32f103c8t6)
repo by **Warren Gay** - [ve3wwg](https://github.com/ve3wwg).
