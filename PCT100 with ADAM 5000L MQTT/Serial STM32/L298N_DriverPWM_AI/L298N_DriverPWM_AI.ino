int pinAI = A0;
int sinyalADAM, sinyalPWM = 0;
void setup() {
  Serial.begin(115200);
  pinMode(3, OUTPUT); 
  TCCR2B = TCCR2B & B11111000 | B00000001; // for PWM frequency of 31372.55 Hz
}

void loop() {
  // read the value from the sensor:
  sinyalADAM = analogRead(pinAI);
  sinyalPWM = map(sinyalADAM,0,1023,255,0); // PWM untuk buka valve (0% = 0V = full close)
  analogWrite(3, sinyalPWM);
  Serial.print("Sinyal Masuk = ");
  Serial.print(sinyalADAM);
  Serial.print(" | Sinyal Keluar = ");
  Serial.println(sinyalPWM);
}
