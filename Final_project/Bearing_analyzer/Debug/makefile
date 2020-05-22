################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

EMPTY := 
SPACE := $(EMPTY) $(EMPTY)
CG_TOOL_ROOT := C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500

ORDERED_OBJS += \
$(GEN_CMDS_QUOTED) \
"../c5505.cmd" \
"./FFT_files/vector.obj" \
"./FFT_files/rtc_routines.obj" \
"./FFT_files/i2s_routines.obj" \
"./FFT_files/i2s_register.obj" \
"./FFT_files/hwafft.obj" \
"./FFT_files/filter_routines.obj" \
"./FFT_files/dma_routines.obj" \
"./FFT_files/configuration.obj" \
"./FFT_files/codec_routines.obj" \
"./I2C_files/pll.obj" \
"./I2C_files/ezdsp5535_led.obj" \
"./I2C_files/ezdsp5535_i2c.obj" \
"./I2C_files/ezdsp5535_gpio.obj" \
"./I2C_files/ezdsp5535.obj" \
"./I2C_files/aic3204_init.obj" \
"./I2C_files/aic3204.obj" \
"./I2C_files/MMA8451.obj" \
"./main.obj" \
-l"rts55h.lib" \
"../55xdsph.lib" \
"../I2C_files/chip_support/CSLc55x5h.lib" \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include I2C_files/subdir_vars.mk
-include I2C_files/chip_support/subdir_vars.mk
-include FFT_files/subdir_vars.mk
-include subdir_rules.mk
-include I2C_files/subdir_rules.mk
-include I2C_files/chip_support/subdir_rules.mk
-include FFT_files/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: VC5505_FFT_Filter_Demo.out

# Tool invocations
VC5505_FFT_Filter_Demo.out: $(OBJS) $(CMD_SRCS) $(LIB_SRCS) $(GEN_CMDS)
	@echo 'Building target: $@'
	@echo 'Invoking: Linker'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/bin/cl55" -vcpu:3.3 --symdebug:coff --define="_DEBUG" --define="C55X" --diag_warning=225 --large_memory_model --ptrdiff_size=32 --algebraic --no_mac_expand --memory_model=huge --asm_source=algebraic -z -m"VC5505_FFT_Filter_Demo.map" --stack_size=1000 --warn_sections -i"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/lib" -i"C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/DSP projects/HWAFFT_I2C/I2C_files" -i"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/c5500/include" -i"C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/rtdx/lib/c5500" -i"C:/Program Files (x86)/Texas Instruments/bios_5_41_10_36/packages/ti/bios/lib" -i"C:/Users/claus/Documents/GitHub/P6-vibration-monitoring/Final_project/Bearing_analyzer" -i"/lib" --reread_libs --entry_point=reset_isr --rom_model --sys_stacksize=1000 -o "VC5505_FFT_Filter_Demo.out" $(ORDERED_OBJS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(GEN_CMDS__QTD)$(GEN_SRCS__QTD)$(GEN_MISC_FILES__QTD)$(C5500_EXECUTABLE_OUTPUTS__QTD) "VC5505_FFT_Filter_Demo.out"
	-$(RM) ".\main.obj" ".\I2C_files\MMA8451.obj" ".\I2C_files\aic3204.obj" ".\I2C_files\aic3204_init.obj" ".\I2C_files\ezdsp5535.obj" ".\I2C_files\ezdsp5535_gpio.obj" ".\I2C_files\ezdsp5535_i2c.obj" ".\I2C_files\ezdsp5535_led.obj" ".\I2C_files\pll.obj" ".\FFT_files\codec_routines.obj" ".\FFT_files\configuration.obj" ".\FFT_files\dma_routines.obj" ".\FFT_files\filter_routines.obj" ".\FFT_files\hwafft.obj" ".\FFT_files\i2s_register.obj" ".\FFT_files\i2s_routines.obj" ".\FFT_files\rtc_routines.obj" ".\FFT_files\vector.obj" 
	-$(RM) ".\FFT_files\codec_routines.pp" ".\FFT_files\hwafft.pp" ".\FFT_files\i2s_register.pp" ".\FFT_files\vector.pp" 
	-$(RM) ".\main.pp" ".\I2C_files\MMA8451.pp" ".\I2C_files\aic3204.pp" ".\I2C_files\aic3204_init.pp" ".\I2C_files\ezdsp5535.pp" ".\I2C_files\ezdsp5535_gpio.pp" ".\I2C_files\ezdsp5535_i2c.pp" ".\I2C_files\ezdsp5535_led.pp" ".\I2C_files\pll.pp" ".\FFT_files\configuration.pp" ".\FFT_files\dma_routines.pp" ".\FFT_files\filter_routines.pp" ".\FFT_files\i2s_routines.pp" ".\FFT_files\rtc_routines.pp" 
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
