#ifndef EZDSP5535_I2C_H_
#define EZDSP5535_I2C_H_

#include "ezdsp5535.h"

#define MDR_STT			0x2000 // Mode Register start condition bit
#define MDR_TRX			0x0200 // Mode Register transmitter mode bit
#define MDR_MST			0x0400 // Mode Register master mode bit (1=master mode, 0=slave mode)
#define MDR_IRS			0x0020 // Mode Register i2c reset bit
#define MDR_FREE		0x4000 // Mode Register emulation mode bit (when 1 the i2c continues at breakpoints)
#define STR_XRDY		0x0010 // Intterupt status register transmit data ready bit
#define STR_RRDY		0x0008 // Intterupt status register receive data ready bit
#define MDR_STP 		0x0800 // Mode Register stop condition bit

// Function prototypes
Int16 ezdsp5535_I2C_init ( );
Int16 ezdsp5535_I2C_close( );
Int16 ezdsp5535_I2C_read( Uint16 i2c_addr, Uint8* data, Uint16 len );
Int16 ezdsp5535_I2C_write( Uint16 i2c_addr, Uint8* data, Uint16 len );
Int16 ezdsp5535_I2C_write_SR( Uint16 i2c_addr, Uint8* data, Uint16 len );
Int16 ezdsp5535_I2C_reset( );
#endif /*EZDSP5535_I2C_H_*/
