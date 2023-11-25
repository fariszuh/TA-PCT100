/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2023 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "adc.h"
#include "dma.h"
#include "fatfs.h"
#include "i2c.h"
#include "spi.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "stm32f4xx_hal.h"
#include <stdio.h>
#include <string.h>
#include <stdarg.h> //for va_list var arg functions
#include <stdlib.h>
#include <MCP4725.h>

//#include "user_diskio_spi.h"
//#include "user_diskio.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */
uint32_t my_adc[3];
uint32_t AI0_bit, AI1_bit, AI2_bit;
float AI0_volt, AI1_volt, AI2_volt;
float AO0_volt = 0; // valve flow control Qin
float AO1_volt = 0; // pompa
float AO0_volt_ramp = 0;
float AO1_volt_ramp = 0;
uint16_t AO0_bit, AO1_bit = 0;

char buffer[100];
char Tx_buffer[100],Rx_buffer[100];
char Rx_buffer_string[];
char Rx_buffer_status[];

//char data1, data2, data3;
uint32_t prevSP, SP,KP,KI = 0;

//float KI_nopointer;
//int startTime, diffTime;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */
void myprintf(const char *fmt, ...);
uint8_t setValue_AO0(uint16_t AO0_bit);
uint8_t setValue_AO1(uint16_t AO1_bit);
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
// First, create an MCP4725 object:
MCP4725 myMCP4725_AO0;
MCP4725 myMCP4725_AO1;

uint32_t micro_seconds = 0;
int awal = 1;
char stringKirim[] = "k, timestamp, MV_volt_FCValve, MV_volt_drain, bit_flow, bit_level, bit_PA2\n";
int k = 0;
uint32_t timestamp;
int value1, value2, DAC_OUT;
float Vout=0.00;
uint32_t startTime, diffTime, start_time_ramp_turun;
//untuk step time
uint32_t prevStepTime,currentTime = 0;
int firstStep = 1;

uint32_t dt,prevTime = 0;
uint8_t timeSampling = 50; // dalam ms
uint16_t SPMCP0, SPMCP1 = 0;
char comment[]="";
uint8_t BufferFinder[25] = {0};
uint8_t Space[] = " - ";
uint8_t StartMSG[] = "Starting I2C Scanning: \r\n";
uint8_t EndMSG[] = "Done! \r\n\r\n";
int errorDAC = 0;
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */
   	startTime = HAL_GetTick();
	FATFS FatFs; //Fatfs object
	FIL fil; //File object
  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_ADC1_Init();
  MX_TIM1_Init();
  MX_SPI1_Init();
  MX_FATFS_Init();
  MX_UART4_Init();
  MX_I2C1_Init();
  MX_I2C2_Init();
  /* USER CODE BEGIN 2 */
  HAL_ADC_Start_DMA(&hadc1, my_adc, 3);
  HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_1);
  HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_2);
  //https://github.com/SMotlaq/mcp4725/blob/master/Core/Src/main.c
  // Second, initilaize the MCP4725 object:


	myMCP4725_AO0 = MCP4725_init(&hi2c1, MCP4725A0_ADDR_A00, 5);
	myMCP4725_AO1 = MCP4725_init(&hi2c1, MCP4725A0_ADDR_A01, 5);

//  https://github.com/kiwih/cubemx-mmc-sd-card/blob/master/Src/main.c

  myprintf("\r\n\r\n(Powering up)\r\nReady to write data --\r\nThe data will be save in csv format.\r\n\r\n");
  FRESULT fres;

  //Mount drive
  fres = f_mount(&FatFs, "", 1); //1=mount now
  if (fres != FR_OK) {
	myprintf("f_mount error (%i)\r\n", fres);
//	while(1);
 }
  else{
	  myprintf("SD CARD mounted successfully...\n\n");
 }

 /* Check free space */
  DWORD free_clusters, free_sectors, total_sectors;
  FATFS* getFreeFs;
  fres = f_getfree("", &free_clusters, &getFreeFs);

  if (fres != FR_OK) {
	myprintf("f_getfree error (%i)\r\n", fres);
	while(1);
  } else{
	total_sectors = (getFreeFs->n_fatent - 2) * getFreeFs->csize;
	free_sectors = free_clusters * getFreeFs->csize;
	myprintf("SD card stats:\r\n%10lu KiB total drive space.\r\n%10lu KiB available.\r\n", total_sectors / 2, free_sectors / 2);
  }

  /*-----READ TEST.TXT by f_open method----*/
  fres = f_open(&fil, "testBaca.txt", FA_READ); //Try to open file
  if (fres != FR_OK) {
	  myprintf("f_open error (%i)\r\n");
	  while(1);
  } else{
	  myprintf("I was able to open 'testBaca.txt' for reading!\r\n");
  }

  /*-----READ TEST.TXT by f_gets method----*/
  BYTE readBuf[30];
  //We can either use f_read OR f_gets to get data out of files
  //f_gets is a wrapper on f_read that does some string formatting for us
  TCHAR* rres = f_gets((TCHAR*)readBuf, 30, &fil);
  if(rres != 0) {
	  myprintf("Read string from 'testBaca.txt' contents: %s\r\n", readBuf);
  } else {
	  myprintf("f_gets error (%i)\r\n", fres);
	  while(1);
  }
  f_close(&fil); //Close file, don't forget this!

  /*-----OPEN WRITE.TXT READY TO WRITE----*/
  fres = f_open(&fil, "write.txt", FA_WRITE | FA_OPEN_ALWAYS | FA_CREATE_ALWAYS);
  if(fres == FR_OK) {
	  myprintf("I was able to open 'write.txt' for writing\r\n");
  } else {
	  myprintf("f_open error (%i)\r\n", fres);
   while(1);
  }

  setValue_AO0(0);	// 0mV di awal
  setValue_AO1(0);	// 0mV di awal
  prevTime = 0;

  HAL_GPIO_WritePin(GPIOE, GPIO_PIN_11, GPIO_PIN_RESET);
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)

    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
	{
	diffTime = HAL_GetTick() - startTime; // dalam ms

	AO0_bit = (uint16_t) 4095 * AO0_volt / 24; // divided by 24V karena AO0 mengirim tegangan max 24V
	AO1_bit = (uint16_t) 4095 * AO1_volt / 10; // divided by 10V karena AO0 mengirim tegangan max 10V

	if(!MCP4725_isConnected(&myMCP4725_AO0)){
		/* Print that the DAC is connected */
		errorDAC = 1;
		myprintf("MCP A0 not connected | ");
		}
	if(!MCP4725_isConnected(&myMCP4725_AO1)){
		/* Print that the DAC is connected */
		errorDAC = 1;
		myprintf("MCP A1 not connected | ");
		}

	if(MCP4725_isConnected(&myMCP4725_AO0) && MCP4725_isConnected(&myMCP4725_AO1)){
		errorDAC = 0;/* Print that the DAC is NOT connected */
		myprintf("Both MCP4725 s Connected  -- ");
		}


	setValue_AO0(AO0_bit);
	setValue_AO1(AO1_bit);

	/*-----STORING TO MICRO SD----*/
	UINT bytesWrote;
	dt = diffTime - prevTime; // juga digunakan dalam integrator, derivative PID
	if(dt >= timeSampling){
		fres = f_write(&fil, stringKirim, strlen(stringKirim), &bytesWrote);
		k++;
		prevTime = HAL_GetTick();
		}

	timestamp = HAL_GetTick() - startTime;
	/* KONVERSI bit ke Volt */
//	AI0_volt = AI0_bit * 3.3 / 4096; // PA0
//	AI1_volt = AI1_bit * 3.3 / 4096; // PA1
//	AI2_volt = AI2_bit * 3.3 / 4096; // PA2
	sprintf(stringKirim,"%d, %d, %f, %f, %d, %d, %d\n",k,timestamp, AO0_volt, AO1_volt, AI0_bit, AI1_bit, AI2_bit); // stringKirim baru, sesuai nilai adc cpltCallback

	if(fres == FR_OK) {
	myprintf("Status: %s",stringKirim);
	} else {
	if(awal==0){ myprintf("f_write error (%i)\r\n"); }
	HAL_UART_Receive(&huart4, (char*)Rx_buffer, 50, 500);
	sprintf(Rx_buffer_string,"%s",Rx_buffer);
	char* Rx_buffer_print = strtok(Rx_buffer_string,"\r\n");
	sscanf(Rx_buffer_print, "[SP=%d],[KP=%d],[KI=%d]", &SP, &KP, &KI);
	myprintf("SP = %d | KP = %d | KI = %d \n",SP, KP, KI);
	}
	if(SP != prevSP){
	/*-----PWM DAC DUTY CYCLE GENERATION-----*/
		htim1.Instance->CCR1 = SP * 999 / 4096; // output PE9 dalam 0 (0% duty cycle) - 4096 (100% duty cycle) 1kHz HCLK
		htim1.Instance->CCR2 = KP * 999 / 4096; // output PE9 dalam 0 (0% duty cycle) - 4096 (100% duty cycle) 1kHz HCLK
		prevSP = SP;
	}


	if(diffTime > 3000){ // awal kali 0V, setelah 2s keluar AO sesuai yg diminta
//			// GENERATE RAMP SIGNAL
//				if(diffTime <= 66000){
//					AO0_volt_ramp = (float) 22 * (diffTime-3000)/60000;
//					AO1_volt_ramp = (float) 10 * (diffTime-3000)/60000;
//					start_time_ramp_turun = diffTime;
//				}
//				else if(diffTime > 66000){
//					AO0_volt_ramp = 22 - 22*((float) (diffTime - start_time_ramp_turun)/60000);
//					AO1_volt_ramp = 10 - 10*((float) (diffTime - start_time_ramp_turun)/60000);
//				}
//				// saturasi ramp signal
//				if(AO0_volt_ramp > 22){
//					AO0_volt_ramp = 22;
//				}
//				else if(AO0_volt_ramp < 0){
//					AO0_volt_ramp = 0;
//				}
//				if(AO1_volt_ramp > 10){
//					AO1_volt_ramp = 10;
//				}
//				else if(AO1_volt_ramp < 0){
//					AO1_volt_ramp = 0;
//				}
//				AO0_volt = AO0_volt_ramp;
//				AO1_volt = AO1_volt_ramp;

		//				AO0_volt = 0; // valve flow control Qin
//				AO1_volt = 0; // pompa, drain valve
				HAL_GPIO_WritePin(GPIOE, GPIO_PIN_11, GPIO_PIN_SET);

				if(diffTime > 150000) { // waktu stop untuk close dan unmount csv, nilai ini harus + difftime 2s
					f_close(&fil); //Close file, don't forget this!
					f_mount(NULL, "", 0); //De-mount drive
					// normalkan kondisi semua off
					AO0_volt = 0;
					AO1_volt = 0;
					HAL_GPIO_WritePin(GPIOE, GPIO_PIN_11, GPIO_PIN_RESET);
					}
				}
	}
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);
  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 4;
  RCC_OscInitStruct.PLL.PLLN = 168;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
{

 if(hadc->Instance == ADC1)
  {
   AI0_bit = my_adc[0]; // PA0
   AI1_bit = my_adc[1]; // PA1
   AI2_bit = my_adc[2]; // PA2
   if(awal = 1){
	   diffTime = HAL_GetTick() - startTime;
   }
   awal = 0;
  }
}

void myprintf(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  vsnprintf(Tx_buffer, sizeof(Tx_buffer), fmt, args);
  va_end(args);
  HAL_UART_Transmit(&huart4, (uint8_t*)Tx_buffer, strlen(Tx_buffer), 100);
}

uint8_t setValue_AO0(uint16_t AO0_bit){
	return MCP4725_setValue(&myMCP4725_AO0, AO0_bit, MCP4725_FAST_MODE, MCP4725_POWER_DOWN_OFF);
}

uint8_t setValue_AO1(uint16_t AO1_bit){
	return MCP4725_setValue(&myMCP4725_AO1, AO1_bit, MCP4725_FAST_MODE, MCP4725_POWER_DOWN_OFF);
}


/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
