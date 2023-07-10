
//----------------------------
// integer to ascii (itoa) with util functions 
//----------------------------

// function to swap two numbers
void swap(char *x, char *y) {
    char t = *x; *x = *y; *y = t;
}
 
// function to reverse buffer[i..j]
char* reverse(char *buffer, int i, int j) {
    while (i < j)
        swap(&buffer[i++], &buffer[j--]);
    return buffer;
}
 
// Iterative function to implement itoa() function in C
char* itoa(int value, char* buffer, int base) {
    // invalid input
    if (base < 2 || base > 32)
        return buffer;
    // consider absolute value of number
    int n = (value < 0) ? -value : value;
    int i = 0;
    while (n) {
        int r = n % base;
        if (r >= 10) 
            buffer[i++] = 65 + (r - 10);
        else
            buffer[i++] = 48 + r;
        n = n / base;
    }
 
    // if number is 0
    if (i == 0)
        buffer[i++] = '0';
 
    // If base is 10 and value is negative, the resulting string 
    // is preceded with a minus sign (-)
    // With any other base, value is always considered unsigned
    if (value < 0 && base == 10)
        buffer[i++] = '-';
 
    buffer[i] = '\0'; // null terminate string
 
    // reverse the string and return it
    return reverse(buffer, 0, i - 1);
}

//----------------------------
// print, println, dbgprint 
//----------------------------

void print(const char*str){
	while(*str){
		uart_write(UART,*str);
		str++;
	}
}
void println(const char*str){
	print(str);
	uart_write(UART,'\n');
}

void dbgPrintln(const char*str){
	#if DEBUG == 1
		println(str);
	#else 
		void;
	#endif
}

void delay(uint32_t loops){
	for(int i=0;i<loops;i++){
		int tmp = GPIO_A->OUTPUT;
	}
}