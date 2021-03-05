#include "Ultrasonic.h"

class SensorsData {
  public:
    int light_left;
    int light_forward;
    int light_right;

    int dist_left;
    int dist_forward_left;
    int dist_forward;
    int dist_forward_right;
    int dist_right;

    SensorsData(
      int light_left,
      int light_forward,
      int light_right,
      int dist_left,
      int dist_forward_left,
      int dist_forward,
      int dist_forward_right,
      int dist_right
    ) {
      this->light_left = light_left;
      this->light_forward = light_forward;
      this->light_right = light_right;

      this->dist_left = dist_left;
      this->dist_forward_left = dist_forward_left;
      this->dist_forward = dist_forward;
      this->dist_forward_right = dist_forward_right;
      this->dist_right = dist_right;
    }

    SensorsData copy() {
      return SensorsData(
               this->light_left,
               this->light_forward,
               this->light_right,
               this->dist_left,
               this->dist_forward_left,
               this->dist_forward,
               this->dist_forward_right,
               this->dist_right
             );
    }

    bool equals(SensorsData another) {
      if (
        this->light_left != another.light_left ||
        this->light_forward != another.light_forward ||
        this->light_right != another.light_right ||
        this->dist_left != another.dist_left ||
        this->dist_forward_left != another.dist_forward_left ||
        this->dist_forward != another.dist_forward ||
        this->dist_forward_right != another.dist_forward_right ||
        this->dist_right != another.dist_right
      ) return false;

      return true;
    }

    void printSerialized() {
      Serial.print(this->light_left);
      Serial.print(",");
      Serial.print(this->light_forward);
      Serial.print(",");
      Serial.print(this->light_right);
      Serial.print(",");

      Serial.print(this->dist_left);
      Serial.print(",");
      Serial.print(this->dist_forward_left);
      Serial.print(",");
      Serial.print(this->dist_forward);
      Serial.print(",");
      Serial.print(this->dist_forward_right);
      Serial.print(",");
      Serial.println(this->dist_right);
    }
};

SensorsData sensorsData = SensorsData(0,0,0,0,0,0,0,0);
SensorsData previousState = SensorsData(0,0,0,0,0,0,0,0);

int ledPin = 13;
int LF = 3;
int LB = 5;
int RF = 9;
int RB = 6;

int motor_direction = 0;
int speed_left = 150;
int speed_right = 150;
int brake_left = 100;
int brake_right = 100;

String readString;
String motor_direction_str;
String speed_left_str;
String speed_right_str;
String brake_left_str;
String brake_right_str;
int ind1;
int ind2;
int ind3;
int ind4;
int ind5;

int light_left = A5;
int light_forward = A7;
int light_right = A6;

int trig_left = 7;
int echo_left = 8;
Ultrasonic dist_left_sensor(trig_left, echo_left);

int trig_forward_left = 10;
int echo_forward_left = 11;
Ultrasonic dist_forward_left_sensor(trig_forward_left, echo_forward_left);

int trig_forward = 12;
int echo_forward = 14;  // А0
Ultrasonic dist_forward_sensor(trig_forward, echo_forward);

int trig_forward_right = 15;  // А1
int echo_forward_right = 16;  // А2
Ultrasonic dist_forward_right_sensor(trig_forward_right, echo_forward_right);

int trig_right = 17;  // А3
int echo_right = 18;  // А4
Ultrasonic dist_right_sensor(trig_right, echo_right);

void setup() {
  pinMode(LF, OUTPUT);
  pinMode(LB, OUTPUT);
  pinMode(RF, OUTPUT);
  pinMode(RB, OUTPUT);

  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  sensorsData.dist_left = int(dist_left_sensor.Ranging(CM));
  sensorsData.dist_forward_left = int(dist_forward_left_sensor.Ranging(CM));
  sensorsData.dist_forward = int(dist_forward_sensor.Ranging(CM));
  sensorsData.dist_forward_right = int(dist_forward_right_sensor.Ranging(CM));
  sensorsData.dist_right = int(dist_right_sensor.Ranging(CM));

  sensorsData.light_left = analogRead(light_left);
  sensorsData.light_forward = analogRead(light_forward);
  sensorsData.light_right = analogRead(light_right);

  if (!sensorsData.equals(previousState)) {
    sensorsData.printSerialized();
    previousState = sensorsData.copy();
  }

  // port.write(direction + "," + speed_left + "," + speed_right + "," + brake_left + "," + brake_right + "*" + "\n");
  if (Serial.available())  {
    char c = Serial.read(); 
    if (c == '*') {   
      ind1 = readString.indexOf(','); 
      motor_direction_str = readString.substring(0, ind1); 
      ind2 = readString.indexOf(',', ind1 + 1 ); 
      speed_left_str = readString.substring(ind1 + 1, ind2 + 1);
      ind3 = readString.indexOf(',', ind2 + 1 );
      speed_right_str = readString.substring(ind2 + 1, ind3 + 1);
      ind4 = readString.indexOf(',', ind3 + 1 );
      brake_left_str = readString.substring(ind3 + 1, ind4 + 1);
      ind5 = readString.indexOf(',', ind4 + 1 );
      brake_right_str = readString.substring(ind4 + 1);

      motor_direction = motor_direction_str.toInt();
      speed_left = speed_left_str.toInt();
      speed_right = speed_right_str.toInt();
      brake_left = brake_left_str.toInt();
      brake_right = brake_right_str.toInt();

      readString = "";
      motor_direction_str = "";
      speed_left_str = "";
      speed_right_str = "";
      brake_left_str = "";
      brake_right_str = "";
    }
    else {
      readString += c;
    }
  }

  switch (motor_direction) {
    case 1: // Вперед
      analogWrite(LF, speed_left);
      analogWrite(LB, 0);
      analogWrite(RF, speed_right);
      analogWrite(RB, 0);
      digitalWrite(ledPin, HIGH);
      break;

    case 2: // Назад
      analogWrite(LF, 0);
      analogWrite(LB, speed_left);
      analogWrite(RF, 0);
      analogWrite(RB, speed_right);
      digitalWrite(ledPin, LOW);
      break;

    case 3: // Влево
      analogWrite(LF, 0);
      analogWrite(LB, int(speed_left * 3 / 5));
      analogWrite(RF, int(speed_right * 3 / 5));
      analogWrite(RB, 0);
      break;

    case 4: // Вправо
      analogWrite(LF, int(speed_left * 3 / 5));
      analogWrite(LB, 0);
      analogWrite(RF, 0);
      analogWrite(RB, int(speed_right * 3 / 5));
      break;

    case 5: // Вперед Влево
      analogWrite(LF, brake_left);
      analogWrite(LB, 0);
      analogWrite(RF, speed_right);
      analogWrite(RB, 0);
      break;

    case 6: // Вперед Вправо
      analogWrite(LF, speed_left);
      analogWrite(LB, 0);
      analogWrite(RF, brake_right);
      analogWrite(RB, 0);
      break;

    case 7: // Назад Влево
      analogWrite(LF, 0);
      analogWrite(LB, brake_left);
      analogWrite(RF, 0);
      analogWrite(RB, speed_right);
      break;

    case 8: // Назад Вправо
      analogWrite(LF, 0);
      analogWrite(LB, speed_left);
      analogWrite(RF, 0);
      analogWrite(RB, brake_right);
      break;

    default: // Стоп
      analogWrite(LF, 0);
      analogWrite(LB, 0);
      analogWrite(RF, 0);
      analogWrite(RB, 0);
  }
}
