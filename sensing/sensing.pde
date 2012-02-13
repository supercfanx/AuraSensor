import processing.opengl.*;

import processing.serial.*;
Serial port;

final int row_cnt = 8;
final int column_cnt = 22;

int[][] data = new int[row_cnt][column_cnt];
int current_row = 0;

int window_width = 700;
int window_height = 900;
boolean waiting_for_data;


void setup()
{
  // Set window size;
  size(window_width, window_height,OPENGL);
  // List all the port on the machine;
  println(Serial.list());
  // open the first port
  // If you know the name of the port used by the Arduino board, you
  // can specify it directly like this.
  //port = new Serial(this, "COM1", 9600);
  port = new Serial(this, Serial.list()[0], 230400);
  //port = new Serial(this, Serial.list()[0], 115200);
  port.clear(); 
  port.buffer(row_cnt*column_cnt*2);
  
  waiting_for_data = true;
  // clear the screen
  background(255);
  int i;
  int j;
  for (i = 0; i < row_cnt; i++)
  {
    for (j = 0; j < column_cnt; j++)
    {
      data[i][j] = 0;
    }
  }

}

void keyPressed()
{
}

void draw()
{
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
  print("d");
}

void serialEvent(Serial port) {
    for (current_row = 0; current_row < row_cnt; current_row++){
      for (int i = 0; i < column_cnt; i++) {
      int upperbyte = port.readChar();
      int lowerbyte = port.readChar();
      data[current_row][i] = (upperbyte << 8 | lowerbyte);
    }
    }
    print("s");
}


