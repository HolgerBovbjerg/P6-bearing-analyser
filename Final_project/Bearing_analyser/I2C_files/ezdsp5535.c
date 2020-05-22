#include "ezdsp5535.h"

/* ------------------------------------------------------------------------ *
 *                                                                          *
 *  ezdsp5535_wait( delay )                                                *
 *                                                                          *
 *      Wait in a software loop for 'x' delay                               *
 *                                                                          *
 * ------------------------------------------------------------------------ */

void ezdsp5535_wait( Uint32 delay )
{
    volatile Uint32 i;
    for ( i = 0 ; i < delay ; i++ ){ };
}

/* ------------------------------------------------------------------------ *
 *                                                                          *
 *  _waitusec( usec )                                                       *
 *                                                                          *
 *      Wait in a software loop for 'x' microseconds                        *
 *                                                                          *
 * ------------------------------------------------------------------------ */

void ezdsp5535_waitusec( Uint32 usec )
{
    ezdsp5535_wait( (Uint32)usec * 8 );
}

/* ------------------------------------------------------------------------ *
 *                                                                          *
 *  ezdsp5535_init( )                                                      *
 *                                                                          *
 *      Setup board board functions                                         *
 *                                                                          *
 * ------------------------------------------------------------------------ */

Int16 ezdsp5535_init( )
{
    /* Enable clocks to all peripherals */
    SYS_PCGCR1 = 0x0000;
    SYS_PCGCR2 = 0x0000;
	
    return 0;
}
