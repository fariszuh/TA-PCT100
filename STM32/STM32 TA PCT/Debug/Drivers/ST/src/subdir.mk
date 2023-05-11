################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/ST/src/system_stm32f4xx.c 

OBJS += \
./Drivers/ST/src/system_stm32f4xx.o 

C_DEPS += \
./Drivers/ST/src/system_stm32f4xx.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/ST/src/%.o: ../Drivers/ST/src/%.c Drivers/ST/src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-ST-2f-src

clean-Drivers-2f-ST-2f-src:
	-$(RM) ./Drivers/ST/src/system_stm32f4xx.d ./Drivers/ST/src/system_stm32f4xx.o

.PHONY: clean-Drivers-2f-ST-2f-src

