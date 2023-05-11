################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/lwip/src/core/dhcp.c \
../Drivers/lwip/src/core/dns.c \
../Drivers/lwip/src/core/init.c \
../Drivers/lwip/src/core/mem.c \
../Drivers/lwip/src/core/memp.c \
../Drivers/lwip/src/core/netif.c \
../Drivers/lwip/src/core/pbuf.c \
../Drivers/lwip/src/core/raw.c \
../Drivers/lwip/src/core/stats.c \
../Drivers/lwip/src/core/sys.c \
../Drivers/lwip/src/core/tcp.c \
../Drivers/lwip/src/core/tcp_in.c \
../Drivers/lwip/src/core/tcp_out.c \
../Drivers/lwip/src/core/udp.c 

OBJS += \
./Drivers/lwip/src/core/dhcp.o \
./Drivers/lwip/src/core/dns.o \
./Drivers/lwip/src/core/init.o \
./Drivers/lwip/src/core/mem.o \
./Drivers/lwip/src/core/memp.o \
./Drivers/lwip/src/core/netif.o \
./Drivers/lwip/src/core/pbuf.o \
./Drivers/lwip/src/core/raw.o \
./Drivers/lwip/src/core/stats.o \
./Drivers/lwip/src/core/sys.o \
./Drivers/lwip/src/core/tcp.o \
./Drivers/lwip/src/core/tcp_in.o \
./Drivers/lwip/src/core/tcp_out.o \
./Drivers/lwip/src/core/udp.o 

C_DEPS += \
./Drivers/lwip/src/core/dhcp.d \
./Drivers/lwip/src/core/dns.d \
./Drivers/lwip/src/core/init.d \
./Drivers/lwip/src/core/mem.d \
./Drivers/lwip/src/core/memp.d \
./Drivers/lwip/src/core/netif.d \
./Drivers/lwip/src/core/pbuf.d \
./Drivers/lwip/src/core/raw.d \
./Drivers/lwip/src/core/stats.d \
./Drivers/lwip/src/core/sys.d \
./Drivers/lwip/src/core/tcp.d \
./Drivers/lwip/src/core/tcp_in.d \
./Drivers/lwip/src/core/tcp_out.d \
./Drivers/lwip/src/core/udp.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/lwip/src/core/%.o: ../Drivers/lwip/src/core/%.c Drivers/lwip/src/core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-lwip-2f-src-2f-core

clean-Drivers-2f-lwip-2f-src-2f-core:
	-$(RM) ./Drivers/lwip/src/core/dhcp.d ./Drivers/lwip/src/core/dhcp.o ./Drivers/lwip/src/core/dns.d ./Drivers/lwip/src/core/dns.o ./Drivers/lwip/src/core/init.d ./Drivers/lwip/src/core/init.o ./Drivers/lwip/src/core/mem.d ./Drivers/lwip/src/core/mem.o ./Drivers/lwip/src/core/memp.d ./Drivers/lwip/src/core/memp.o ./Drivers/lwip/src/core/netif.d ./Drivers/lwip/src/core/netif.o ./Drivers/lwip/src/core/pbuf.d ./Drivers/lwip/src/core/pbuf.o ./Drivers/lwip/src/core/raw.d ./Drivers/lwip/src/core/raw.o ./Drivers/lwip/src/core/stats.d ./Drivers/lwip/src/core/stats.o ./Drivers/lwip/src/core/sys.d ./Drivers/lwip/src/core/sys.o ./Drivers/lwip/src/core/tcp.d ./Drivers/lwip/src/core/tcp.o ./Drivers/lwip/src/core/tcp_in.d ./Drivers/lwip/src/core/tcp_in.o ./Drivers/lwip/src/core/tcp_out.d ./Drivers/lwip/src/core/tcp_out.o ./Drivers/lwip/src/core/udp.d ./Drivers/lwip/src/core/udp.o

.PHONY: clean-Drivers-2f-lwip-2f-src-2f-core

