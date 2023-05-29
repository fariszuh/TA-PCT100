void setup() {
  pinMode(3, OUTPUT); 
//  analogWrite(3,12);
  TCCR2B = TCCR2B & B11111000 | B00000001; // for PWM frequency of 31372.55 Hz
}

void loop() {
  
//   Accelerate from zero to maximum speed
  for (int i = 0; i < 256; i++) {
    analogWrite(3, i);
    delay(20);
  }
  
  // Decelerate from maximum speed to zero
  for (int i = 255; i >= 0; --i) {
    analogWrite(3, i);
    delay(20);
  }
}
