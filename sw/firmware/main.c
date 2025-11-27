// IceGuard – minimal bare-metal firmware skeleton
#include <stdint.h>

#define UART_BASE   0x00000000  // TODO

static void uart_putc(char c)
{
	volatile uint32_t *tx = (uint32_t *)(UART_BASE);
	*tx = (uint32_t)c;
}

static void uart_puts(const char *s)
{
	while (*s) {
	if (*s == '\n')
		uart_putc('\r');
	uart_putc(*s++);
	}
}

void main(void)
{
	uart_puts("IceGuard firmware booting...\n");

	while (1) {
		// heartbeat placeholder
	}
}

