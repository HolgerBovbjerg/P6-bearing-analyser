// standard c libraries
#include <stdio.h>

// ezdsp setup libraries
#include "ezdsp5535.h"
#include "ezdsp5535_gpio.h"
#include "ezdsp5535_i2c.h"
//#include "ezdsp_i2c.h"
#include "ezdsp5535_led.h"
#include "pll.h"

// board device libraries
#include "aic3204.h"

#define SAMPLES_PER_SECOND 48000
#define GAIN 40

//MMA8451
#include "MMA8451.h"

void inits(){
	/* Initialise system clocks */
	ezdsp5535_init();
	
	/* Initialize PLL */
	pll_frequency_setup(100);
	
	/* Initialise hardware interface and I2C for code */
    aic3204_hardware_init();
    
    /* Initialise the AIC3204 codec */
	aic3204_init(); 
	//SAR_init();
	/* Setup sampling frequency and gain */
    set_sampling_frequency_and_gain(SAMPLES_PER_SECOND, GAIN);	
    
    /* Initialise I2C */
    ezdsp5535_I2C_init();
    
	/* Default to XF LED off */
	//asm(" bclr XF"); // Clear register XF
	
}


void requestFromArduino(Int16 flag){
		Uint16 MMA_I2C_ADDR 			=	0x08;
		unsigned char MMA8451_REG_OUT_X_MSB[1];
		ezdsp5535_waitusec(250000);
		if(flag == 0){
		MMA8451_REG_OUT_X_MSB[0] = 0x10;}
		else if(flag == 1){
		MMA8451_REG_OUT_X_MSB[0] = 0x09;}
		ezdsp5535_I2C_reset();
		ezdsp5535_I2C_write(MMA_I2C_ADDR, MMA8451_REG_OUT_X_MSB, 1);	
		

}

void rpmReadI2C(Int16 *rpmdata){
	Uint16 MMA_I2C_ADDR 			=	0x08;
	Uint8 rpmdatabuff[2];
	ezdsp5535_waitusec(250000);
	ezdsp5535_I2C_reset();
	ezdsp5535_I2C_read( MMA_I2C_ADDR, rpmdatabuff, 2 );
	*rpmdata = rpmdatabuff[0] << 8; *rpmdata |= rpmdatabuff[1];
}
