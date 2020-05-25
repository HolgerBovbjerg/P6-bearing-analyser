#include "ezdsp5535.h"
#include "aic3204.h"
#include "ezdsp5535_gpio.h"
#include "ezdsp5535_i2c.h"

#include <stdio.h>
Int16 counter1; // Counter variables for monitoring real-time operation.
Int16 counter2;

/* Function for getting value of codec register value
 * INPUT
 * regnum: number of register
 * regval: pointer to where the value is stored
 * OUTPUT
 * retcode: 0 if succefull, -1 if error 
 * */
Int16 AIC3204_rget(  Uint16 regnum, Uint16* regval )
{
    Int16 retcode = 0; // returncode
    Uint8 cmd[2]; // command vector

    cmd[0] = regnum & 0x007F;       // first commmand is register which is ANDed with 7-bit Device Address mask
    cmd[1] = 0; // No command only read

    retcode |= ezdsp5535_I2C_write( AIC3204_I2C_ADDR, cmd, 1 ); // Send register address to AIC3204 codec, store received data in cmd
    retcode |= ezdsp5535_I2C_read( AIC3204_I2C_ADDR, cmd, 1 ); // Receive value of AIC3204 register, store received data in cmd

    *regval = cmd[0]; // Store register value from cmd in memory
    ezdsp5535_wait( 10 ); // Wait for a short time (10 cycles)
    return retcode; // return returncode (-1 if error)
}

/* Function for setting codec register value 
 * INPUT
 * regnum: number of register
 * regval: value to put in register
 * OUTPUT
 * 0 if successfull, -1 if error
 * */
Int16 AIC3204_rset( Uint16 regnum, Uint16 regval )
{
    Uint8 cmd[2]; // command vector
    cmd[0] = regnum & 0x007F;       // first commmand is register which is ANDed with 7-bit Device Address mask
    cmd[1] = regval;                // next command is 8-bit data to be put in register address

    return ezdsp5535_I2C_write( AIC3204_I2C_ADDR, cmd, 2 ); // returns -1 if error has happened
}


/* Function for enabling use of the AIC3204 codec */  

void aic3204_hardware_init(void)
{
 	SYS_EXBUSSEL |= 0x0020;  // Select A20/GPIO26 as GPIO26
	ezdsp5535_GPIO_init();
	ezdsp5535_GPIO_setDirection(GPIO26, GPIO_OUT);
	ezdsp5535_GPIO_setOutput( GPIO26, 1 );    // Take AIC3204 chip out of reset
	ezdsp5535_I2C_init( );                    // Initialize I2C communication
	ezdsp5535_wait( 100 );  // Wait for 100 cycles 
}

/* Function for disabling use of the AIC3204 codec */

void aic3204_disable(void)
{
    AIC3204_rset( 1, 1 );                   // Reset codec by setting register 1 to value 1
  	ezdsp5535_GPIO_setOutput( GPIO26, 0 ); // Put AIC3204 into reset
    I2S2_CR = 0x00; // reset i2s by setting i2s serializer control register to zeroes
}

/* Function for reading value from codec
 * INPUT
 * left_input: pointer to variable for storing left input
 * right_input: pointer to variable for storing right input
 * */

void aic3204_codec_read(Int16* left_input, Int16* right_input)
{
	volatile Int16 dummy;
	
	counter1 = 0; // monitoring real-time operation
	
	/* Read Digital audio inputs */
    while(!(I2S2_IR & RcvR) ) 			// while no interrupt flag register and no 
    {
    	counter1++; // Wait for receive interrupt
    }	
	
    *left_input = I2S2_W0_MSW_R;     	// Read Most Significant Word of first channel
     dummy = I2S2_W0_LSW_R;             // Read Least Significant Word (ignore) 
    *right_input = I2S2_W1_MSW_R;       // Read Most Significant Word of second channel
     dummy = I2S2_W1_LSW_R;             // Read Least Significant Word of second channel (ignore)
 	        
}

void aic3204_codec_read_MONO(Int16* right_input,  Int16* left_input,  Int16 currentEntry)
{
	volatile Int16 dummy;
	Int16 localCounter = 0;
	counter1 = 0; // monitoring real-time operation
	
	// Read Digital audio inputs 
    while(!(I2S2_IR & RcvR) ) 			// while no interrupt flag register and no 
    {
    	counter1++; // Wait for receive interrupt
    	//printf("%s \n", "HALLOOOO");
    	
    }	
	//printf("HERE \n");
    *(left_input+currentEntry) = I2S2_W0_MSW_R;     	// Read Most Significant Word of first channel
     dummy = I2S2_W0_LSW_R;             // Read Least Significant Word (ignore) 
    *(right_input+currentEntry) = I2S2_W1_MSW_R;       // Read Most Significant Word of second channel
     dummy = I2S2_W1_LSW_R;             // Read Least Significant Word of second channel (ignore)
 	//fprintf(fp, "%d \n", I2S2_W1_MSW_R);        
}

/* Function for writing data to codec
 * INPUT
 * left_output: pointer to variable for storing left output
 * right_output: pointer to variable for storing right output
 * */
 
void aic3204_codec_write(Int16 left_output, Int16 right_output)
{
	counter2 = 0;  // monitoring real-time operation
	
    while( !(I2S2_IR & XmitR) ) // while no interrupt flag register and no 
    {
   	counter2++; // Wait for transmit interrupt
    }	
	I2S2_W0_MSW_W = left_output;         // Left output most significant word
    I2S2_W0_LSW_W = 0;
    I2S2_W1_MSW_W = right_output;        // Right output most significant word
    I2S2_W1_LSW_W = 0;
}

