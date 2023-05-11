################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/lwip/src/core/snmp/asn1_dec.c \
../Drivers/lwip/src/core/snmp/asn1_enc.c \
../Drivers/lwip/src/core/snmp/mib2.c \
../Drivers/lwip/src/core/snmp/mib_structs.c \
../Drivers/lwip/src/core/snmp/msg_in.c \
../Drivers/lwip/src/core/snmp/msg_out.c 

OBJS += \
./Drivers/lwip/src/core/snmp/asn1_dec.o \
./Drivers/lwip/src/core/snmp/asn1_enc.o \
./Drivers/lwip/src/core/snmp/mib2.o \
./Drivers/lwip/src/core/snmp/mib_structs.o \
./Drivers/lwip/src/core/snmp/msg_in.o \
./Drivers/lwip/src/core/snmp/msg_out.o 

C_DEPS += \
./Drivers/lwip/src/core/snmp/asn1_dec.d \
./Drivers/lwip/src/core/snmp/asn1_enc.d \
./Drivers/lwip/src/core/snmp/mib2.d \
./Drivers/lwip/src/core/snmp/mib_structs.d \
./Drivers/lwip/src/core/snmp/msg_in.d \
./Drivers/lwip/src/core/snmp/msg_out.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/lwip/src/core/snmp/%.o: ../Drivers/lwip/src/core/snmp/%.c Drivers/lwip/src/core/snmp/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-lwip-2f-src-2f-core-2f-snmp

clean-Drivers-2f-lwip-2f-src-2f-core-2f-snmp:
	-$(RM) ./Drivers/lwip/src/core/snmp/asn1_dec.d ./Drivers/lwip/src/core/snmp/asn1_dec.o ./Drivers/lwip/src/core/snmp/asn1_enc.d ./Drivers/lwip/src/core/snmp/asn1_enc.o ./Drivers/lwip/src/core/snmp/mib2.d ./Drivers/lwip/src/core/snmp/mib2.o ./Drivers/lwip/src/core/snmp/mib_structs.d ./Drivers/lwip/src/core/snmp/mib_structs.o ./Drivers/lwip/src/core/snmp/msg_in.d ./Drivers/lwip/src/core/snmp/msg_in.o ./Drivers/lwip/src/core/snmp/msg_out.d ./Drivers/lwip/src/core/snmp/msg_out.o

.PHONY: clean-Drivers-2f-lwip-2f-src-2f-core-2f-snmp

