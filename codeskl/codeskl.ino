#include <SPI.h>

const int SCLK_pin = 13;
const int MOSI_pin = 11;
const int MISO_pin = 12;
const int BUFSCL_pin = 10;
const int BUFLATCH_pin = 9;
const int BUFOE_pin = 8;
const int LEDOE_pin = 6;
const int LEDLE_pin = 7;
const int ADCCS_pin = 5;
const int ADCEDC_pin = 4;

const int ROW_CNT = 8;
const int COLUMN_CNT = 24;
const int FIRST_COLUMN = 2;

unsigned int volume[ROW_CNT][COLUMN_CNT];

//row is dominant and powering
void row_on(int row) {
    digitalWrite(LEDOE_pin, HIGH);
    
        
    byte b = 1 << row;// | 1<< (row-1);
    //Serial.println(b, DEC);
    SPI.transfer(b);
    digitalWrite(LEDLE_pin, HIGH); 
    digitalWrite(LEDLE_pin, LOW);
    //delayMicroseconds(100);
    //digitalWrite(LEDLE_pin, LOW);
    //digitalWrite(LEDLE_pin, HIGH);

    digitalWrite(LEDOE_pin, LOW);
}

void row_off() {
    digitalWrite(LEDOE_pin, HIGH);
    //    digitalWrite(LEDLE_pin, LOW);
    //        
    //    SPI.transfer(0);
    //    digitalWrite(LEDLE_pin, HIGH); 
    //    //delayMicroseconds(100);
    //    //digitalWrite(LEDLE_pin, LOW);
    //    //digitalWrite(LEDLE_pin, HIGH);
    //
    //    digitalWrite(LEDOE_pin, LOW);
}

void column_on(int column) {
    digitalWrite(BUFOE_pin, HIGH);
    long b = 1L << column;
    byte hb = (b & 0xFF0000) >> 16;
    byte mb = (b & 0xFF00) >> 8;
    byte lb = b & 0xFF;
    
    SPI.transfer(hb);
    SPI.transfer(mb);
    SPI.transfer(lb);

    digitalWrite(BUFLATCH_pin, HIGH); 
    digitalWrite(BUFLATCH_pin, LOW); 

    digitalWrite(BUFOE_pin, LOW);
}

void column_off() {
    digitalWrite(BUFOE_pin, HIGH);

    SPI.transfer(0);
    SPI.transfer(0);
    SPI.transfer(0);

    digitalWrite(BUFLATCH_pin, HIGH); 
    digitalWrite(BUFLATCH_pin, LOW); 

    digitalWrite(BUFOE_pin, LOW);
}

unsigned int row_read(int row){

    //conversion 
    digitalWrite(ADCCS_pin,LOW);
    //SPI.transfer(0b11110000);
    //Serial.println(0b10000110 | (byte)(row << 3), BIN);
    SPI.transfer(0b10000110 | (byte)(row << 3));
    //SPI.transfer(0b10000110 | (byte)(3 << 3));
    digitalWrite(ADCCS_pin,HIGH);
    //delayMicroseconds(10);
 
    digitalWrite(ADCCS_pin,LOW);
    unsigned int upperbyte = SPI.transfer(0b0);
    digitalWrite(ADCCS_pin,HIGH);
    
    
    digitalWrite(ADCCS_pin,LOW);
    unsigned int lowerbyte = SPI.transfer(0b0);
    digitalWrite(ADCCS_pin,HIGH);
	

/*     Serial.write(upperbyte); */
/*     Serial.write(lowerbyte); */

    delayMicroseconds(10);

    return upperbyte << 8 | lowerbyte;
}


void setup() {
    //    Serial.begin(115200);
    Serial.begin(230400);

    SPI.setBitOrder(MSBFIRST);
    SPI.setDataMode(SPI_MODE0);
    SPI.setClockDivider(SPI_CLOCK_DIV4);
    SPI.begin();

    pinMode(LEDLE_pin, OUTPUT);
    pinMode(LEDOE_pin, OUTPUT);
    pinMode(BUFOE_pin, OUTPUT);
    pinMode(BUFSCL_pin, OUTPUT);
    pinMode(BUFLATCH_pin, OUTPUT);
    pinMode(ADCCS_pin, OUTPUT);
    pinMode(ADCEDC_pin, INPUT);

    digitalWrite(LEDLE_pin, HIGH);
    digitalWrite(LEDOE_pin, HIGH);
    digitalWrite(BUFOE_pin, HIGH);
    digitalWrite(BUFLATCH_pin, LOW);
    digitalWrite(BUFSCL_pin, HIGH);
    digitalWrite(ADCCS_pin, HIGH);
    
    // We set up the ADC properly (once and for all)
    digitalWrite(ADCCS_pin,LOW);
    SPI.transfer(0b00010000);
    digitalWrite(ADCCS_pin,HIGH);

    //setup 
    digitalWrite(ADCCS_pin,LOW);
    SPI.transfer(0b01101000);
    digitalWrite(ADCCS_pin,HIGH);

    //avgon 
    digitalWrite(ADCCS_pin,LOW);
    //SPI.transfer(0b00100000);
    SPI.transfer(0b00100000);
    digitalWrite(ADCCS_pin,HIGH);

    // One fake read to get things started. 
    digitalWrite(ADCCS_pin,LOW);
    //SPI.transfer(0b11110000);
    //Serial.println(0b10000110 | (byte)(row << 3), BIN);
    SPI.transfer(0b10000110 | (byte)(2 << 3));
    digitalWrite(ADCCS_pin,HIGH);
    delayMicroseconds(200);
 
    digitalWrite(ADCCS_pin,LOW);
    byte upperbyte = SPI.transfer(0b0);
    digitalWrite(ADCCS_pin,HIGH);
	
    digitalWrite(ADCCS_pin,LOW);
    byte lowerbyte = SPI.transfer(0b0);
    digitalWrite(ADCCS_pin,HIGH);

}


unsigned int gFrameCount = 0;

void outputPixel(unsigned int val) {
    byte upperbyte = val >> 8;
    byte lowerbyte = val & 0xFF;
    Serial.write(lowerbyte);
    Serial.write(upperbyte);
}

void outputData() {
    for (int row = 0; row < ROW_CNT; row++) {
	for (int column = FIRST_COLUMN; column < COLUMN_CNT; column++) {
	    outputPixel(volume[row][column]);
	    blink();
	}
    }
}

void blink() {
/*     digitalWrite(12, HIGH); */
/*     delay(100); */
/*     digitalWrite(12, LOW); */
}

void logFrame() {
    gFrameCount++;
    if (gFrameCount % 30 == 0) {
	//blink();
    }
}

void loop() {
    for (int row = 0; row < ROW_CNT; row++) {
	row_on(row);
	for (int column = FIRST_COLUMN; column <= COLUMN_CNT; column++) {
	    column_on(column);
	    volume[row][column] = row_read(row);
	    //delay(250);
	}
	column_off();
    }

    if (Serial.available() > 0) {
	if (Serial.read() == 0xFF) {
	    outputData();
	    logFrame();
	}
    }
}

