/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2025 STMicroelectronics.
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

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "Utility.h"
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

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
    /* USER CODE BEGIN 1 */

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
    /* USER CODE BEGIN 2 */
    Utility_Init();

    uint32_t yellow = 1073741823;
    uint32_t blue = 2143783647;
    uint32_t red = 3221225369;
    uint32_t green = 4294967291;
    uint32_t num;

    int max_sequence = 100;  // Tamanho máximo da sequência
    int nums_questao[100];   // Aumentado para comportar sequências longas
    int nums_resposta[100];

    int blinks = 0;          // Contador de rodadas atual
    int cont = 0;            // Contador de botões pressionados na rodada atual
    int novo_blink = 1;      // Flag para indicar quando gerar um novo padrão
    int game_over = 0;       // Flag para indicar fim de jogo

    /* USER CODE END 2 */

    /* Infinite loop */
    /* USER CODE BEGIN WHILE */
    while (1)
    {
        // Verifica se precisa gerar um novo padrão
        if (novo_blink) {
            // Adiciona um novo item à sequência
            num = Random_Number();

            if (num <= yellow) {
                nums_questao[blinks] = 1;
            } else if (num <= blue) {
                nums_questao[blinks] = 2;
            } else if (num <= red) {
                nums_questao[blinks] = 3;
            } else if (num <= green) {
                nums_questao[blinks] = 4;
            }

            blinks++; // Incrementa o contador de rodadas

            // Exibe todos os padrões até o momento
            for (int i = 0; i < blinks; i++) {
                // Acende o LED correspondente
                if (nums_questao[i] == 1) {
                    GPIO_Write_Pin(GPIOA, PIN_0, GPIO_PIN_SET);
                } else if (nums_questao[i] == 2) {
                    GPIO_Write_Pin(GPIOA, PIN_1, GPIO_PIN_SET);
                } else if (nums_questao[i] == 3) {
                    GPIO_Write_Pin(GPIOA, PIN_2, GPIO_PIN_SET);
                } else if (nums_questao[i] == 4) {
                    GPIO_Write_Pin(GPIOA, PIN_3, GPIO_PIN_SET);
                }

                Delay_ms(1000);

                // Apaga todos os LEDs
                GPIO_Write_Pin(GPIOA, PIN_0, GPIO_PIN_RESET);
                GPIO_Write_Pin(GPIOA, PIN_1, GPIO_PIN_RESET);
                GPIO_Write_Pin(GPIOA, PIN_2, GPIO_PIN_RESET);
                GPIO_Write_Pin(GPIOA, PIN_3, GPIO_PIN_RESET);

                Delay_ms(300); // Pequena pausa entre os padrões
            }

            novo_blink = 0; // Desativa a flag
            cont = 0; // Reinicia o contador de botões pressionados
        }

        // Entrada do jogador
        int button_pressed = 0;

        // Aguarda o jogador pressionar algum botão
        while (!button_pressed && !game_over) {
            if (GPIO_Read_Pin(GPIOA, PIN_4) == GPIO_PIN_RESET) {
                GPIO_Write_Pin(GPIOA, PIN_0, GPIO_PIN_SET);
                nums_resposta[cont] = 1;
                button_pressed = 1;
            }
            else if (GPIO_Read_Pin(GPIOA, PIN_5) == GPIO_PIN_RESET) {
                GPIO_Write_Pin(GPIOA, PIN_1, GPIO_PIN_SET);
                nums_resposta[cont] = 2;
                button_pressed = 1;
            }
            else if (GPIO_Read_Pin(GPIOA, PIN_6) == GPIO_PIN_RESET) {
                GPIO_Write_Pin(GPIOA, PIN_2, GPIO_PIN_SET);
                nums_resposta[cont] = 3;
                button_pressed = 1;
            }
            else if (GPIO_Read_Pin(GPIOA, PIN_7) == GPIO_PIN_RESET) {
                GPIO_Write_Pin(GPIOA, PIN_3, GPIO_PIN_SET);
                nums_resposta[cont] = 4;
                button_pressed = 1;
            }

            // Se um botão foi pressionado
            if (button_pressed) {
                Delay_ms(500); // Mantém o LED aceso

                // Apaga todos os LEDs
                GPIO_Write_Pin(GPIOA, PIN_0, GPIO_PIN_RESET);
                GPIO_Write_Pin(GPIOA, PIN_1, GPIO_PIN_RESET);
                GPIO_Write_Pin(GPIOA, PIN_2, GPIO_PIN_RESET);
                GPIO_Write_Pin(GPIOA, PIN_3, GPIO_PIN_RESET);

                // Verifica se o jogador acertou
                if (nums_resposta[cont] != nums_questao[cont]) {
                    // Jogador errou - pisca todos os LEDs para indicar game over
										for (int j = 0; j < 3; j++) {
												GPIO_Write_Pin(GPIOA, PIN_0, GPIO_PIN_SET);
												GPIO_Write_Pin(GPIOA, PIN_1, GPIO_PIN_SET);
												GPIO_Write_Pin(GPIOA, PIN_2, GPIO_PIN_SET);
												GPIO_Write_Pin(GPIOA, PIN_3, GPIO_PIN_SET);
												Delay_ms(200);
												GPIO_Write_Pin(GPIOA, PIN_0, GPIO_PIN_RESET);
												GPIO_Write_Pin(GPIOA, PIN_1, GPIO_PIN_RESET);
												GPIO_Write_Pin(GPIOA, PIN_2, GPIO_PIN_RESET);
												GPIO_Write_Pin(GPIOA, PIN_3, GPIO_PIN_RESET);
												Delay_ms(200);
										}

                    // Reinicia o jogo
                    blinks = 0;
                    novo_blink = 1;
                    game_over = 0;
                    break;
                }

                cont++; // Avança para o próximo botão

                // Verifica se o jogador completou a sequência atual
                if (cont == blinks) {
                    // Jogador completou esta rodada com sucesso

                    Delay_ms(1000); // Pausa antes da próxima rodada
                    novo_blink = 1;  // Habilita a geração de um novo padrão
                    break;
                }

                // Após registrar a entrada, aguarda o botão ser liberado
                while (GPIO_Read_Pin(GPIOA, PIN_4) == GPIO_PIN_RESET ||
                       GPIO_Read_Pin(GPIOA, PIN_5) == GPIO_PIN_RESET ||
                       GPIO_Read_Pin(GPIOA, PIN_6) == GPIO_PIN_RESET ||
                       GPIO_Read_Pin(GPIOA, PIN_7) == GPIO_PIN_RESET) {
                    Delay_ms(50);
                }

                Delay_ms(200); // Pequeno debounce após soltar o botão
                button_pressed = 0; // Permite detectar o próximo botão
            }
        }

        /* USER CODE END WHILE */

        /* USER CODE BEGIN 3 */
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
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
  /* USER CODE BEGIN MX_GPIO_Init_1 */

  /* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOA_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_0|GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3, GPIO_PIN_RESET);

  /*Configure GPIO pins : PA0 PA1 PA2 PA3 */
  GPIO_InitStruct.Pin = GPIO_PIN_0|GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : PA4 PA5 PA6 PA7 */
  GPIO_InitStruct.Pin = GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_PULLUP;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /* USER CODE BEGIN MX_GPIO_Init_2 */

  /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

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
