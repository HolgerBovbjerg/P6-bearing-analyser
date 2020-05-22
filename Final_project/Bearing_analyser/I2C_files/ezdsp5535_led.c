#include "ezdsp5535_led.h"

/* Function for turning LED on
 * number: 0
 */
Int16 ezdsp5535_LED_on(Uint16 number)
{
	/*asm(" bset XF"); // Set LED register HIGH
	asm(" nop");
	asm(" nop");
	asm(" nop");
	asm(" nop");
	asm(" nop");*/

    return 0;
}

/* Function for turning LED off
 * number: 0
 */

Int16 ezdsp5535_LED_off(Uint16 number)
{
	/*asm(" bclr XF"); // clear LED register
	asm(" nop");
	asm(" nop");
	asm(" nop");
	asm(" nop");
	asm(" nop");*/

    return 0;
}

// Initialises all LEDs as off
Int16 ezdsp5535_LED_init( )
{
    /* Turn OFF all LEDs */
    return ezdsp5535_LED_off( 0 );
}
