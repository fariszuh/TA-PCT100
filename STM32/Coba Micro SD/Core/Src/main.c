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
char buffer[100];
uint32_t my_adc[3];
float my_adc_1, my_adc_2, my_adc_3;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */
void myprintf(const char *fmt, ...);
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
int value1, value2, DAC_OUT;
float Vout=0.00;
uint32_t startTime, lastTime, diffTime;
//char *stringku[12];

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */
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
  MX_SPI1_Init();
  MX_FATFS_Init();
  MX_UART4_Init();
  MX_TIM1_Init();
  MX_ADC1_Init();
  MX_DMA_Init();
  /* USER CODE BEGIN 2 */
  HAL_ADC_Start_DMA(&hadc1, my_adc, 3);

  HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_1);

//  https://github.com/kiwih/cubemx-mmc-sd-card/blob/master/Src/main.c
	myprintf("\r\n\r\n(Powering up)\r\nMary had a little lamb --\r\nI ate it with mint sauce.\r\n\r\n");
//	HAL_Delay(1000);
	FRESULT fres;

	//Mount drive
	fres = f_mount(&FatFs, "", 1); //1=mount now
	myprintf("stat = (%i)\r\n",fres);
	if (fres != FR_OK) {
	myprintf("f_mount error (%i)\r\n", fres);
//	while(1);
	}
	else{
	myprintf("SD CARD mounted successfully...\n\n");
	}
	//

	/* Check free space */
	DWORD free_clusters, free_sectors, total_sectors;
	FATFS* getFreeFs;
	fres = f_getfree("", &free_clusters, &getFreeFs);

	if (fres != FR_OK) {
	myprintf("f_getfree error (%i)\r\n", fres);
//	while(1);
	}
	else{
	total_sectors = (getFreeFs->n_fatent - 2) * getFreeFs->csize;
	free_sectors = free_clusters * getFreeFs->csize;

	myprintf("SD card stats:\r\n%10lu KiB total drive space.\r\n%10lu KiB available.\r\n", total_sectors / 2, free_sectors / 2);
	}

	//Try to open file
	fres = f_open(&fil, "test.txt", FA_READ);
	if (fres != FR_OK) {
	myprintf("f_open error (%i)\r\n");
//	while(1);
	}
	else{
	myprintf("I was able to open 'test.txt' for reading!\r\n");
	}

	BYTE readBuf[30];
	BYTE stringKirim[50];

	//We can either use f_read OR f_gets to get data out of files
	//f_gets is a wrapper on f_read that does some string formatting for us
	TCHAR* rres = f_gets((TCHAR*)readBuf, 30, &fil);
	if(rres != 0) {
	myprintf("Read string from 'test.txt' contents: %s\r\n", readBuf);
	} else {
	myprintf("f_gets error (%i)\r\n", fres);
	}

	//Close file, don't forget this!
	f_close(&fil);

	fres = f_open(&fil, "write.txt", FA_WRITE | FA_OPEN_ALWAYS | FA_CREATE_ALWAYS);
	if(fres == FR_OK) {
	myprintf("I was able to open 'write.txt' for writing\r\n");
	} else {
	myprintf("f_open error (%i)\r\n", fres);
	}

	startTime = HAL_GetTick();
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
//	  HAL_ADC_Start(&hadc1);
//	  HAL_ADC_PollForConversion(&hadc1, HAL_MAX_DELAY);
//	  value1 = HAL_ADC_GetValue(&hadc1);
	  value1= 0;
	  Vout = value1*9.75/4096;
	  DAC_OUT=4096-value1;
//	  HAL_ADC_Start(&hadc2);
//	  HAL_ADC_PollForConversion(&hadc2, HAL_MAX_DELAY);
//	  value2 = HAL_ADC_GetValue(&hadc2);


	  uint16_t PWM_OUT = value1*999/4096;
	  htim1.Instance->CCR1 = PWM_OUT ;

	  diffTime = HAL_GetTick() - startTime; // dalam ms
//	  stringku[12] = "asd";
//	  strncpy((char*)readBuf, " 12345 ", 19);
//	  strncpy((char*)readBuf, "abc", 19);
//	  stringku = "012345abc ";
//	  myprintf("readbuf = %s ",readBuf);
	  UINT bytesWrote;
//	  fres = f_write(&fil, readBuf, 19, &bytesWrote);
	  char dest[] = "abc";
	  char source[] = "123";
	  strcat((char*)dest,source);
	  fres = f_write(&fil, dest, 15, &bytesWrote);

	  if(fres == FR_OK) {
		myprintf("Successful write data %i \r\n", bytesWrote);
	  } else {
		myprintf("f_write error (%i)\r\n");
	  }

//	  HAL_Delay(10);
//	  lastTime = startTime;

	  if(diffTime > 5000)
	  {
	  //Close file, don't forget this!
	  f_close(&fil);

	  //De-mount drive
	  f_mount(NULL, "", 0);
//	  while(1);
	  }

//	  while(1);

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
  RCC_OscInitStruct.PLL.PLLN = 72;
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
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
{
	if(hadc->Instance == ADC1)
	{
		my_adc_1 = my_adc[0];
		my_adc_2 = my_adc[1];
		my_adc_3 = my_adc[2];
	}

}

void myprintf(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  vsnprintf(buffer, sizeof(buffer), fmt, args);
  va_end(args);

  int len = strlen(buffer);
  HAL_UART_Transmit(&huart4, (uint8_t*)buffer, len, 1000);

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

