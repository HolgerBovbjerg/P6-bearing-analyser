#include "ezdsp5535.h"
#include "ezdsp5535_gpio.h"

// Initialise GPIO

Int16 ezdsp5535_GPIO_init()
{
    return 0;
}

/* Function for setting GPIO port direction
 * number: GPIO number
 * direction: 1 for input, 0 for output
 * */
Int16 ezdsp5535_GPIO_setDirection( Uint16 number, Uint16 direction )
{
	
	// Resolve GPIO bank number
    Uint32 bank_id = ( number >> 4);
    
    // Resolve bank pin number
    Uint32 pin_id  = ( 1 << ( number & 0xF ) );
    
    // setup pin for input or output
    if (bank_id == 0)
        if ((direction & 1) == GPIO_IN)
    	    SYS_GPIO_DIR0 &= ~pin_id;
        else
            SYS_GPIO_DIR0 |= pin_id;

    if (bank_id == 1)
        if ((direction & 1) == GPIO_IN)
    	    SYS_GPIO_DIR1 &= ~pin_id;
        else
            SYS_GPIO_DIR1 |= pin_id;

    return 0;
}

/* Function for set output HIGH (1) or LOW (0)
 * number: GPIO number
 * output: 1 or 0
 */

Int16 ezdsp5535_GPIO_setOutput( Uint16 number, Uint16 output )
{
	// Resolve GPIO bank number
    Uint32 bank_id = ( number >> 4);
    
    // Resolve bank pin number
    Uint32 pin_id  = ( 1 << ( number & 0xF ) );
	
	
	// Write output to GPIO bank
    if (bank_id == 0)
        if ((output & 1) == 0)
    	    SYS_GPIO_DATAOUT0 &= ~pin_id;
        else
            SYS_GPIO_DATAOUT0 |= pin_id;

    if (bank_id == 1)
        if ((output & 1) == 0)
    	    SYS_GPIO_DATAOUT1 &= ~pin_id;
        else
            SYS_GPIO_DATAOUT1 |= pin_id;

    return 0;
}

/* Function for reading I/O pin
 * number: GPIO number 
 */

Int16 ezdsp5535_GPIO_getInput( Uint16 number )
{
    Uint32 input;
	// Resolve GPIO bank number
    Uint32 bank_id = ( number >> 4);
    // Resolve bank pin number
    Uint32 pin_id  = ( 1 << ( number & 0xF ) );
	
	// Save GPIO data from GPIO pin
    if (bank_id == 0)
        input = (SYS_GPIO_DATAIN0 >> pin_id) & 1;
    if (bank_id == 1)
        input = (SYS_GPIO_DATAIN1 >> pin_id) & 1; 

    return input;
}
