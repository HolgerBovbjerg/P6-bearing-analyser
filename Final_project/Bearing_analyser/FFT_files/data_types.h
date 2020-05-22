//////////////////////////////////////////////////////////////////////////////
// * File name: data_types.h
// *                                                                          
// * Description: type definitions.
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

#ifndef __DATA_TYPES_H__
#define __DATA_TYPES_H__

#ifdef WIN32
#define restrict
#define Int40               Int64

typedef short               Int16;
typedef long                Int32;
typedef long long           Int64;
typedef unsigned short      Uint16;
typedef unsigned long       Uint32;
typedef unsigned long long  Uint64;
typedef float               Float32;
typedef double              Float64;

#else

#ifdef C55X
typedef short               Int16;
typedef long                Int32;
typedef long long           Int40;
typedef unsigned short      Uint16;
typedef unsigned long       Uint32;
typedef unsigned long long  Uint40;
typedef float               Float32;

#else /* C6x */
typedef short               Int16;
typedef int                 Int32;
typedef long                Int40;
typedef long long           Int64;
typedef unsigned short      Uint16;
typedef unsigned int        Uint32;
typedef unsigned long       Uint40;
typedef unsigned long long  Uint64;
typedef float               Float32;
typedef double              Float64;

#endif /* C55X */

#endif /* WIN32 */

#define SUCCESS     0
#define ERROR_I2S0_CONFIG       1
#define ERROR_I2S1_CONFIG       2
#define ERROR_I2S2_CONFIG       3
#define ERROR_I2S3_CONFIG       4
#define ERROR_DMA0_CONFIG       5
#define ERROR_DMA1_CONFIG       6
#define ERROR_DMA2_CONFIG       7
#define ERROR_DMA3_CONFIG       8

#define ERROR_DATA_I2S                  10
#define ERROR_DATA_DATA_PROCESS         11
#define ERROR_DATA_MMC_SD               12
#define ERROR_DATA_UART                 13
#define ERROR_DATA_USB                  14
#define ERROR_DATA_SRAM                 15
#define ERROR_DATA_NOR                  16



#endif /* __DATA_TYPES_H__ */
