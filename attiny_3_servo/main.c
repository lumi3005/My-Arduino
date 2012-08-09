#include "common.h"

#define keskmista(vana, uus) ( (uus >> 2)+(vana - (vana >> 2)) )

//FUSED lfuse 7A hfuse FE

uint8_t sys;
uint8_t servo[3];

ISR(ADC_vect)
{

	if ((ADMUX & 0x03) == 0x02)
	{
		servo[0] = keskmista(servo[0],ADCH);
		ADMUX = (ADMUX & 0xFC) | 0x03;
	}
	else if ((ADMUX & 0x03) == 0x03)
	{
		servo[1] = keskmista(servo[1],ADCH);
		ADMUX = (ADMUX & 0xFC) | 0x00;
	}
	else if ((ADMUX & 0x03) == 0x00)
	{
		servo[2] = keskmista(servo[2],ADCH);
		ADMUX = (ADMUX & 0xFC) | 0x02;
	}

	setbit(ADCSRA,ADSC);
}

ISR(TIM0_OVF_vect)
{
	if (sys==1)
	{
		clearbit(PORTB,PB0);
		setbit(PORTB,PB1);
		TCNT0=256-servo[1];
	}
	else if (sys==2)
	{
		clearbit(PORTB,PB1);
		setbit(PORTB,PB2);
		TCNT0=256-servo[2];
	}
	else if (sys==3)
	{
		clearbit(PORTB,PB2);
		TCNT0=servo[0];
	}
	else if (sys==4)
	{
		TCNT0=servo[1];
	}
	else if (sys==5)
	{
		TCNT0=servo[2];
	}
	else if (sys==6)
	{
		TCNT0=30;
	}
	else if (sys==9)
	{
		setbit(PORTB,PB0);
		TCNT0=256-servo[0];
		sys=0;
	}

	sys++;
}

void l2hestaADC()
{
	setbit(ADMUX,MUX1);

	setbit(ADMUX,ADLAR);//left aligned
	ADCSRA = 0b11011100; //ADC sisse, Divison factor valitud, Interrupt sisse
}

int main()
{

	// Keela katkestused
	cli();
	// Seadista väljundid
	DDRB = 0b00000111;

	setbit(TCCR0B,CS01);
	setbit(TCCR0B,CS00);
	setbit(TIMSK0,TOIE0);

	l2hestaADC();

	//Luba katkestused
	sei();
	
	servo[0]=110;//õlg 40-130(all)
	servo[1]=60;//pööramine 60-160
	servo[2]=160;//ranne  -180(üleval)

	while (1){}
}
