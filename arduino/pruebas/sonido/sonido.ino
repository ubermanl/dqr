#define PIN_SOUND_SENSOR A0

void setup() {
  // put your setup code here, to run once:
  pinMode(PIN_SOUND_SENSOR, INPUT);   
}

void loop() {
  Serial.begin(9600);
  // put your main code here, to run repeatedly:
  double a = analogRead(PIN_SOUND_SENSOR);
  Serial.println(a);
  delay(125);

}
