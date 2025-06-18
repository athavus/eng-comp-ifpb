#ifndef DELAY_H_
#define DELAY_H_

#include "stm32f4xx.h"

void Delay_Init(void) {
    RCC->APB1ENR |= RCC_APB1ENR_TIM2EN;

    TIM2->PSC = 90-1;

    TIM2->CR1 |= TIM_CR1_CEN;

    TIM2->EGR = TIM_EGR_UG;
}

void Delay_us(uint32_t us) {
    TIM2->CNT = 0;

    TIM2->ARR = us;

    TIM2->SR &= ~TIM_SR_UIF;

    while(!(TIM2->SR & TIM_SR_UIF));
}

void Delay_ms(uint32_t ms) {
    Delay_us(ms * 1000);
}


#endif /* DELAY_H_ */
