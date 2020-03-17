#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

static void gpio_setup (void)
{
  /* Enable GPIOC clock. */
  rcc_periph_clock_enable(RCC_GPIOC);

  /* Set GPIO5 (in GPIO port A) to 'output push-pull'. */
  gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ,
    GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);
}

int main (void)
{
  gpio_setup();

  while (1) {
    __asm__("nop");
  }

  return 0;
}

