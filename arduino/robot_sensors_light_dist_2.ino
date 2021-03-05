// управляемые пины
int ledPin = 13;
int LF = 3;
int LB = 5;
int RF = 9;
int RB = 6;

// параметры движения
int motor_direction = 0;   // направление
int speed_left = 150;
int speed_right = 150;
int brake_left = 100;
int brake_right = 100;

// переменные для ограничения передаваемой информации
int send_Number = 1; // переменная для счетчика отправки данных
int send_Rate = 4; // частота отправки данных (1 - каждый цикл draw, 2 - 1 раз в 2 цикла и т.д.)

// переменные для приема из Serial порта
String readString; //main captured String
String motor_direction_str; //data String
String speed_left_str;
String speed_right_str;
String brake_left_str;
String brake_right_str;
int ind1; // , locations
int ind2;
int ind3;
int ind4;
int ind5;

// переменные для опроса солнечных батарей
int light_left = A5;
int light_forward = A7;
int light_right = A6;

// переменные для опроса датчиков расстояния
int dist_left = 100;
int dist_forward_left = 100;
int dist_forward = 100;
int dist_forward_right = 100;
int dist_right = 100;

// подключаем датчик расстояния. Библиотека из статьи http://robocraft.ru/blog/electronics/772.html
// там же описано в комментариях, как можно уменьшить таймаут при отсутствии обратного сигнала, модифицировав код в библиотеке
#include "Ultrasonic.h"
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
// Перевод аналоговых портов: А0=14, А1=15, А2=16, А3=17, А4=18, А5=19, А6=20, А7=21. А6 и А7 не работают как цифровые

void setup() {
  pinMode(LF, OUTPUT);
  pinMode(LB, OUTPUT);
  pinMode(RF, OUTPUT);
  pinMode(RB, OUTPUT);
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
}

void loop() {

  // ограничение измерений и передачи информации - не каждый цикл
  // ограничиваем отправку данных (не каждый цикл, чтобы не забивать порт)
  if (send_Number >= send_Rate) {
    // возможно, сюда воткнуть стоп моторам, чтобы робот не "завис" в каком-то направлении из-за датчика, а delay в конце немного увеличить
    // измерение датчиками расстояния
    dist_left = int(dist_left_sensor.Ranging(CM));
    dist_forward_left = int(dist_forward_left_sensor.Ranging(CM));
    dist_forward = int(dist_forward_sensor.Ranging(CM));
    dist_forward_right = int(dist_forward_right_sensor.Ranging(CM));
    dist_right = int(dist_right_sensor.Ranging(CM));

    // измерение и вывод данных с СБ
    Serial.print(analogRead(light_left));
    Serial.print(",");
    Serial.print(analogRead(light_forward));
    Serial.print(",");
    Serial.print(analogRead(light_right));
    Serial.print(",");

    // вывод данных датчиков расстояния
    Serial.print(dist_left);
    Serial.print(",");
    Serial.print(dist_forward_left);
    Serial.print(",");
    Serial.print(dist_forward);
    Serial.print(",");
    Serial.print(dist_forward_right);
    Serial.print(",");
    Serial.println(dist_right);

    send_Number = 1;
  }
  send_Number = send_Number + 1;

  // прием данных, по примеру https://forum.arduino.cc/index.php?topic=387175.msg2668879#msg2668879
  // передача из Processing сделана командой:
  // port.write(direction + "," + speed_left + "," + speed_right + "," + brake_left + "," + brake_right + "*" + "\n");
  if (Serial.available())  {
    char c = Serial.read();  //gets one byte from serial buffer
    if (c == '*') {     // если конец строки (звездочка) - разбираем строку на части по разделителям (запятые)
      //Serial.println(readString); //prints string to serial port out
      ind1 = readString.indexOf(',');  //finds location of first ,
      motor_direction_str = readString.substring(0, ind1);   //captures first data String
      ind2 = readString.indexOf(',', ind1 + 1 ); //finds location of second ,
      speed_left_str = readString.substring(ind1 + 1, ind2 + 1); //captures second data String
      ind3 = readString.indexOf(',', ind2 + 1 );
      speed_right_str = readString.substring(ind2 + 1, ind3 + 1);
      ind4 = readString.indexOf(',', ind3 + 1 );
      brake_left_str = readString.substring(ind3 + 1, ind4 + 1);
      ind5 = readString.indexOf(',', ind4 + 1 );
      brake_right_str = readString.substring(ind4 + 1); //captures remain part of data after last ,

      // преобразуем вырезанные части (тип String) в числа:
      motor_direction = motor_direction_str.toInt();
      speed_left = speed_left_str.toInt();
      speed_right = speed_right_str.toInt();
      brake_left = brake_left_str.toInt();
      brake_right = brake_right_str.toInt();

      //обнуляем переменные для новых входов:
      readString = "";
      motor_direction_str = "";
      speed_left_str = "";
      speed_right_str = "";
      brake_left_str = "";
      brake_right_str = "";
    }
    else {
      readString += c; // добавляем прочитанный символ к строке readString (если на конце не звездочка)
    }
  }

  // вывод полученных команд
  /*
    Serial.print(motor_direction);
    Serial.print(",");
    Serial.print(speed_left);
    Serial.print(",");
    Serial.print(speed_right);
    Serial.print(",");
    Serial.print(speed_left);
    Serial.print(",");
    Serial.print(brake_left);
    Serial.print(",");
    Serial.println(brake_right);
    Serial.println();
  */

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
  //delay(2);
}
