//////////////////////////////////////////////////////////////////////////////
// * File name: configuration.h
// *                                                                          
// * Description:  Configurable project settings, Project definitions, and Buffer allocations.
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

#ifndef _CONFIGURATION_H_
#define _CONFIGURATION_H_


/* Select FFT length to be used */
#define FFT_8PTS				(8)
#define FFT_16PTS				(16)
#define FFT_32PTS				(32)
#define FFT_64PTS				(64)
#define FFT_128PTS				(128)
#define FFT_256PTS				(256)
#define FFT_512PTS				(512)
#define FFT_1024PTS				(1024)

#define FFT_LENGTH				FFT_1024PTS	// Copy and Paste FFT selection here


/* Select Filter to be used */
#define LPF_7_TAP				(7)			// Low-Pass Hamming Filter, 7-tap,	 Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_16PTS
#define LPF_15_TAP				(15)		// Low-Pass Hamming Filter, 15-tap,  Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_32PTS
#define LPF_31_TAP				(31)  		// Low-Pass Hamming Filter, 31-tap,  Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_64PTS
#define LPF_63_TAP				(63)		// Low-Pass Hamming Filter, 63-tap,  Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_128PTS
#define LPF_127_TAP				(127)		// Low-Pass Hamming Filter, 127-tap, Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_256PTS
#define LPF_255_TAP				(255)		// Low-Pass Hamming Filter, 255-tap, Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_512PTS
#define LPF_511_TAP				(511)		// Low-Pass Hamming Filter, 511-tap, Fs = 48KHz, Fc = 2KHz, Use FFT_LENGTH >= FFT_1024PTS

#define FILTER					LPF_511_TAP	// Copy and Paste Filter selection here 


/* Select Source to be used */
#define FROM_CODEC				(0)					//FROM_CODEC : 	Input from Codec
#define SIN1K_5K				(FROM_CODEC + 1)	//SIN1K_5K:		1KHz Sine Wave + 5K Sine Wave 
#define SIN1K					(SIN1K_5K + 1)		//SIN1K:		1KHz Sine Wave 
#define SIN5K					(SIN1K + 1)			//SIN5K:		5KHz Sine Wave  
#define SIN3K					(SIN5K + 1)			//SIN3K:		3KHz Sine Wave

#define SOURCE					SIN1K_5K	// Copy and Paste Source selection here	
 

/* Set DEBUG to 1 to create copies of the input buffers (called RcvXX_copy) before filtering */
/* Otherwise the DMA continuously overwrites input buffers while debugging */
/* Necessesary to debug the signal chain */
#define DEBUG 					(0)

/* Do not modify */
#define FILTER_LENGTH			FILTER
#define WINDOW_SIZE          	(FFT_LENGTH - FILTER_LENGTH + 1)		
#define SIM_BUFF_SIZE			(48*2) 

/***************************************************************************/

extern Int32 RcvL1[];
extern Int32 RcvR1[];
extern Int32 RcvL2[];
extern Int32 RcvR2[];

extern Int16 coeffs[];

extern Int16 Simulation[];

extern Int32 XmitL1[];
extern Int32 XmitR1[];
extern Int32 XmitL2[];
extern Int32 XmitR2[];

extern Int32 FilterOut[];

extern Int16 OverlapL[];
extern Int16 OverlapR[];

extern Int32 data_br_buf[];
extern Int32 scratch_buf[];
extern Int32 convolved_buf[]; 
extern Int32 coeffs_fft_buf[]; 

#if DEBUG || (SOURCE != FROM_CODEC)
	extern Int32 RcvL1_copy[]; 
	extern Int32 RcvL2_copy[]; 
	extern Int32 RcvR1_copy[]; 
	extern Int32 RcvR2_copy[]; 
#endif

#endif //_CONFIGURATION_H_
