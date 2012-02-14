import processing.opengl.*;

import processing.serial.*;
Serial port;

final int row_cnt = 8;
final int column_cnt = 22;

int[][] data = new int[row_cnt][column_cnt];
int current_row = 0;

int window_width = 700;
int window_height = 900;

void setup()
{
    // Set window size;
    size(window_width, window_height, OPENGL);

    println(Serial.list());
    port = new Serial(this, Serial.list()[0], 230400);

    //port.clear(); 
    //port.buffer(row_cnt*column_cnt*2);
  
    background(255);
    for (int i = 0; i < row_cnt; i++) {
	for (int j = 0; j < column_cnt; j++) {
	    data[i][j] = 0;
	}
    }

    while (port.available() == 0) {
	signal();
	delay(1);
    }
}

void signal() {
    port.write(0xFF);
}

void readData() {
    for (int row = 0; row < row_cnt; row++) {
	for (int column = 0; column < column_cnt; column++) {
	    int lowerbyte = port.readChar();
	    int upperbyte = port.readChar();
	    println(upperbyte << 8 | lowerbyte);
	    data[row][column] = (upperbyte << 8 | lowerbyte);
	}
    }
}

void keyPressed()
{
}

void draw()
{

    if (port.available() >= (row_cnt * column_cnt * 2)) {
	//println(port.available());
	//print("d");
	readData();
	signal();
	//println(port.available());
    }
    background(255);
    //rotateZ(.75);
    rotateX(.75);
    //print("F");

    for (int i = 0; i < row_cnt; i++)
	{
	    for (int j = 0; j < column_cnt; j++)
		{
		    int raw_value = max(data[i][j], 15);
		    float calibrated_value = 8.0*sqrt(2048.0/raw_value);
		    //fill(data[i][j]*2);
		    //stroke(data[i][j]*2);
		    //ellipse((j + 1)*30,(i + 1)*30,30,30);
		    //fill(0);
		    stroke(0);
		    fill(255 - (255.0*raw_value/384.0));
		    //noStroke();
		    //lights();
		    pushMatrix();
		    //      translate(200 + (i + 1)*30,50+(j + 1)*30,-100+calibrated_value/2.0);
		    //      box(30,30,calibrated_value);
		    translate(200 + (i + 1)*30,50+(j + 1)*30 +50,-100+calibrated_value);
		    //      sphere(2.0,2.0,2.0);
		    box(10.0,10.0,10.0);
		    popMatrix();
		}
	}
    
}

/* void serialEvent(Serial port) { */
/*     readData(); */
/* } */


