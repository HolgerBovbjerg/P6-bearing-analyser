################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
main.obj: ../main.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/FFT_files" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/I2C_files/chip_support" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" --include_path="C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer/Debug" --include_path="C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/include/c5500" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic --preproc_with_compile --preproc_dependency="main.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


