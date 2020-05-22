################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../configuration.c \
../dma_routines.c \
../filter_routines.c \
../i2s_routines.c \
../main.c \
../rtc_routines.c 

ASM_SRCS += \
../codec_routines.asm \
../hwafft.asm \
../i2s_register.asm \
../vector.asm 

CMD_SRCS += \
../c5505.cmd 

ASM_DEPS += \
./codec_routines.pp \
./i2s_register.pp \
./vector.pp 

OBJS += \
./codec_routines.obj \
./configuration.obj \
./dma_routines.obj \
./filter_routines.obj \
./hwafft.obj \
./i2s_register.obj \
./i2s_routines.obj \
./main.obj \
./rtc_routines.obj \
./vector.obj 

C_DEPS += \
./configuration.pp \
./dma_routines.pp \
./filter_routines.pp \
./i2s_routines.pp \
./main.pp \
./rtc_routines.pp 

OBJS__QTD += \
".\codec_routines.obj" \
".\configuration.obj" \
".\dma_routines.obj" \
".\filter_routines.obj" \
".\hwafft.obj" \
".\i2s_register.obj" \
".\i2s_routines.obj" \
".\main.obj" \
".\rtc_routines.obj" \
".\vector.obj" 

ASM_DEPS__QTD += \
".\codec_routines.pp" \
".\i2s_register.pp" \
".\vector.pp" 

C_DEPS__QTD += \
".\configuration.pp" \
".\dma_routines.pp" \
".\filter_routines.pp" \
".\i2s_routines.pp" \
".\main.pp" \
".\rtc_routines.pp" 

ASM_SRCS_QUOTED += \
"../codec_routines.asm" \
"../hwafft.asm" \
"../i2s_register.asm" \
"../vector.asm" 

C_SRCS_QUOTED += \
"../configuration.c" \
"../dma_routines.c" \
"../filter_routines.c" \
"../i2s_routines.c" \
"../main.c" \
"../rtc_routines.c" 


# Each subdirectory must supply rules for building sources it contributes
codec_routines.obj: ../codec_routines.asm $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="codec_routines.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

configuration.obj: ../configuration.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="configuration.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

dma_routines.obj: ../dma_routines.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="dma_routines.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

filter_routines.obj: ../filter_routines.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="filter_routines.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

hwafft.obj: ../hwafft.asm $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

i2s_register.obj: ../i2s_register.asm $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="i2s_register.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

i2s_routines.obj: ../i2s_routines.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="i2s_routines.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

main.obj: ../main.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="main.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

rtc_routines.obj: ../rtc_routines.c $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="rtc_routines.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

vector.obj: ../vector.asm $(GEN_OPTS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Program Files/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Documents and Settings/A0272163/My Documents/Projects/2010-01-08 - C5505 FFT Demo/Bug_Fix_2010-05-10/project/Debug" --include_path="C:/Program Files/Texas Instruments/bios_5_40_03_23/packages/ti/rtdx/include/c5500" --diag_warning=225 --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="vector.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


