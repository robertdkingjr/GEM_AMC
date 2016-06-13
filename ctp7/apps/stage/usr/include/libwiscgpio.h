#ifndef _LIBWISCGPIO_H
#define _LIBWISCGPIO_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int gpio_find_chip(uint32_t addr);
int gpio_get_ngpios(uint8_t gpiochip);
int gpio_is_input(uint8_t gpio);

int gpio_find_id(uint32_t addr, uint8_t gpionum);

int gpio_read_value(uint8_t gpio);
int gpio_set_output(uint8_t gpio, uint8_t value);
int gpio_set_input(uint8_t gpio);

#ifdef __cplusplus
}
#endif

#endif
