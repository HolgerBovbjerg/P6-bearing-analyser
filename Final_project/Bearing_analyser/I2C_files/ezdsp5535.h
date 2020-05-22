/* 
 * Variable definitions, system module addresses and setup functions for TI ezdsp5535 board
 * */

#ifndef EZDSP5535_H_
#define EZDSP5535_H_
/* Variable types*/

#define Uint32  unsigned long
#define Uint16  unsigned short
#define Uint8   unsigned char
#define Int32   int
#define Int16   short
#define Int8    char

/* Software breakpoint difinition */
#define SW_BREAKPOINT      while(1);

/* System Module register addresses  */
#define SYS_EXBUSSEL       *(volatile ioport Uint16*)(0x1c00) // External bus select
#define SYS_PCGCR1         *(volatile ioport Uint16*)(0x1c02) // Peripheral clock generator r1
#define SYS_PCGCR2         *(volatile ioport Uint16*)(0x1c03) // Peripheral clock generator r2
#define SYS_PRCNTR         *(volatile ioport Uint16*)(0x1c04) // Peripheral Software Reset Counter Register
#define SYS_PRCNTRLR       *(volatile ioport Uint16*)(0x1c05) // PeripheralResetControlRegister
#define SYS_GPIO_DIR0      *(volatile ioport Uint16*)(0x1c06) // GPIO direction bank 0
#define SYS_GPIO_DIR1      *(volatile ioport Uint16*)(0x1c07) // GPIO direction bank 1
#define SYS_GPIO_DATAIN0   *(volatile ioport Uint16*)(0x1c08) // GPIO input bank 0
#define SYS_GPIO_DATAIN1   *(volatile ioport Uint16*)(0x1c09) // GPIO input bank 1
#define SYS_GPIO_DATAOUT0  *(volatile ioport Uint16*)(0x1c0a) // GPIO output bank 0
#define SYS_GPIO_DATAOUT1  *(volatile ioport Uint16*)(0x1c0b) // GPIO output bank 1
#define SYS_OUTDRSTR       *(volatile ioport Uint16*)(0x1c16) // Output Drive Strength Control Register
#define SYS_SPPDIR         *(volatile ioport Uint16*)(0x1c17) // Pulldown Inhibit Register1

/* I2C Module register addresses */
 
#define I2C_IER    	       *(volatile ioport Uint16*)(0x1A04) // i2c interrupt mask register
#define I2C_STR    	       *(volatile ioport Uint16*)(0x1A08) // i2c interrupt status register
#define I2C_CLKL           *(volatile ioport Uint16*)(0x1A0C) // i2c clock LOW-Time divider
#define I2C_CLKH           *(volatile ioport Uint16*)(0x1A10) // i2c clock HIGH-Time divider
#define I2C_CNT    		   *(volatile ioport Uint16*)(0x1A14) // i2c data count register
#define I2C_DRR    		   *(volatile ioport Uint16*)(0x1A18) // i2c data receive register
#define I2C_SAR    	       *(volatile ioport Uint16*)(0x1A1C) // i2c slave address register
#define I2C_DXR    	       *(volatile ioport Uint16*)(0x1A20) // i2c data transmit register
#define I2C_MDR            *(volatile ioport Uint16*)(0x1A24) // i2c mode register
#define I2C_EDR    	       *(volatile ioport Uint16*)(0x1A2C) // i2c extended mode register
#define I2C_PSC    	       *(volatile ioport Uint16*)(0x1A30) // i2c prescale register

/* I2S Module register addresses  */

#define I2S0_SRGR          *(volatile ioport Uint16*)(0x2804) // i2s0 serializer control register
#define I2S0_W0_LSW_W      *(volatile ioport Uint16*)(0x2808) // i2s0 Sample rate generator register
#define I2S0_W0_MSW_W      *(volatile ioport Uint16*)(0x2809)
#define I2S0_W1_LSW_W      *(volatile ioport Uint16*)(0x280C)
#define I2S0_W1_MSW_W      *(volatile ioport Uint16*)(0x280D)
#define I2S0_IR            *(volatile ioport Uint16*)(0x2810)
#define I2S0_ICMR          *(volatile ioport Uint16*)(0x2814)
#define I2S0_W0_LSW_R      *(volatile ioport Uint16*)(0x2828)
#define I2S0_W0_MSW_R      *(volatile ioport Uint16*)(0x2829)
#define I2S0_W1_LSW_R      *(volatile ioport Uint16*)(0x282C)
#define I2S0_W1_MSW_R      *(volatile ioport Uint16*)(0x282D)

#define I2S2_CR            *(volatile ioport Uint16*)(0x2A00) // i2s2 serializer control register
#define I2S2_SRGR          *(volatile ioport Uint16*)(0x2A04) // i2s2 Sample rate generator register
#define I2S2_W0_LSW_W      *(volatile ioport Uint16*)(0x2A08) // i2s2 transmit left data 0 register
#define I2S2_W0_MSW_W      *(volatile ioport Uint16*)(0x2A09) // i2s2 transmit left data 1 register 
#define I2S2_W1_LSW_W      *(volatile ioport Uint16*)(0x2A0C) // i2s2 transmit right data 0 register
#define I2S2_W1_MSW_W      *(volatile ioport Uint16*)(0x2A0D) // i2s2 transmit right data 1 register
#define I2S2_IR            *(volatile ioport Uint16*)(0x2A10) // i2s2 interrupt flag register
#define I2S2_ICMR          *(volatile ioport Uint16*)(0x2A14) // i2s2 interrupt mask register
#define I2S2_W0_LSW_R      *(volatile ioport Uint16*)(0x2A28) // i2s2 receive left data register 0
#define I2S2_W0_MSW_R      *(volatile ioport Uint16*)(0x2A29) // i2s2 receive left data register 1
#define I2S2_W1_LSW_R      *(volatile ioport Uint16*)(0x2A2C) // i2s2 receive right data register 0
#define I2S2_W1_MSW_R      *(volatile ioport Uint16*)(0x2A2D) // i2s2 receive right data register 1


/* Prototype functions */

/* Board Initialization */
Int16 ezdsp5535_init( );

/* Wait Functions */
void ezdsp5535_wait( Uint32 delay );
void ezdsp5535_waitusec( Uint32 usec );

#endif /*EZDSP5535_H_*/
