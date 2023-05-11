################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/lwip/src/api/api_lib.c \
../Drivers/lwip/src/api/api_msg.c \
../Drivers/lwip/src/api/err.c \
../Drivers/lwip/src/api/netbuf.c \
../Drivers/lwip/src/api/netdb.c \
../Drivers/lwip/src/api/netifapi.c \
../Drivers/lwip/src/api/sockets.c \
../Drivers/lwip/src/api/tcpip.c 

OBJS += \
./Drivers/lwip/src/api/api_lib.o \
./Drivers/lwip/src/api/api_msg.o \
./Drivers/lwip/src/api/err.o \
./Drivers/lwip/src/api/netbuf.o \
./Drivers/lwip/src/api/netdb.o \
./Drivers/lwip/src/api/netifapi.o \
./Drivers/lwip/src/api/sockets.o \
./Drivers/lwip/src/api/tcpip.o 

C_DEPS += \
./Drivers/lwip/src/api/api_lib.d \
./Drivers/lwip/src/api/api_msg.d \
./Drivers/lwip/src/api/err.d \
./Drivers/lwip/src/api/netbuf.d \
./Drivers/lwip/src/api/netdb.d \
./Drivers/lwip/src/api/netifapi.d \
./Drivers/lwip/src/api/sockets.d \
./Drivers/lwip/src/api/tcpip.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/lwip/src/api/%.o: ../Drivers/lwip/src/api/%.c Drivers/lwip/src/api/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-lwip-2f-src-2f-api

clean-Drivers-2f-lwip-2f-src-2f-api:
	-$(RM) ./Drivers/lwip/src/api/api_lib.d ./Drivers/lwip/src/api/api_lib.o ./Drivers/lwip/src/api/api_msg.d ./Drivers/lwip/src/api/api_msg.o ./Drivers/lwip/src/api/err.d ./Drivers/lwip/src/api/err.o ./Drivers/lwip/src/api/netbuf.d ./Drivers/lwip/src/api/netbuf.o ./Drivers/lwip/src/api/netdb.d ./Drivers/lwip/src/api/netdb.o ./Drivers/lwip/src/api/netifapi.d ./Drivers/lwip/src/api/netifapi.o ./Drivers/lwip/src/api/sockets.d ./Drivers/lwip/src/api/sockets.o ./Drivers/lwip/src/api/tcpip.d ./Drivers/lwip/src/api/tcpip.o

.PHONY: clean-Drivers-2f-lwip-2f-src-2f-api

