################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/lwip/src/netif/ppp/auth.c \
../Drivers/lwip/src/netif/ppp/chap.c \
../Drivers/lwip/src/netif/ppp/chpms.c \
../Drivers/lwip/src/netif/ppp/fsm.c \
../Drivers/lwip/src/netif/ppp/ipcp.c \
../Drivers/lwip/src/netif/ppp/lcp.c \
../Drivers/lwip/src/netif/ppp/magic.c \
../Drivers/lwip/src/netif/ppp/md5.c \
../Drivers/lwip/src/netif/ppp/pap.c \
../Drivers/lwip/src/netif/ppp/ppp.c \
../Drivers/lwip/src/netif/ppp/ppp_oe.c \
../Drivers/lwip/src/netif/ppp/randm.c \
../Drivers/lwip/src/netif/ppp/vj.c 

OBJS += \
./Drivers/lwip/src/netif/ppp/auth.o \
./Drivers/lwip/src/netif/ppp/chap.o \
./Drivers/lwip/src/netif/ppp/chpms.o \
./Drivers/lwip/src/netif/ppp/fsm.o \
./Drivers/lwip/src/netif/ppp/ipcp.o \
./Drivers/lwip/src/netif/ppp/lcp.o \
./Drivers/lwip/src/netif/ppp/magic.o \
./Drivers/lwip/src/netif/ppp/md5.o \
./Drivers/lwip/src/netif/ppp/pap.o \
./Drivers/lwip/src/netif/ppp/ppp.o \
./Drivers/lwip/src/netif/ppp/ppp_oe.o \
./Drivers/lwip/src/netif/ppp/randm.o \
./Drivers/lwip/src/netif/ppp/vj.o 

C_DEPS += \
./Drivers/lwip/src/netif/ppp/auth.d \
./Drivers/lwip/src/netif/ppp/chap.d \
./Drivers/lwip/src/netif/ppp/chpms.d \
./Drivers/lwip/src/netif/ppp/fsm.d \
./Drivers/lwip/src/netif/ppp/ipcp.d \
./Drivers/lwip/src/netif/ppp/lcp.d \
./Drivers/lwip/src/netif/ppp/magic.d \
./Drivers/lwip/src/netif/ppp/md5.d \
./Drivers/lwip/src/netif/ppp/pap.d \
./Drivers/lwip/src/netif/ppp/ppp.d \
./Drivers/lwip/src/netif/ppp/ppp_oe.d \
./Drivers/lwip/src/netif/ppp/randm.d \
./Drivers/lwip/src/netif/ppp/vj.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/lwip/src/netif/ppp/%.o: ../Drivers/lwip/src/netif/ppp/%.c Drivers/lwip/src/netif/ppp/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-lwip-2f-src-2f-netif-2f-ppp

clean-Drivers-2f-lwip-2f-src-2f-netif-2f-ppp:
	-$(RM) ./Drivers/lwip/src/netif/ppp/auth.d ./Drivers/lwip/src/netif/ppp/auth.o ./Drivers/lwip/src/netif/ppp/chap.d ./Drivers/lwip/src/netif/ppp/chap.o ./Drivers/lwip/src/netif/ppp/chpms.d ./Drivers/lwip/src/netif/ppp/chpms.o ./Drivers/lwip/src/netif/ppp/fsm.d ./Drivers/lwip/src/netif/ppp/fsm.o ./Drivers/lwip/src/netif/ppp/ipcp.d ./Drivers/lwip/src/netif/ppp/ipcp.o ./Drivers/lwip/src/netif/ppp/lcp.d ./Drivers/lwip/src/netif/ppp/lcp.o ./Drivers/lwip/src/netif/ppp/magic.d ./Drivers/lwip/src/netif/ppp/magic.o ./Drivers/lwip/src/netif/ppp/md5.d ./Drivers/lwip/src/netif/ppp/md5.o ./Drivers/lwip/src/netif/ppp/pap.d ./Drivers/lwip/src/netif/ppp/pap.o ./Drivers/lwip/src/netif/ppp/ppp.d ./Drivers/lwip/src/netif/ppp/ppp.o ./Drivers/lwip/src/netif/ppp/ppp_oe.d ./Drivers/lwip/src/netif/ppp/ppp_oe.o ./Drivers/lwip/src/netif/ppp/randm.d ./Drivers/lwip/src/netif/ppp/randm.o ./Drivers/lwip/src/netif/ppp/vj.d ./Drivers/lwip/src/netif/ppp/vj.o

.PHONY: clean-Drivers-2f-lwip-2f-src-2f-netif-2f-ppp

