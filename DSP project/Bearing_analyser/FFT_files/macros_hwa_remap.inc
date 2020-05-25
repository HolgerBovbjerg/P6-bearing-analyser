;//////////////////////////////////////////////////////////////////////////////
;// * File name: macros_hwa_remap.inc
;// *                                                                          
;// * Description:  This file includes macros to select a coprocessor.
;// *                                                                          
;// * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/ 
;// *                                                                          
;// *                                                                          
;// *  Redistribution and use in source and binary forms, with or without      
;// *  modification, are permitted provided that the following conditions      
;// *  are met:                                                                
;// *                                                                          
;// *    Redistributions of source code must retain the above copyright        
;// *    notice, this list of conditions and the following disclaimer.         
;// *                                                                          
;// *    Redistributions in binary form must reproduce the above copyright     
;// *    notice, this list of conditions and the following disclaimer in the   
;// *    documentation and/or other materials provided with the                
;// *    distribution.                                                         
;// *                                                                          
;// *    Neither the name of Texas Instruments Incorporated nor the names of   
;// *    its contributors may be used to endorse or promote products derived   
;// *    from this software without specific prior written permission.         
;// *                                                                          
;// *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     
;// *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       
;// *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR   
;// *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT    
;// *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,   
;// *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        
;// *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   
;// *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY   
;// *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT     
;// *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE   
;// *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    
;// *                                                                          
;//////////////////////////////////////////////////////////////////////////////

********************************************************************************
* *
*        Macros : *
*        _Hwa_no_remap *
*        _Hwa_remap_hwa0 *
*        _Hwa_remap_hwa1 *
*        _Hwa_remap_hwa2 *
*        _Hwa_remap_hwa3 *
*        _Hwa_remap_hwa4 *
*        _Hwa_remap_hwa5 *
*        _Hwa_remap_hwa6 *
* *
********************************************************************************

;*******************************************************************************
;                WRITE in HWA #7 *
;*******************************************************************************
; +-+-+-+-+-+-+-+-+ *
; |7|6|5|4|3|2|1|0|    STROBE_REG *
; +-+-+-+-+-+-+-+-+ *
;  1 1 1 1 1 1 1 0 -> Select hwa #0 -> PI *
;  1 1 1 1 1 1 0 1 -> Select hwa #1 -> DCT *
;  1 1 1 1 1 0 1 1 -> Select hwa #2 -> ME *
;  1 1 1 1 0 1 1 1 -> Select hwa #3 -> VIT *
;  1 1 1 0 1 1 1 1 -> Select hwa #4 -> MRC *
;  1 1 0 1 1 1 1 1 -> Select hwa #5 *
;  1 0 1 1 1 1 1 1 -> Select hwa #6 *
;  0 0 0 0 0 0 0 0 -> Select standard mode *
;  | *
;  --> operating mode bit *
;*******************************************************************************

;*******************************************************************************
; NO REMAPPING / STANDARD MODE IS USED *
;*******************************************************************************
_Hwa_no_remap    .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0x0                ; 00000000
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #0 *
;*******************************************************************************
_Hwa_remap_hwa0  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xfe               ; 11111110
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #1 *
;*******************************************************************************
_Hwa_remap_hwa1  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xfd               ; 11111101
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #2 *
;*******************************************************************************
_Hwa_remap_hwa2  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xfb               ; 11111011
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #3 *
;*******************************************************************************
_Hwa_remap_hwa3  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xf7               ; 11110111
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #4 *
;*******************************************************************************
_Hwa_remap_hwa4  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xef               ; 11101111
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #5 *
;*******************************************************************************
_Hwa_remap_hwa5  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xdf               ; 11011111
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm

;*******************************************************************************
; SELECT HWA #6 *
;*******************************************************************************
_Hwa_remap_hwa6  .macro

                        AC0 = #0x4                ; hwremap address
                        AC1 = #0xbf               ; 10111111
                        AC1 = copr(#0xff,AC0,AC1) ; write access
                 .endm
