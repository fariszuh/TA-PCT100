################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/STM32F4xx_StdPeriph_Driver/src/misc.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c \
../Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.c 

OBJS += \
./Drivers/STM32F4xx_StdPeriph_Driver/src/misc.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.o \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.o 

C_DEPS += \
./Drivers/STM32F4xx_StdPeriph_Driver/src/misc.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.d \
./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/STM32F4xx_StdPeriph_Driver/src/%.o: ../Drivers/STM32F4xx_StdPeriph_Driver/src/%.c Drivers/STM32F4xx_StdPeriph_Driver/src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-STM32F4xx_StdPeriph_Driver-2f-src

clean-Drivers-2f-STM32F4xx_StdPeriph_Driver-2f-src:
	-$(RM) ./Drivers/STM32F4xx_StdPeriph_Driver/src/misc.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/misc.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.o ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.d ./Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.o

.PHONY: clean-Drivers-2f-STM32F4xx_StdPeriph_Driver-2f-src

