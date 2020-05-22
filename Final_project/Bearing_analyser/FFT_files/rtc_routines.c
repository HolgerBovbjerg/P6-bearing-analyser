//////////////////////////////////////////////////////////////////////////////
// * File name: rtc_routines.c
// *                                                                          
// * Description: This file includes RTC configuration functions and RTC ISR function.
// *                                                                          
// * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/ 
// *                                                                          
// *                                                                          
// *  Redistribution and use in source and binary forms, with or without      
// *  modification, are permitted provided that the following conditions      
// *  are met:                                                                
// *                                                                          
// *    Redistributions of source code must retain the above copyright        
// *    notice, this list of conditions and the following disclaimer.         
// *                                                                          
// *    Redistributions in binary form must reproduce the above copyright     
// *    notice, this list of conditions and the following disclaimer in the   
// *    documentation and/or other materials provided with the                
// *    distribution.                                                         
// *                                                                          
// *    Neither the name of Texas Instruments Incorporated nor the names of   
// *    its contributors may be used to endorse or promote products derived   
// *    from this software without specific prior written permission.         
// *                                                                          
// *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     
// *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       
// *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR   
// *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT    
// *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,   
// *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        
// *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   
// *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY   
// *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT     
// *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE   
// *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    
// *                                                                          
//////////////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include "data_types.h"
#include "register_cpu.h"
#include "register_rtc.h"
#include "rtc_routines.h"


Uint16 Count_RTC =0;
extern Uint16 fFilterOn;
extern Uint16 fBypassOn;
extern Uint16 clearOverlaps;

void enable_rtc_second_int(void)
{

    RTC_CTR = 1;
    RTC_INT = 0x0002;           // enalbe  second int
}

void reset_RTC(void)
{
    Uint16 temp;
    
    temp = RTC_CTR;
    RTC_CTR =0;             // disable interrupt
    
    RTC_MSEC = 0x00;
    RTC_SEC =0x00;
    RTC_MIN =0x00;
    RTC_HOUR =0x00;
    RTC_DAY =0x01;
    RTC_MONTH=0x02;
    RTC_YEAR=0x2010;           // 2009/3/31, 23h58m55s
    
    RTC_UPDT = 0x8000;      // update time
    
    while(RTC_UPDT != 0);
    
    RTC_CTR = temp;            // recover interrupt
}



interrupt void RTC_Isr(void)
{
    Uint16 temp;

	// clear RTC int flag
    IFR1 = 0x0004;
    
    temp =RTC_STAT;
    RTC_STAT = temp;

	Count_RTC ++;
	if(Count_RTC ==5)
	{
	    Count_RTC =0;
	    
	    if(fFilterOn ==1)
	    {
	        fFilterOn =0;
	        fBypassOn =1;
			clearOverlaps =1;
	    }
	    else
	    {
	        fFilterOn =1;
	        fBypassOn =0;

	    }
	}
}

