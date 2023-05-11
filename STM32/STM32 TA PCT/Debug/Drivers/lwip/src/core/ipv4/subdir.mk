################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/lwip/src/core/ipv4/autoip.c \
../Drivers/lwip/src/core/ipv4/icmp.c \
../Drivers/lwip/src/core/ipv4/igmp.c \
../Drivers/lwip/src/core/ipv4/inet.c \
../Drivers/lwip/src/core/ipv4/inet_chksum.c \
../Drivers/lwip/src/core/ipv4/ip.c \
../Drivers/lwip/src/core/ipv4/ip_addr.c \
../Drivers/lwip/src/core/ipv4/ip_frag.c 

OBJS += \
./Drivers/lwip/src/core/ipv4/autoip.o \
./Drivers/lwip/src/core/ipv4/icmp.o \
./Drivers/lwip/src/core/ipv4/igmp.o \
./Drivers/lwip/src/core/ipv4/inet.o \
./Drivers/lwip/src/core/ipv4/inet_chksum.o \
./Drivers/lwip/src/core/ipv4/ip.o \
./Drivers/lwip/src/core/ipv4/ip_addr.o \
./Drivers/lwip/src/core/ipv4/ip_frag.o 

C_DEPS += \
./Drivers/lwip/src/core/ipv4/autoip.d \
./Drivers/lwip/src/core/ipv4/icmp.d \
./Drivers/lwip/src/core/ipv4/igmp.d \
./Drivers/lwip/src/core/ipv4/inet.d \
./Drivers/lwip/src/core/ipv4/inet_chksum.d \
./Drivers/lwip/src/core/ipv4/ip.d \
./Drivers/lwip/src/core/ipv4/ip_addr.d \
./Drivers/lwip/src/core/ipv4/ip_frag.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/lwip/src/core/ipv4/%.o: ../Drivers/lwip/src/core/ipv4/%.c Drivers/lwip/src/core/ipv4/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-lwip-2f-src-2f-core-2f-ipv4

clean-Drivers-2f-lwip-2f-src-2f-core-2f-ipv4:
	-$(RM) ./Drivers/lwip/src/core/ipv4/autoip.d ./Drivers/lwip/src/core/ipv4/autoip.o ./Drivers/lwip/src/core/ipv4/icmp.d ./Drivers/lwip/src/core/ipv4/icmp.o ./Drivers/lwip/src/core/ipv4/igmp.d ./Drivers/lwip/src/core/ipv4/igmp.o ./Drivers/lwip/src/core/ipv4/inet.d ./Drivers/lwip/src/core/ipv4/inet.o ./Drivers/lwip/src/core/ipv4/inet_chksum.d ./Drivers/lwip/src/core/ipv4/inet_chksum.o ./Drivers/lwip/src/core/ipv4/ip.d ./Drivers/lwip/src/core/ipv4/ip.o ./Drivers/lwip/src/core/ipv4/ip_addr.d ./Drivers/lwip/src/core/ipv4/ip_addr.o ./Drivers/lwip/src/core/ipv4/ip_frag.d ./Drivers/lwip/src/core/ipv4/ip_frag.o

.PHONY: clean-Drivers-2f-lwip-2f-src-2f-core-2f-ipv4

