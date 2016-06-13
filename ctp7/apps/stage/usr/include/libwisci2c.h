#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	int fd;
	int flags;
} i2chandle_t;

int i2c_read(int fd, uint8_t devaddr, uint8_t regaddr, uint8_t *buf, int len);
int i2c_write(int fd, uint8_t devaddr, uint8_t regaddr, const uint8_t *buf, int len);

#ifdef __cplusplus
}
#endif
