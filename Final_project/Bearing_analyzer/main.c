//////////////////////////////////////////////////////////////////////////////
// * File name: main.c
// *                                                                          
// * Description: This file includes main() and system initialization funcitons.
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

//////////////////////////////////////////////////////////////////////////////
// * Change History:
// * May 11, 2010:                                                                          
// * BugFix: PLL_100M was undefined, which failed to configure the PLL when
// * running in stand-alone mode. PLL was set to 100MHz by GEL file when running                                                                          
// * from Code Composer.
//////////////////////////////////////////////////////////////////////////////

#define PLL_12M		0
#define PLL_98M		0
#define PLL_100M	1

#include <stdio.h>
#include <math.h>
//#include <complex>
#include "data_types.h"
#include "register_system.h"
#include "register_cpu.h"
#include "rtc_routines.h"
#include "i2s_routines.h"
#include "dma_routines.h"
#include "configuration.h"
#include "hwafft.h"
#include "filter_routines.h"
#include "FIR_HP_coeffs.h"
#include "TMS320.H"
#include "dsplib5535.h"
#include "LP_coeffs.h"
#include "HPcoeffs.h"
#include "MMA8451.h"


#include "pll.h"

// board device libraries
#include "aic3204.h"


void InitSystem(void);
void ConfigPort(void);

void PLL_98MHz(void);

void turnOnLED(void);
void turnOffLED(void);

Uint16 fFilterOn = 0;
Uint16 fBypassOn = 1;
Uint16 clearOverlaps = 1;

extern void AIC3204_init(void);
extern Uint16 CurrentRxL_DMAChannel;
extern Uint16 CurrentRxR_DMAChannel;
extern Uint16 CurrentTxL_DMAChannel;
extern Uint16 CurrentTxR_DMAChannel;
extern Uint16 RunFilterForL;
extern Uint16 RunFilterForR;

Int16 dummy1;  	// Dummy variable for loading data from unused analog channel on codec


//------------	START OF CODE WRITTEN BY GR643	--------------------------------------------------------------------------------------------------------------------------------------------------------------

void fft_create_datapoint_array(Int16 *real_array, Uint16 fft_length, Int16 *fft_pointer)
{
	Int16 i;

	for(i=0 ; i < fft_length;  i++)
	{
		
		*(fft_pointer+(i*2)) = *(real_array+i);
		*(fft_pointer+(i*2)+1) = 0;
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//	------------------- THE FUNCTION BELOW IS CALCULATING THE RMS VALUE OF THE SIGNAL, BY ADDING EACH SAMPLE, DIVIDING BY THE LENGTH AND FINDING THE SQUAREROOT OF THIS
Int16 RMS(Int16 *data, Int16 length)
{
	Int16 i;
	Int32 intermediateResult = 0;
	
	for(i = 0; i < length; i++)
	{		
			intermediateResult = intermediateResult + ((Int32)*(data+i))*((Int32)*(data+i));
	}

	
	intermediateResult = intermediateResult/length;
	
	intermediateResult = sqrt(intermediateResult);
	
	return (Int16)intermediateResult;
}

// ------------------------ THE FUNCTION BELOW IS READING A SAMPLE FROM THE ACCELEROMETER EVERY TIME THE FOR LOOP IS CALLED
void codecRead(Int16 *real, Int16 sampleLength){
	Int16 i = 0;
	ezdsp5535_waitusec(250000);
	for(i = 0; i < sampleLength; i++){
		 aic3204_codec_read_MONO(&real[0], &dummy1,i);	
		 
	}
}
// ------------------------ THE FUNCTION BELOW IS DETECTING PEAKS AND RETURNING THE NUMBER OF PEAKS DETECTED
Int16 peakDetect(Int16 *data,Int16 *peakArray, Int16 length, Int16 limit)
{
	Int16 i;
	Int16 max = 0;
	Int16 peakPosition;
	Int16 nrPeaks = 0;
	Int16 fallingEdge = 0;
	Int16 oldEdge = 0;
	
	for(i = 0; i < length; i++)
	{
		if (*(data+i) > limit)
		{
			fallingEdge = 1;
			if(max < *(data+i))
			{
				max = *(data+i);
				peakPosition = i;
			}
		} else {
			fallingEdge = 0;
		}
		
		if (fallingEdge == 0 && oldEdge == 1)
		{
			*(peakArray+nrPeaks) = peakPosition;
			max = 0;
			nrPeaks++;
		}
		oldEdge = fallingEdge;
	}
	
	return nrPeaks;
}
// ------------------- THE FUNCTION BELOW IS PRINTING ALL THE RELEVANT INFORMATION FROM THE SIGNAL PROCESSING INTO THE CONSOLE

void printErrorMessages(Int32 expBits, Int32 fractionBits, Int16 rms, Int16 HZ, Int16 peakF, Int16 crestEx, Int16 crestFra, Int16 maxV){
	printf("%s \n \n", "---------------- TIME DOMAIN ANALYSIS ------------------");
		
	printf("%s %d %s \n", "The shaft frequency is: ", HZ, "Hz");
	
	printf("%s %d %s \n", "The peak frequency is: ", peakF, "Hz");
	
	printf("%s %ld%s%ld \n \n","The shaft frequency to peak frequency ratio is:  ", expBits,".",fractionBits);
	
	printf("%s %d%s%d \n", "The crest factor is: ", crestEx,".",crestFra);
	
	printf("%s %d \n", "The measured RMS value is: ", rms);
	
	printf("%s %d \n", "The highest peak: ", maxV);
	if(rms > 600) { printf("Bearing condition critical. Please do further inspection to locate the fault. Replacement of bad part is needed! \n \n");}
	else if (rms > 450 && rms < 600){ printf("Bearing condition mediocre. Consider changing the bearing \n \n");}
	else if (rms < 450){ printf("Bearing condition good. No further action needed \n \n");}
		
	printf("%s \n \n", "-------------- END OF TIME DOMAIN ANALYSIS -------------");
	
	printf("%s \n \n", "---------------- FREQUENCY DOMAIN ANALYSIS ------------------");
	
	printf("%s \n \n", "-------------- END OF FREQUENCY DOMAIN ANALYSIS -------------");

}
// --------------------- THE FUNCTION BELOW IS USED TO FIND THE ABSOLUTE VALUE OF EACH FFT ENTRY
void calculate_abs(Int16 real, Int16 imag, Int32 *absolute_ptr, Int16 current_entry){
	Int32 real_squared = 0;
	Int32 imag_squared = 0;
	Int32 scaling = 1;
	
	real_squared = (real/scaling)*(real/scaling);
	imag_squared = (imag/scaling)*(imag/scaling);
	
	*(absolute_ptr+current_entry) = sqrt(real_squared+imag_squared);
}


// -------------------- THE FUNCTION BELOW IS USED TO CALCULATE THE RATIO BETWEEN SHAFT- AND PEAK FREQUENCY
Int32 peaksPerRev(Int16 peaks, Int16 rpm){
	Int32 secondsPerMeas = 170; // 0,17*1000
	Int32 Hz = rpm/60;
	Int32 revPerSampling = ((Hz*secondsPerMeas)); // Measured revolutions
	Int32 peakFreq = revPerSampling/(Int32)peaks; // Revolution/peak
	if (peaks == 0) return 0;
	else return peakFreq;
}

#pragma DATA_SECTION(data_br_buf,"data_br_buf");	//Kommando der placere arrayet med bit reversed pladser et bestemt sted
#pragma DATA_ALIGN(data_br_buf,2048);			//-||-
Int32 data_br_buf[1024];						//Array der har sine indgange bit reversed

#pragma DATA_SECTION(scratch_buf,"scratch_buf");	//Kommando der placere arrayet med bit reversed pladser et bestemt sted
#pragma DATA_ALIGN(scratch_buf,2048);			//-||-
Int32 scratch_buf[1024];						//Array der indeholder bare reele og imaginære værdier, men indgangende har skiftet plads med bit reverse
Int32 absolute_value[1024];

void main(void) //main
{			
	Int16 signal_buffer[9216];							// Array containing the data used for signal processing
	Int16 rpm = 0;										// Varible for storing the rpm of the motor
	Int16 nrOfPeaks;									// Varible for storing the number of peaks detected in a sampling
	Int16 peakIndices[30];

	Int16 dBuffer[121+2];								// Array used in filter functions for storing coefficients
	Int16 *dBufferer_ptr = &dBuffer[0];					// Pointer to the filter coefficients

	Int16 fft_datapoints[1024*2];						// Array containing imaginary and real parts of the time signal
	Int16 i = 0;										// Variable used for counting in for loops
	Int16 real_freq[1024];								// Array containing real parts of the FFT
	
	Int32 *fft_output_location;							// Stores the memory location for ther output of the FFT
	const Uint16 fft_length = 1024;						// Lenght of the FFT
	Uint16 fft_save_location;	

	Int16 maxValue = 0;									// Variable for storing the highest detected peak
	Int16 rmsValueRaw = 0;								// Variable for storing the RMS value of the time signal
	Int16 CrestFactor = 0;								// Variable for storing the fixed point value crest factor 
	
	Int32 peakFreq = 0;									// Variable for storing the freequency of detected peaks

	Int32 fractionBits = 0;								// Varible for storing the fraction bits of the peak frequency
	Int32 expBits = 0;									// Varible for storing the exp bits of the peak frequency
	
	Int16 crestFrac = 0;								// Varible for storing the fraction bits of the crest factor
	Int16 crestExp = 0; 								// Varible for storing the exp bits of the crest factor
	
	inits(); 											// Function for setting up peripherals on DSP
	
	


	for(i = 0; i < 1; i++){								// For loop determining how many times the program will run
//		------------------------	DATA SAMPLING	-------------------------------
		
		requestFromArduino(0); 							// Sending I2C command to arduino telling to start counting revolutions
		codecRead(&signal_buffer[1024], 2048);			// Reading 2048 samples from codec
		codecRead(&signal_buffer[3072], 2048);			//  - . - 
		codecRead(&signal_buffer[5120], 2048);			//  - . - 	
		codecRead(&signal_buffer[7168], 2048);			//  - . - 
		requestFromArduino(1); 							// Sending I2C command to arduino telling to stop counting revolutions 
		rpmReadI2C(&rpm);								// Reading the RPM through I2C from arduino

														// The for loop below is accounting for a constant offset on the samples
		for(i = 0; i < 2048; i++)
		{
			signal_buffer[1024+i] = signal_buffer[1024+i] + 360;
			signal_buffer[3072+i] = signal_buffer[3072+i] + 180;
			signal_buffer[5120+i] = signal_buffer[5120+i] + 60;
		}
		
//	-------------------------------		DOWNSAMPLING	--------------------------------		
		for(i = 0; i < 1024; i++){
			signal_buffer[0+i] = signal_buffer[1024+i*8];		// Downsampling from 8192 to 1024 samples
		}
		
// 	-------------------------------		CALCULATING RMS --------------------------------	
		rmsValueRaw = RMS(&signal_buffer[0], fft_length);		// Calling function to calculate the RMS value of the signal
		
		
// 	-------------------------------		ENVELOPE ALGORITHM	----------------------------

//							------------  HIGH PASS FILTERING	-------------
		fir2(&signal_buffer[0], HP_coeffs, &signal_buffer[1024], dBufferer_ptr, 1024, 121);		// Function for doing the high pass FIR filter


//							------------  ABSOLUTE VALUE	-------------									
														// The for loop below is making negative samples positive as part of the envelope algorithm
		for(i = 1024; i < 2048; i++){
			if(signal_buffer[i] < 0)
			{
				signal_buffer[i] = signal_buffer[i] * -1;
			}	
		}

//							------------  LOW PASS FILTERING	-------------		
		fir2(&signal_buffer[1024], lowpass, &signal_buffer[2048], dBufferer_ptr, 1024, 121); 	// Function for doing the low pass FIR filter


//							------------  CALCULATING PEAK FREQUENCY	-------------
	nrOfPeaks = peakDetect(&signal_buffer[2048], &peakIndices[0], fft_length, rmsValueRaw*3);	// Calculating the number of peaks measured
	
	peakFreq = peaksPerRev(nrOfPeaks, rpm);														// Calculates the frequency of the peaks multiplied by 1000

							// The 3 lines below is calculating the floating point value of the peak frequency

		fractionBits = peakFreq % 1000;		// Finds the fraction bits by dividing by 1000 and saving the remainder
		peakFreq /=1000;
		expBits = peakFreq % 10;			// Finds the exp bits by dividing by 10 and saving the remainder


//							------------  FINDING THE BIGGEST PEAK	-------------	
							// The for loop below is finding the value of the highest peak measured
	for(i = 0; i < 1024; i++){
			if(signal_buffer[0+i] > maxValue){
				maxValue = signal_buffer[0+i];
			}
		}
//							------------ FINDING THE CREST FACTOR 	--------------
	CrestFactor = (10*maxValue)/rmsValueRaw;		// Calculating the crest factor multiplied by 10 to ensure a fraction of 1 decimal
	crestFrac = CrestFactor % 10;					// Calculating the fractional part of the crest factor
	crestExp = CrestFactor / 10; 					// Calculating the exp part of the crest factor
	
//	----------------------------------- HARDWARE ACCELERATED FFT	-----------------------------------

//						------------- CREATING INPUT ARRAY ------------
	fft_create_datapoint_array(&signal_buffer[2048], fft_length, &fft_datapoints[0]); // Function for combining the real and negative parts of the samples into a single array

//						------------- BIT REVERSING THE INPUTS -----------------------
	hwafft_br((Int32 *)&fft_datapoints[0], &data_br_buf[0],fft_length); // Function for bit reversing the samples to make them usable in a FFT
	
//						------------- PERFORMING FFT ---------------------------
	fft_save_location = hwafft_1024pts(&data_br_buf[0], &scratch_buf[0],0,1); // Function for calling the hardware FFT

// 	-------------------------------	READING OUTPUT OF FFT ---------------------------------------
	if(fft_save_location == 17857){ 								// If 17857 is returned the FFT is not executed
		printf("FFT NOT executed correctly");}						
	else {															// Finding the location of the data created by the FFT
		if(fft_save_location == 0){ 								
			fft_output_location = &data_br_buf[0];}
		else if(fft_save_location == 1){ 							
			fft_output_location = &scratch_buf[0];} 
		else {printf("Output array MIA \n");}						
	

// 	-------------------------------	SEPERATING FFT OUTPUT INTO REAL AND IMAGINRAY PARTS -----------------------		
	
	for(i = 0; i < fft_length; i++){ 								//For loop splitting up the Int32 array into two Int16 arrays representing real and imaginary part of FFT
	
		signal_buffer[i+4096] = (*(fft_output_location+i+1)) & 0x0000FFFF; 	// Saving the imaginary part
		real_freq[i] = (*(fft_output_location+i)) >> 16; 					// Saving the real part
						
		calculate_abs(real_freq[i], signal_buffer[i+4096], &absolute_value[0], i); // Calculating the absolute value of the corresponding real and imaginary part
		}

	}



	printErrorMessages(expBits, fractionBits, rmsValueRaw, rpm/60, nrOfPeaks*6, crestExp, crestFrac, maxValue);		// Function for displaying the messages related to the health of the bearing
  printf("----- PROGRAM HAS TERMINATED ----- \n");
}
}
//----------END OF CODE WRITTEN BY GR643 ----------------------------------------------------------------------------------------------------------------------------------------------------------------

void PLL_98MHz(void)
{
	// PLL set up from RTC
    // bypass PLL
    CONFIG_MSW = 0x0;

#if (PLL_100M ==1)
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0000;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x82FA;
    
#elif (PLL_12M ==1)
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0200;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x82ED;
#elif (PLL_98M ==1)    
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0000;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x82ED;
    
#endif
    while ( (PLL_CNTL3 & 0x0008) == 0);
    // Switch to PLL clk
    CONFIG_MSW = 0x1;
}

void InitSystem(void)
{
	Uint16 i;
	// PLL set up from RTC
    // bypass PLL
    CONFIG_MSW = 0x0;

#if (PLL_100M ==1)
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0000;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x82FA;
    
#elif (PLL_12M ==1)
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0200;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x82ED;
#elif (PLL_98M ==1)    
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0000;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x82ED;

#elif (PLL_40M ==1)        
    PLL_CNTL2 = 0x8000;
    PLL_CNTL4 = 0x0300;
    PLL_CNTL3 = 0x0806;
    PLL_CNTL1 = 0x8262;    
#endif

    while ((PLL_CNTL3 & 0x0008) == 0);
    // Switch to PLL clk
    CONFIG_MSW = 0x1;

	// clock gating
	// enable all clocks
    IDLE_PCGCR = 0x0;
    IDLE_PCGCR_MSW = 0xFF84;
    

	// reset peripherals
    PER_RSTCOUNT = 0x02;
    PER_RESET = 0x00fb;    
    for (i=0; i< 0xFFF; i++);
}

void ConfigPort(void)
{
    Int16 i;
    //  configure ports
    PERIPHSEL0 = 0x6900;        // parallel port: mode 6, serial port1: mode 2 

    for (i=0; i< 0xFFF; i++);
}

/*
void SYS_GlobalIntEnable(void)
{
    asm(" BIT (ST1, #ST1_INTM) = #0");
}
void SYS_GlobalIntDisable(void)
{
    asm(" BIT (ST1, #ST1_INTM) = #1");
}
*/
void turnOnLED(void)
{
    Uint16 temp;
    
    temp = ST1_55;
    if((temp&0x2000) == 0)
    {
        // turn on LED
        temp |= 0x2000;
        ST1_55 =temp;
    }
    
}

void turnOffLED(void)
{
    Uint16 temp;
    
    temp = ST1_55;
    if((temp&0x2000) != 0)
    {
        // turn off LED
        temp &=0xDFFF;
        ST1_55 =temp;
    }
}