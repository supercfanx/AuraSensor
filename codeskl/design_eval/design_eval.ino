void setup() {
  Serial.begin(9600);
    digitalWrite(13, LOW);
    //digitalWrite(12, LOW);
}


void loop() {
 digitalWrite(9, HIGH);
 Serial.println(analogRead(A0));
 digitalWrite(9, LOW);
delay(100); 
}
