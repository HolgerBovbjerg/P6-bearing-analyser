//////////////////////////////////////////////////////////////////////////////
// * File name: hwafft.h
// *                                                                          
// * Description:  FFT Hardware Accelerator Function Prototypes. 
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

#ifndef __HWA_FFT_H__
#define __HWA_FFT_H__

#define FFT_FLAG        ( 0 )       /* HWA to perform FFT */
#define IFFT_FLAG       ( 1 )       /* HWA to perform IFFT */

#define SCALE_FLAG      ( 0 )       /* HWA to scale butterfly output */
#define NOSCALE_FLAG    ( 1 )       /* HWA not to scale butterfly output */

#define OUT_SEL_DATA    ( 0 )       /* indicates HWA output located in input data vector */
#define OUT_SEL_SCRATCH ( 1 )       /* indicates HWA output located in scratch data vector  */

#define DATA_LEN_8      ( 8 )       /* vector length (FFT or IFFT) is 8 */
#define DATA_LEN_16     ( 16 )      /* vector length (FFT or IFFT) is 16 */
#define DATA_LEN_32     ( 32 )      /* vector length (FFT or IFFT) is 32 */
#define DATA_LEN_64     ( 64 )      /* vector length (FFT or IFFT) is 64 */
#define DATA_LEN_128    ( 128 )     /* vector length (FFT or IFFT) is 128 */
#define DATA_LEN_256    ( 256 )     /* vector length (FFT or IFFT) is 256 */
#define DATA_LEN_512    ( 512 )     /* vector length (FFT or IFFT) is 512 */
#define DATA_LEN_1024   ( 1024 )    /* vector length (FFT or IFFT) is 1024 */


/*                                                                          */
/*  Function name: hwafft_br                                                */
/*  Description: Bit-reverses data vector.                                  */
/*  Parameters:                                                             */
/*      data: input -- data vector to be bit-reveresed                      */
/*      data_br: output -- bit-reversed version of data vector              */
/*      data_len: input -- length of input/output vectors                   */
/*                                                                          */
void hwafft_br(
    Int32 *data,   
    Int32 *data_br,
    Uint16 data_len
);

/*                                                                          */
/*  Function name: hwafft_8pts                                              */
/*  Description: Performs 8-point FFT/IFFT.                                 */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 8                         */
/*      scratch: input/output -- scratch vector, length 8                   */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_8pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_16pts                                             */
/*  Description: Performs 16-point FFT/IFFT.                                */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 16                        */
/*      scratch: input/output -- scratch vector, length 16                  */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_16pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_32pts                                             */
/*  Description: Performs 32-point FFT/IFFT.                                */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 32                        */
/*      scratch: input/output -- scratch vector, length 32                  */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_32pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_64pts                                             */
/*  Description: Performs 64-point FFT/IFFT.                                */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 64                        */
/*      scratch: input/output -- scratch vector, length 64                  */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_64pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_128pts                                            */
/*  Description: Performs 128-point FFT/IFFT.                               */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 128                       */
/*      scratch: input/output -- scratch vector, length 128                 */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_128pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_256pts                                            */
/*  Description: Performs 256-point FFT/IFFT.                               */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 256                       */
/*      scratch: input/output -- scratch vector, length 256                 */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_256pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_512pts                                            */
/*  Description: Performs 512-point FFT/IFFT.                               */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 512                       */
/*      scratch: input/output -- scratch vector, length 512                 */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_512pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);

/*                                                                          */
/*  Function name: hwafft_1024pts                                           */
/*  Description: Performs 1024-point FFT/IFFT.                              */
/*  Parameters:                                                             */
/*      data: input/output -- data vector, length 1024                      */
/*      scratch: input/output -- scratch vector, length 1024                */
/*      fft_flag: (0/1) determines whether FFT or IFFT performed            */
/*      scale_flag: (0/1) determines whether butterfly output divided by 2  */
/*  Return value: (0/1) determines whether output in data or scratch vector */
/*                                                                          */
Uint16 hwafft_1024pts(
    Int32 *data,
    Int32 *scratch,
    Uint16 fft_flag,
    Uint16 scale_flag
);


#endif
