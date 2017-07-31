


class UartRx : public TimeProcess{
public:

	CData *rx;
	uint32_t uartTimeRate;
	UartRx(CData *rx, uint32_t uartTimeRate){
		this->rx = rx;
		this->uartTimeRate = uartTimeRate;
		schedule(uartTimeRate);
	}

	enum State {START, DATA, STOP,START_SUCCESS};
	State state = START;
	char data;
	uint32_t counter;


	virtual void tick(){
		switch(state){
			case START:
				if(*rx == 0){
					state = DATA;
					counter = 0;
					data = 0;
					schedule(uartTimeRate*5/4);
				} else {
					schedule(uartTimeRate/4);
				}
			break;
			case DATA:
				data |= (*rx) << counter++;
				if(counter == 8){
					state = STOP;
				}
				schedule(uartTimeRate);
			break;
			case STOP:
				if(*rx){
					cout << data << flush;
				} else {
					cout << "UART RX FRAME ERROR at " << time << endl;
				}

				schedule(uartTimeRate/4);
				state = START;
			break;
		}
	}
};


/*
class UartRx : public SensitiveProcess{
public:

	CData *rx;
	uint32_t uartTimeRate;
	UartRx(CData *rx, uint32_t uartTimeRate){
		this->rx = rx;
		this->uartTimeRate = uartTimeRate;
	}

	enum State {START, DATA, STOP,START_SUCCESS};
	State state = START;
	uint64_t holdTime = 0;
	CData holdValue;
	char data;
	uint32_t counter;
	virtual void tick(uint64_t time){
		if(time < holdTime){
			if(*rx != holdValue && time + (uartTimeRate>>7) < holdTime){
				cout << "UART RX FRAME ERROR at " << time << endl;
				holdTime = time;
				state = START;
			}
		}else{
			switch(state){
			case START:
			case START_SUCCESS:
				if(state == START_SUCCESS){
					cout << data << flush;
					state = START;
				}
				if(*rx == 0 && time > uartTimeRate){
					holdTime = time + uartTimeRate;
					holdValue = *rx;
					state = DATA;
					counter = 0;
					data = 0;
				}
				break;
			case DATA:
				data |= (*rx) << counter++;
				if(counter == 8){
					state = STOP;
				}
				holdValue = *rx;
				holdTime = time + uartTimeRate;
				break;
			case STOP:
				holdTime = time + uartTimeRate;
				holdValue = 1;
				state = START_SUCCESS;
				break;
			}
		}
	}
};*/