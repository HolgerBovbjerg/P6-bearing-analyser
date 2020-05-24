#include "ezdsp5535_i2c.h"

static Int32 i2c_timeout = 0x7fff; // i2c timeout time 7fffh = 32767

/* Function for initialising i2c module */
Int16 ezdsp5535_I2C_init( )
{
    I2C_MDR = 0x0400;             // Reset I2C
    I2C_PSC   = 20;               // Configure prescaler for 12MHz
    I2C_CLKL  = 20;               // Configure clk LOW for 20kHz
    I2C_CLKH  = 20;               // Configure clk HIGH for 20kHz
    
    I2C_MDR   = 0x0420   ;        // Release from reset; Master, Transmitter, 7-bit address
    
    return 0;
}

/* Function for closing i2c communication */
Int16 ezdsp5535_I2C_close( )
{
    I2C_MDR = 0;                      // Reset I2C (mode register= 0)
    return 0;
}

/* Function for resetting i2c */

Int16 ezdsp5535_I2C_reset( )
{
    ezdsp5535_I2C_close( ); // Close communication
    ezdsp5535_I2C_init( ); // Initialise i2c module again
    return 0;
}

/* Function for writing to i2c address
 * i2c_addr: address of i2c device
 * data: pointer to data
 * len: length of data
 * */
Int16 ezdsp5535_I2C_write( Uint16 i2c_addr, Uint8* data, Uint16 len )
{
    Int32 timeout, i;

		//I2C_IER = 0x0000;
        I2C_CNT = len;                  // Set length
        I2C_SAR = i2c_addr;             // Set I2C slave address
        I2C_MDR = MDR_STT               // Set mode register start condition bit, 
                  | MDR_TRX				// transmitter mode bit, 
                  | MDR_MST				// master mode bit,	
                  | MDR_IRS				// i2c reset bit and
                  | MDR_FREE;			// emulation mode bit

        ezdsp5535_wait(10);              // Short delay of 10 cycles

        for ( i = 0 ; i < len ; i++ ) // for every bit of data to be sent
        {
            I2C_DXR = data[i];            // Write data to i2c data transmit register

            timeout = i2c_timeout; // set i2c timeout counter
            do
            {
	            if ( timeout-- < 0 ) // If timeout counter reached
	            {
	                ezdsp5535_I2C_reset( ); // reset i2c
	                return -1; // return error
	            }
            } while ( ( I2C_STR & STR_XRDY ) == 0 );// Wait for Tx Ready (i2c interrupt status register = STR_XRDY)
        }

        I2C_MDR |= MDR_STP;             // Generate STOP by setting i2c mode register stop bit

		ezdsp5535_waitusec(100); // wait for 100 microseconds

        return 0;

}

/* Function for writing to i2c address without stop condition. 
 * Used for REPEATED START CONDITION
 * i2c_addr: address of i2c device
 * data: pointer to data
 * len: length of data
 * */
Int16 ezdsp5535_I2C_write_SR( Uint16 i2c_addr, Uint8* data, Uint16 len )
{
    Int32 timeout, i;

		//I2C_IER = 0x0000;
        I2C_CNT = len;                  // Set length
        I2C_SAR = i2c_addr;             // Set I2C slave address
        I2C_MDR = MDR_STT               // Set mode register start condition bit, 
                  | MDR_TRX				// transmitter mode bit, 
                  | MDR_MST				// master mode bit,	
                  | MDR_IRS				// i2c reset bit and
                  | MDR_FREE;			// emulation mode bit

        ezdsp5535_wait(10);              // Short delay of 10 cycles

        for ( i = 0 ; i < len ; i++ ) // for every bit of data to be sent
        {
            I2C_DXR = data[i];            // Write data to i2c data transmit register

            timeout = i2c_timeout; // set i2c timeout counter
            do
            {
	            if ( timeout-- < 0 ) // If timeout counter reached
	            {
	                ezdsp5535_I2C_reset( ); // reset i2c
	                return -1; // return error
	            }
            } while ( ( I2C_STR & STR_XRDY ) == 0 );// Wait for Tx Ready (i2c interrupt status register = STR_XRDY)
        }

        //I2C_MDR |= MDR_STP;             // Generate STOP by setting i2c mode register stop bit

		ezdsp5535_waitusec(100); // wait for 100 microseconds

        return 0;

}



/* function for reading data from i2c device
 * addr: i2c address
 * data: pointer to variable for storing received data 
 * len: length of data
 * */
Int16 ezdsp5535_I2C_read( Uint16 i2c_addr, Uint8* data, Uint16 len )
{
    Int32 timeout, i;

    I2C_CNT = len;                    // Set i2c data count register to length
    I2C_SAR = i2c_addr;               // Set i2c slave address register to addr
    I2C_MDR = MDR_STT               // Set mode register start condition bit, 
              | MDR_MST				// master mode bit,	
              | MDR_IRS				// i2c reset bit and
              | MDR_FREE;			// emulation mode bit
    

    ezdsp5535_wait( 10 );            // Short delay

    for ( i = 0 ; i < len ; i++ ) // for every bit of data
    {
        timeout = i2c_timeout; // set i2c timeout counter

        //Wait for Rx Ready 
        do
        {
            if ( timeout-- < 0 ) // If timeout counter reached
            {
                ezdsp5535_I2C_reset( ); // reset i2c
                return -1; // return error
            }
        } while ( ( I2C_STR & STR_RRDY ) == 0 );// Wait for Rx Ready (i2c interrupt status = STR_RRDY)

        data[i] = I2C_DRR;            // Read data from i2c data receive register
    }

    I2C_MDR |= MDR_STP;               // Generate STOP by setting i2c mode register stop bit

	ezdsp5535_waitusec(10); // wait for 10 microseconds
    return 0;
}

