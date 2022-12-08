#include "Servo.h"

Servo pinkyServo;

int one = 15;

void setup(){
  Serial.begin(115200);
  pinkyServo.attach(9);
}

//static scaling, maps to entire range of servo
void scaleLimits(int* hapticLimits, float* scaledLimits){
  for (int i = 0; i < 5; i++){
    scaledLimits[i] = 180.0f - hapticLimits[i] / 1000.0f * 180.0f;
  }
}

void writeServoHaptics(int* hapticLimits){
  float scaledLimits[5];
  scaleLimits(hapticLimits, scaledLimits);
  pinkyServo.write(scaledLimits[4]);
  Serial.print(scaledLimits[4]);
}

void loop() {
  writeServoHaptics(&one);
  Serial.print("ok");
  delay(2);

}
