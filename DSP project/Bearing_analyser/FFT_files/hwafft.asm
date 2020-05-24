;//////////////////////////////////////////////////////////////////////////////
;// * File name: hwafft.asm
;// *                                                                          
;// * Description:  This file includes functions that send copr commands to the FFT hardware accelerator.
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

                .mmregs
                
                .def _hwafft_br
                .def _hwafft_8pts
                .def _hwafft_16pts
                .def _hwafft_32pts
                .def _hwafft_64pts
                .def _hwafft_128pts
                .def _hwafft_256pts
                .def _hwafft_512pts
                .def _hwafft_1024pts

                .include "lpva200.inc"
                .include "macros_hwa_remap.inc"

                .C54CM_off
                .CPL_off
                .ARMS_off
 

;******************************************************************************
;   Define constants
;******************************************************************************
OUT_SEL_DATA    .set    0       ; indicates HWA output located in input data vector
OUT_SEL_SCRATCH .set    1       ; indicates HWA output located in scratch data vector

; Define HWAFFT instructions
HWAFFT_INIT     .set    0x00
HWAFFT_SINGLE   .set    0x01
HWAFFT_DOUBLE   .set    0x02
HWAFFT_FRC_SC   .set    0x05
HWAFFT_UPD_SC   .set    0x06
HWAFFT_DIS_SC   .set    0x07
HWAFFT_START    .set    0x09
HWAFFT_COMPUTE  .set    0x10

; Define HWAFFT data vector lengths
DATA_LEN_8      .set    8
DATA_LEN_16     .set    16
DATA_LEN_32     .set    32
DATA_LEN_64     .set    64
DATA_LEN_128    .set    128
DATA_LEN_256    .set    256
DATA_LEN_512    .set    512
DATA_LEN_1024   .set    1024


                .text

;******************************************************************************
; Bit-reverses data vector
;******************************************************************************
_hwafft_br:
                ; XAR0 : input vector address
                ; XAR1 : output vector address
                ; T0 : data_len -- size of input/output vectors

                bit(ST2, #15) = #0           ; clear ARMS

                T1 = T0 - #1
                BRC0 = T1
                localrepeat {
                    AC3 = dbl(*AR0+)                   
                    dbl(*(AR1 + T0B)) = AC3
                }

                bit(ST2, #15) = #1           ; set ARMS

                return
                
;******************************************************************************
; Computes 8-point FFT/IFFT
;******************************************************************************
_hwafft_8pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)
        
                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_8-1)              ; N-1       ; set FFT N=8
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 8-pts FFT

                T0 = #(((DATA_LEN_8*3/4)-1)*2)      ; (N*3/4)-1 * 2 bytes => 5 * 2
                T1 = #((DATA_LEN_8/4)*2)            ; N/4 * 2 bytes => 2 * 2
    
                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_8-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_8-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5
                
                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
     
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0))
     
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_SINGLE , AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1
   
                ; Start single (last) stage
                AR2 = AR5
                AR3 = AR4
                T0 = #(DATA_LEN_8-2)                ; (N/2-1)*2
                T1 = #DATA_LEN_8                    ; N/2*2
     
                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1)) = AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0)) = AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1)) = AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0)) = AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1)) = AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0)) = AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1)) = AC1
                dbl(*(AR3+T0)) = AC1

                T0 = #(OUT_SEL_DATA)

                XAR5 = popboth()

                return

;******************************************************************************
; Computes 16-point FFT/IFFT
;******************************************************************************
_hwafft_16pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)

                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_16-1)             ; N-1       ; set FFT N=16
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 16-pts FFT

                T0 = #(((DATA_LEN_16*3/4)-1)*2)                   ; (N*3/4)-1 * 2 bytes => 11 * 2
                T1 = #((DATA_LEN_16/4)*2)                         ; N/4 * 2 bytes => 4 * 2

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_16-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_16-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR0-))                       ; load 1 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 2 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 3 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 4 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 5 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 6 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 7 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 8 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 9 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                       ; load 10+ compute, first valid output
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; load 11+ compute + store 1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; load 12+ compute + store 2
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; load 13+ compute + store 3
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1  ; load 14+ compute + store 4
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; load 15+ compute + store 5
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ; load 16+ compute + store 6
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ;          compute + store 7
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1   ;          compute + store 8
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ;          compute + store 9
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ;          compute + store 10
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ;          compute + store 11
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1   ;          compute + store 12
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ;          compute + store 13
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1   ;          compute + store 14

                ; Start 2nd double stage
                AR2 = AR5
                AR3 = AR4
                
                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1  ; load 1 + compute + store 15
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1  ; load 2 + compute + store 16
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 3 + compute  
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 4 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 5 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 6 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 7 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 8 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 9 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                       ; load 10+ compute, first valid output
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; load 11+ compute + store 1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; load 12+ compute + store 2
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; load 13+ compute + store 3
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1  ; load 14+ compute + store 4
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; load 15+ compute + store 5
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ; load 16+ compute + store 6
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 7
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1   ;          compute + store 8
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 9
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 10
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 11
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1   ;          compute + store 12
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 13
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 14
                                                      
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1   ;          compute + store 15
                dbl(*(AR3+T0))=AC1                                         ;                    store 16 
                
                T0 = #(OUT_SEL_DATA)

                XAR5 = popboth()

                return

;******************************************************************************
; Computes 32-point FFT/IFFT
;******************************************************************************
_hwafft_32pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)

                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_32-1)             ; N-1       ; set FFT N=32
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 32-pts FFT

                T0 = #(((DATA_LEN_32*3/4)-1)*2)                 ; (N*3/4)-1 * 2 bytes => 23 * 2
                T1 = #((DATA_LEN_32/4)*2)                       ; N/4 * 2 bytes => 8 * 2

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_32-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_32-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR0-))                           ; load 1 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 2 + compute

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 3 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 4 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 5 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 6 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 7 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 8 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 9 + compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 10+ compute, first valid output
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 11+ compute + store 1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 12+ compute + store 2
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 13+ compute + store 3
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 14+ compute + store 4
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 15+ compute + store 5
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 16+ compute + store 6
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 17+ compute + store 7
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 18+ compute + store 8
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 19+ compute + store 9
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 20+ compute + store 10
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 21+ compute + store 11
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 22+ compute + store 12
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 23+ compute + store 13
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 24+ compute + store 14
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 25+ compute + store 15
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 26+ compute + store 16
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 27+ compute + store 17
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 28+ compute + store 18
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 29+ compute + store 19
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 30+ compute + store 20
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 31+ compute + store 21
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; load 32+ compute + store 22
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; compute + store 23
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1       ; compute + store 24
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; compute + store 25
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; compute + store 26
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; compute + store 27
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1       ; compute + store 28

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; compute + store 29
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1       ; compute + store 30

                ; Start 2nd double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1      ; load 1 + compute + store 31
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; load 2 + compute + store 32

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 3 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 4 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 5 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 6 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 7 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 8 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 9 +
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))                           ; load 10+ compute
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 11+ compute + store 1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 12+ compute + store 2
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 13+ compute + store 3
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1      ; load 14+ compute + store 4
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 15+ compute + store 5
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 16+ compute + store 6
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 17+ compute + store 7
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1      ; load 18+ compute + store 8
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 19+ compute + store 9
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 20+ compute + store 10
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 21+ compute + store 11
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1      ; load 22+ compute + store 12
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 23+ compute + store 13
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 24+ compute + store 14
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 25+ compute + store 15                           
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1      ; load 26+ compute + store 16
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 27+ compute + store 17
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 28+ compute + store 18
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 29+ compute + store 19
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1      ; load 30+ compute + store 20
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; load 31+ compute + store 21
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ; load 32+ compute + store 22
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 23
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1       ;          compute + store 24
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 25
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 26
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 27
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1       ;          compute + store 28

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 29
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 30

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1       ;          compute + store 31
                AC1 = copr(#HWAFFT_SINGLE , AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1       ; single stage + compute + store 32
                                         
                ; Start single (last) stage
                AR0 = AR4
                AR1 = AR5
                T0 = #(DATA_LEN_32-2)               ; (N/2-1)*2
                T1 = #DATA_LEN_32                   ; N/2*2

                AC1 = copr(#HWAFFT_START  , AC0, dbl(*AR0-))                           ; load 1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 2
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 3
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 4
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 5
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 6
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                           ; load 7 + compute, first valid output
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 8 + compute + store 1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 9 + compute + store 2
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 10+ compute + store 3
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 11+ compute + store 4
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 12+ compute + store 5
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 13+ compute + store 6
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 14+ compute + store 7
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 15+ compute + store 8
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 16+ compute + store 9
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 17+ compute + store 10
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 18+ compute + store 11
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 19+ compute + store 12
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 20+ compute + store 13
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 21+ compute + store 14
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 22+ compute + store 15
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 23+ compute + store 16
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 24+ compute + store 17
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 25+ compute + store 18
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 26+ compute + store 19
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 27+ compute + store 20
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 28+ compute + store 21
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 29+ compute + store 22
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1      ; load 30+ compute + store 23
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1      ; load 31+ compute + store 24
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1-T1))=AC1      ; load 32+ compute + store 25
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1+T0))=AC1      ;          compute + store 26
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1-T1))=AC1      ;          compute + store 27
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1+T0))=AC1      ;          compute + store 28
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1-T1))=AC1      ;          compute + store 29
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1+T0))=AC1      ;          compute + store 30
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),  dbl(*(AR1-T1))=AC1      ;          compute + store 31
                dbl(*(AR1+T0))=AC1                                             ;                    store 32

                T0 = #(OUT_SEL_SCRATCH)

                XAR5 = popboth()

                return

;******************************************************************************
; Computes 64-point FFT/IFFT
;******************************************************************************
_hwafft_64pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)

                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_64-1)             ; N-1       ; set FFT N=64
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 64-pts FFT

                T0 = #(((DATA_LEN_64*3/4)-1)*2)                 ; (N*3/4)-1 * 2 bytes => 47 * 2 = 94
                T1 = #((DATA_LEN_64/4)*2)                       ; N/4 * 2 bytes => 16 * 2 = 32

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_64-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_64-1)*2)
                XAR5 = AC2

                ; Start first double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))

                BRC0 = #((DATA_LEN_64-16)/4)        ; 12
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }
                
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start second double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                
                BRC0 = #((DATA_LEN_64-16)/4)        ; 12
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }
                
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                
                ; Start third double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                
                BRC0 = #((DATA_LEN_64-16)/4)        ; 12
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1
                
                BRC0 = #1
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1
                }

                T0 = #(OUT_SEL_SCRATCH)

                XAR5 = popboth()

                return

;******************************************************************************
; Computes 128-point FFT/IFFT
;******************************************************************************
_hwafft_128pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)

                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_128-1)            ; N-1       ; set FFT N=128
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 128-pts FFT

                T0 = #(((DATA_LEN_128*3/4)-1)*2)    ;=190       ; (N*3/4)-1 * 2 bytes => 95 * 2
                T1 = #((DATA_LEN_128/4)*2)          ;=64        ; N/4 * 2 bytes => 32 * 2

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_128-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_128-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-))             
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                    

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
 
                BRC0 = #((DATA_LEN_128-16)/4)                       ; 28
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 1st double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start second double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 1st double stage

                BRC0 = #((DATA_LEN_128-16)/4)                       ; 28
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; store 1st output, 2nd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)) , dbl(*(AR3-T1))=AC1

                ; Start third double stage
                AR0 = AR4
                AR1 = AR5
                
                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1      ; store last output, 2nd double stage

                BRC0 = #((DATA_LEN_128-16)/4)                       ; 28
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1   ; store 1st output, 3rd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE,  AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_SINGLE , AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1      ; store last output, 3rd double stage
 
                ; Start single (last) stage
                AR2 = AR5
                AR3 = AR4
                T0 = #(DATA_LEN_128-2)                 ; (N/2-1)*2
                T1 = #DATA_LEN_128                     ; N/2*2

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-))

                BRC0 = #(DATA_LEN_128/4-3)                          ;29
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1      ; store first output
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                BRC0 = #1
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1
                }                    

                T0 = #(OUT_SEL_DATA)

                XAR5 = popboth()

                return

;******************************************************************************
; Computes 256-point FFT/IFFT
;******************************************************************************
_hwafft_256pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)
                
                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_256-1)            ; N-1       ; set FFT N=256
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 256-pts FFT

                T0 = #(((DATA_LEN_256*3/4)-1)*2)    ;=382       ; (N*3/4)-1 * 2 bytes => 191 * 2
                T1 = #((DATA_LEN_256/4)*2)          ;=128       ; N/4 * 2 bytes =>  64 * 2

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_256-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_256-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-))                    
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                    

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
 
                BRC0 = #((DATA_LEN_256-16)/4)       ; 60
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 1st double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start second double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 1st double stage    

                BRC0 = #((DATA_LEN_256-16)/4)       ; 60
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; store 1st output, 2nd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1

                ; Start third double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1      ; store last output, 2nd double stage     

                BRC0 = #((DATA_LEN_256-16)/4)       ; 60
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 3rd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start fourth double (last) stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 3rd double stage
             
                BRC0 = #((DATA_LEN_256-16)/4)       ; 60
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; store 1st output, 4th double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1
                
                BRC0 = #1
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3+T0))=AC1
                }

                T0 = #(OUT_SEL_DATA)

                XAR5 = popboth()

                return

;******************************************************************************
; Computes 512-point FFT/IFFT
;******************************************************************************
_hwafft_512pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)

                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_512-1)            ; N-1       ; set FFT N=512
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 512-pts FFT

                T0 = #(((DATA_LEN_512*3/4)-1)*2)    ;=766       ; (N*3/4)-1 * 2 bytes => 383 * 2
                T1 = #((DATA_LEN_512/4)*2)          ;=128       ; N/4 * 2 bytes => 128 * 2

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_512-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_512-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-))                    
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                    

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
 
                BRC0 = #((DATA_LEN_512-16)/4)       ; 124
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 1st double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start second double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 1st double stage     

                BRC0 = #((DATA_LEN_512-16)/4)       ; 124
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)),dbl(*(AR3-T1))=AC1  ; store 1st output, 2nd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)),dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)),dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)),dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)),dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)) ,dbl(*(AR3-T1))=AC1

                ; Start third double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1      ; store last output, 2nd double stage     

                BRC0 = #((DATA_LEN_512-16)/4)       ; 124
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 3rd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1

                ; Start fourth double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 3rd double stage
 
                BRC0 = #((DATA_LEN_512-16)/4)       ; 124
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; store 1st output, 4th double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_SINGLE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1       ; store last output, 4th double stage
 
                ; Start single (last) stage
                AR0 = AR4
                AR1 = AR5
                T0 = #(DATA_LEN_512-2)              ; (N/2-1)*2
                T1 = #(DATA_LEN_512)                ; N/2*2

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))

                BRC0 = #(DATA_LEN_512/4-3)          ;125
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)),dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)),dbl(*(AR1+T0))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)),dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)),dbl(*(AR1+T0))=AC1
                }
 
                BRC0 = #1
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),dbl(*(AR1+T0))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)),dbl(*(AR1+T0))=AC1
                }

                T0 = #(OUT_SEL_SCRATCH)

                XAR5 = popboth()
                   
                return

;******************************************************************************
; Computes 1024-point FFT/IFFT
;******************************************************************************
_hwafft_1024pts:
                ; Inputs:
                ; XAR0 : bit-reversed input vector address
                ; XAR1 : scratch vector address
                ; T0 : FFT/IFFT flag
                ; T1 : SCALE/NOSCALE flag               
                ; Outputs:
                ; T0 : OUT_SEL flag

                pshboth(XAR5)

                _Hwa_remap_hwa0                     ; enable HWA #0 (FFT coproc.)

                ; Initialize HWA FFT
                AC1 = T0
                AC1 = AC1 <<< #1
                AC1 |= T1
                AC1 = AC1 <<< #16
                AC1 += #(DATA_LEN_1024-1)           ; N-1       ; set FFT N=1024
                AC1 = copr(#HWAFFT_INIT, AC0, AC1)              ; init 1024-pts FFT

                T0 = #(((DATA_LEN_1024*3/4)-1)*2)   ;=1534      ; (N*3/4)-1 * 2 bytes => 767 * 2
                T1 = #((DATA_LEN_1024/4)*2)         ;=512       ; N/4 * 2 bytes => 256 * 2

                ; Save pointers to data buffers
                AC2 = XAR0
                AC2 += #((DATA_LEN_1024-1)*2)
                XAR4 = AC2
                AC2 = XAR1
                AC2 += #((DATA_LEN_1024-1)*2)
                XAR5 = AC2

                ; Start 1st double stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-))                    
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))                    

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-))
             
                BRC0 = #((DATA_LEN_1024-16)/4)      ; =252
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 1st double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start second double stage
                AR2 = AR5
                AR3 = AR4
 
                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 1st double stage

                BRC0 = #((DATA_LEN_1024-16)/4)      ; =252
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; store 1st output, 2nd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1

                ; Start third double stage
                AR0 = AR4
                AR1 = AR5
                
                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1      ; store last output, 2nd double stage     

                BRC0 = #((DATA_LEN_1024-16)/4)      ; =252
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 3rd double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                ; Start fourth double stage
                AR2 = AR5
                AR3 = AR4

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR1+T0))=AC1      ; store last output, 3rd double stage
             
                BRC0 = #((DATA_LEN_1024-16)/4)      ; =252
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1  ; store 1st output, 4th double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR2)), dbl(*(AR3-T1))=AC1

                ; Start fifth double (last) stage
                AR0 = AR4
                AR1 = AR5

                AC1 = copr(#HWAFFT_START, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR3+T0))=AC1      ; store last output, 4th double stage

                BRC0 = #((DATA_LEN_1024-16)/4)      ; =252
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1  ; store 1st output, 5th double stage
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)), dbl(*(AR1+T0))=AC1
                }

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0-)) ,dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1

                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1

                BRC0 = #1
                localrepeat {
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1-T1))=AC1
                    AC1 = copr(#HWAFFT_COMPUTE, AC0, dbl(*AR0)), dbl(*(AR1+T0))=AC1
                }
                
                T0 = #(OUT_SEL_SCRATCH)

                XAR5 = popboth()
                   
                return


                .end
