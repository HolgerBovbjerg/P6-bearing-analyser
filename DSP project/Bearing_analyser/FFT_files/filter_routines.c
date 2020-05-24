//////////////////////////////////////////////////////////////////////////////
// * File name: filter_routines.c
// *                                                                          
// * Description: This file includes the FFT Filter function pointer and FFT filtering functions. 
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


#include "data_types.h"
#include "register_cpu.h"
#include "filter_routines.h"
#include "configuration.h"
#include "hwafft.h"

/* Select the appropriate hwafft function call depending on the FFT_LENGTH */
/* hwafft functions are defined in hwafft.asm and located in ROM (see c5505.cmd)*/

#if FFT_LENGTH == FFT_8PTS		
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_8pts;

#elif FFT_LENGTH == FFT_16PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_16pts;

#elif FFT_LENGTH == FFT_32PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_32pts;

#elif FFT_LENGTH == FFT_64PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_64pts;

#elif FFT_LENGTH == FFT_128PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_128pts;

#elif FFT_LENGTH == FFT_256PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_256pts;

#elif FFT_LENGTH == FFT_512PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_512pts;

#elif FFT_LENGTH == FFT_1024PTS	
	Uint16 (*Hwafft_Func)(Int32 *, Int32 *, Uint16 , Uint16) = &hwafft_1024pts;

#endif


void Zero_Pad_Inputs(void)
{
	Uint16 i;
	// Zero-pad the input buffers in advance (zeros will not be overwritten)
	for(i=0; i <FFT_LENGTH; i++)
	{
		RcvL1[i] = 0;
		RcvL2[i] = 0;
		RcvR1[i] = 0;
		RcvR2[i] = 0;
		#if DEBUG || (SOURCE != FROM_CODEC)
			RcvL1_copy[i] = 0;
			RcvL2_copy[i] = 0;
			RcvR1_copy[i] = 0;
			RcvR2_copy[i] = 0;
		#endif
	}
}

void Clear_COLA_Overlaps(void)
{
	Uint16 i;
	// zero COLA Overlap buffers
	for(i=0; i< (FFT_LENGTH - WINDOW_SIZE); i++)
	{
		OverlapL[i] = 0;
		OverlapR[i] = 0;
	}
}

/* FFT_Coeffs: Calculate and store the FFT of the filter coefficients */
void FFT_Coeffs()
{
	Uint16 i, fft_flag, scale_flag, out_sel;
	Int32 *scratch, *data_br, *coeffs_fft, coeffSum;

	scratch = scratch_buf;			
	data_br = data_br_buf;
	coeffs_fft = coeffs_fft_buf;

	// put coeffs into re|im 32-bit words
	// zero-pad to FFT_LENGTH
	coeffSum = 0;	// make sure sum <= 1.0 for COLA properties
	for(i=0; i<FFT_LENGTH; i++)
	{
		if(i<FILTER_LENGTH)
		{
			scratch[i] = ((Int32)coeffs[i] <<16); 
			coeffSum += coeffs[i];					
		}
		else
		{
			scratch[i] = 0;
		}
	}

	// FFT and store in coeffs_fft[]
	fft_flag = FFT_FLAG;
    scale_flag = NOSCALE_FLAG;  //why is this necessary
    				
	hwafft_br(scratch, data_br, FFT_LENGTH);  // bit-reverse zero-padded coefficients

    out_sel = (*Hwafft_Func)(data_br, coeffs_fft, fft_flag, scale_flag); // perform FFT 
	if(out_sel == OUT_SEL_DATA)
	{
    	buff_copy32(data_br, coeffs_fft, FFT_LENGTH);
	}
}

/* FFT_Filter: 
 * FFT the current window of samples
 * Complex Multiply FFT output with FFT of filter coefficients
 * (Multiplication in Frequency Domain = Convolution in Time Domain
 * IFFT Complex Product to obtain filtered window plus ringing
 */ 
Uint16 FFT_Filter(Int32 *In, Int32 *Out)
{
    Int32 *data_br, *convolved, *scratch, *coeffs_fft;
    Uint16 fft_flag, scale_flag, out_sel, i;

    data_br = data_br_buf;
	convolved = convolved_buf;
    scratch = scratch_buf;
	coeffs_fft = coeffs_fft_buf;
		
	// FFT Input Samples:
    fft_flag = FFT_FLAG;
    scale_flag = SCALE_FLAG; 

	hwafft_br(In, data_br, FFT_LENGTH);  // bit-reverse input data
    
    out_sel = (*Hwafft_Func) (&data_br[0], &scratch[0], fft_flag, scale_flag); // perform FFT 
	if(out_sel == OUT_SEL_DATA)
    	scratch = data_br;
	//else scratch = scratch
        
    // Convolution in Time domain = Multiplication in Frequency Domain
    // Vector multiply Complex Real and Imag
	for (i = 0; i < FFT_LENGTH; i++)
	{
		convolved[i] = CPLX_Mul(scratch[i], coeffs_fft[i]);
	}
                    
    // IFFT:
    fft_flag = IFFT_FLAG;
    scale_flag = NOSCALE_FLAG; 			
	
    hwafft_br(convolved, data_br, FFT_LENGTH);  // bit-reverse input data

    out_sel = (*Hwafft_Func) (&data_br[0], &Out[0], fft_flag, scale_flag); // perform IFFT 

    if(out_sel == OUT_SEL_DATA)
	{
    	buff_copy32(data_br, Out, FFT_LENGTH);
		return 1;
	}
	return 0;
}

/* COLA_Output: Constant Overlap and Add (COLA)
 * The WINDOW_SIZE is smaller than FFT_LENGTH, and the FilterOut contains ringing
 * 1) Output to codec the first WINDOW_SIZE samples added with the previous Overlap
 * 2) Save the remaining (FFT_LENGTH - WINDOW_SIZE) samples to the Overlap buffer.
 * 3) Add these overlapping samples to the first samples of next window.
 */   
void COLA_Output(Int32 *FilterOut, Int16 *Overlap, Int32 *Xmit)
{
	Uint16 i, Overlap_Len;
	Int16 FilterOut_Re, Overlap_Re;

	Overlap_Len = (FFT_LENGTH - WINDOW_SIZE);
	
	for(i=0;i<Overlap_Len; i++)
	{
		FilterOut_Re = (Int16)(FilterOut[i] >> 16);		//Keep only real parts of the sample
		Overlap_Re = Overlap[i];
		Xmit[i] = ((Int32)_sadd(FilterOut_Re,Overlap_Re)<<16);	// saturating add, shift into Real part of Xmit[]
		
		Overlap[i] = (Int16)(FilterOut[i + WINDOW_SIZE] >> 16);
	}
	for(i=Overlap_Len; i<WINDOW_SIZE; i++)
	{
		Xmit[i] = (FilterOut[i]&0xFFFF0000);			// Cancel imaginary part of sample
	}
	return;
}


Int32 CPLX_Mul(Int32 op1, Int32 op2)
{
	Int16 op1_r, op1_i, op2_r, op2_i;
	Int32 op1_op2_r, op1_op2_i;
	Int16 op1_op2_r16, op1_op2_i16;
	Int32 cplx_prod;

	// Mask data for real and imag data = (real:imag)
	op1_r = op1 >> 16;
	op1_i = op1 & 0x0000FFFF;
	op2_r = op2 >> 16;
	op2_i = op2 & 0x0000FFFF;

	op1_op2_i	= (Int32)op1_r*op2_i + (Int32)op1_i*op2_r;
	op1_op2_r	= (Int32)op1_r*op2_r - (Int32)op1_i*op2_i;
	
	op1_op2_i16 = (Int16)(op1_op2_i >> 15);
	op1_op2_r16 = (Int16)(op1_op2_r >> 15);

	cplx_prod = (((Int32)op1_op2_r16 & 0x0000FFFF)<< 16);
	cplx_prod = cplx_prod | ((Int32)op1_op2_i16 & 0x0000FFFF);

	return cplx_prod;
}

void buff_copy16(Int16 *input, Int16 *output, Int16 size)
{
	Int16 i;
	
	for(i =0; i<size; i++)
	{
		*(output + i) = *(input +i);
	}
	
}

void buff_copy32(Int32 *input, Int32 *output, Int32 size)
{
	Int16 i;
	
	for(i =0; i<size; i++)
	{
		*(output + i) = *(input +i);
	}
	
}

