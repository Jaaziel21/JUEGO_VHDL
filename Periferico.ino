// Generar un periférico que permita mover la raqueta dentro del juego mediante un acelerómetro
// Maximiliano De La Cruz Lima  A01798048
// Leyberth Jaaziel Castillo Guerra A01749505
// TE2002B

#include "Arduino_BMI270_BMM150.h"

float x, y, z;
const int izquierdaPin = 4;
const int derechaPin = 2;
int gradosX = 0;
int gradosY = 0;

void setup() {
  Serial.begin(9600);
  
  pinMode(izquierdaPin, OUTPUT);
  pinMode(derechaPin, OUTPUT);

  if (!IMU.begin()) {
    Serial.println("Error al iniciar el IMU!");
    while (1);
  }
  Serial.print("Accelerometer sample rate = ");
  Serial.print(IMU.gyroscopeSampleRate());
  Serial.println(" Hz");
}

void loop() {

  if (IMU.accelerationAvailable()) 
  {
    IMU.readAcceleration(x, y, z);

    //if (x > -0.49 && x < 0.49) {
      
    //}

    Serial.println(x);
    if(x > 0.2){
      x = 100*x;
      gradosX = map(x, 0, 97, 0, 90);
      Serial.print("Tilting up ");
      Serial.print(gradosX);
      Serial.println("  degrees");
      digitalWrite(izquierdaPin, HIGH);
      digitalWrite(derechaPin, LOW);
      Serial.println("izquierda");
      Serial.println(digitalRead(izquierdaPin));
      Serial.println(digitalRead(derechaPin));
    }
    else if(x < -0.2){
      x = 100*x;
      gradosX = map(x, 0, -100, 0, 90);
      Serial.print("Tilting down ");
      Serial.print(gradosX);
      Serial.println("  degrees");
      digitalWrite(derechaPin, HIGH);
      digitalWrite(izquierdaPin, LOW);
      Serial.println("derecha");
      Serial.println(digitalRead(izquierdaPin));
      Serial.println(digitalRead(derechaPin));
    }
    else {
      digitalWrite(izquierdaPin, LOW);
      digitalWrite(derechaPin, LOW);
    }
  }
}
