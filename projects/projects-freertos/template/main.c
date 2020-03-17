#include "FreeRTOS.h"
#include "task.h"

#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

int main (void)
{
  rcc_clock_setup_in_hse_8mhz_out_72mhz();

  vTaskStartScheduler();

  for (;;);
  return 0;
}
