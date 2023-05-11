################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/lwip/src/core/ipv6/icmp6.c \
../Drivers/lwip/src/core/ipv6/inet6.c \
../Drivers/lwip/src/core/ipv6/ip6.c \
../Drivers/lwip/src/core/ipv6/ip6_addr.c 

OBJS += \
./Drivers/lwip/src/core/ipv6/icmp6.o \
./Drivers/lwip/src/core/ipv6/inet6.o \
./Drivers/lwip/src/core/ipv6/ip6.o \
./Drivers/lwip/src/core/ipv6/ip6_addr.o 

C_DEPS += \
./Drivers/lwip/src/core/ipv6/icmp6.d \
./Drivers/lwip/src/core/ipv6/inet6.d \
./Drivers/lwip/src/core/ipv6/ip6.d \
./Drivers/lwip/src/core/ipv6/ip6_addr.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/lwip/src/core/ipv6/%.o: ../Drivers/lwip/src/core/ipv6/%.c Drivers/lwip/src/core/ipv6/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-lwip-2f-src-2f-core-2f-ipv6

clean-Drivers-2f-lwip-2f-src-2f-core-2f-ipv6:
	-$(RM) ./Drivers/lwip/src/core/ipv6/icmp6.d ./Drivers/lwip/src/core/ipv6/icmp6.o ./Drivers/lwip/src/core/ipv6/inet6.d ./Drivers/lwip/src/core/ipv6/inet6.o ./Drivers/lwip/src/core/ipv6/ip6.d ./Drivers/lwip/src/core/ipv6/ip6.o ./Drivers/lwip/src/core/ipv6/ip6_addr.d ./Drivers/lwip/src/core/ipv6/ip6_addr.o

.PHONY: clean-Drivers-2f-lwip-2f-src-2f-core-2f-ipv6

