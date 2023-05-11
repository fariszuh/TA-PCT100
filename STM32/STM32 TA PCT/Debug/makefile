################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Drivers/lwip/src/netif/ppp/subdir.mk
-include Drivers/lwip/src/netif/subdir.mk
-include Drivers/lwip/src/core/snmp/subdir.mk
-include Drivers/lwip/src/core/ipv6/subdir.mk
-include Drivers/lwip/src/core/ipv4/subdir.mk
-include Drivers/lwip/src/core/subdir.mk
-include Drivers/lwip/src/api/subdir.mk
-include Drivers/lwip/port/STM32F4x7/subdir.mk
-include Drivers/STM32F4xx_StdPeriph_Driver/src/subdir.mk
-include Drivers/STM32F4xx_HAL_Driver/Src/subdir.mk
-include Drivers/STM32F4x7_ETH_Driver/src/subdir.mk
-include Drivers/ST/src/subdir.mk
-include Drivers/CMSIS/DSP_Lib/TransformFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/SupportFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/StatisticsFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/MatrixFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/FilteringFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/FastMathFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/ControllerFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/ComplexMathFunctions/subdir.mk
-include Drivers/CMSIS/DSP_Lib/CommonTables/subdir.mk
-include Drivers/CMSIS/DSP_Lib/BasicMathFunctions/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include Core/Inc/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := STM32 TA PCT
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
STM32\ TA\ PCT.elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
STM32\ TA\ PCT.list \

OBJCOPY_BIN += \
STM32\ TA\ PCT.bin \


# All Target
all: main-build

# Main-build Target
main-build: STM32\ TA\ PCT.elf secondary-outputs

# Tool invocations
STM32\ TA\ PCT.elf: $(OBJS) $(USER_OBJS) D:\OneDrive\ -\ Institut\ Teknologi\ Sepuluh\ Nopember\Tugas\ Akhir\Coding\ Faris\STM32\STM32\ TA\ PCT\STM32F407VGTX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "STM32 TA PCT.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\Coding Faris\STM32\STM32 TA PCT\STM32F407VGTX_FLASH.ld" --specs=nosys.specs -Wl,-Map="STM32 TA PCT.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

STM32\ TA\ PCT.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "STM32 TA PCT.list"
	@echo 'Finished building: $@'
	@echo ' '

STM32\ TA\ PCT.bin: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "STM32 TA PCT.bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) STM32\ TA\ PCT.bin STM32\ TA\ PCT.elf STM32\ TA\ PCT.list STM32\\ TA\\ PCT.elf default.size.stdout
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_BIN)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
