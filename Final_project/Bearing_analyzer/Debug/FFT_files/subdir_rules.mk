################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
FFT_files/codec_routines.obj: ../FFT_files/codec_routines.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/codec_routines.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/configuration.obj: ../FFT_files/configuration.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/configuration.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/dma_routines.obj: ../FFT_files/dma_routines.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/dma_routines.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/filter_routines.obj: ../FFT_files/filter_routines.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/filter_routines.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/hwafft.obj: ../FFT_files/hwafft.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/hwafft.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/i2s_register.obj: ../FFT_files/i2s_register.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/i2s_register.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/i2s_routines.obj: ../FFT_files/i2s_routines.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/i2s_routines.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/rtc_routines.obj: ../FFT_files/rtc_routines.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/rtc_routines.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

FFT_files/vector.obj: ../FFT_files/vector.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="FFT_files/vector.pp" --obj_directory="FFT_files" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


