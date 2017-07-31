


class UartRx : public TimeProcess{
public:

	CData *rx;
	uint32_t uartTimeRate;
	UartRx(CData *rx, uint32_t uartTimeRate){
		this->rx = rx;
		this->uartTimeRate = uartTimeRate;
		schedule(uartTimeRate);
	}

	enum State {START, DATA, STOP};
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

#include<pthread.h>
#include <mutex>
#include <queue>

class UartTx : public TimeProcess{
public:

	CData *tx;
	uint32_t uartTimeRate;

	enum State {START, DATA, STOP};
	State state = START;
	char data;
	uint32_t counter;
	pthread_t inputThreadId;
	queue<uint8_t> inputsQueue;
	mutex inputsMutex;

	UartTx(CData *tx, uint32_t uartTimeRate){
		this->tx = tx;
		this->uartTimeRate = uartTimeRate;
		schedule(uartTimeRate);
		pthread_create(&inputThreadId, NULL, &inputThreadWrapper, this);
		*tx = 1;
	}

	static void* inputThreadWrapper(void *uartTx){
		((UartTx*)uartTx)->inputThread();
		return NULL;
	}

	void inputThread(){
		while(1){
			uint8_t c = getchar();
			inputsMutex.lock();
			inputsQueue.push(c);
			inputsMutex.unlock();
		}
	}

	virtual void tick(){
		switch(state){
			case START:
				inputsMutex.lock();
				if(!inputsQueue.empty()){
					data = inputsQueue.front();
					inputsQueue.pop();
					inputsMutex.unlock();
					state = DATA;
					counter = 0;
					*tx = 0;
					schedule(uartTimeRate);
				} else {
					inputsMutex.unlock();
					schedule(uartTimeRate*50);
				}
			break;
			case DATA:
				*tx = (data >> counter) & 1;
				counter++;
				if(counter == 8){
					state = STOP;
				}
				schedule(uartTimeRate);
			break;
			case STOP:
				*tx = 1;
				schedule(uartTimeRate);
				state = START;
			break;
		}
	}
};
