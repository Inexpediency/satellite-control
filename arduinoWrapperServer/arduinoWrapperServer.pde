import processing.net.*;
import processing.serial.*;

final boolean DEV = true;

Server Teacher;
Client Student;

String input;
int data[];

Serial port;
String inString; // данные, получаемые с последовательного порта, в виде строки
int inByte; // переменная для хранения полученного из порта числа

// принимаемые параметры:
int direction = 0;   // направление
int speed_left = 150;  // скорости
int speed_right = 150;
int brake_left = 50;
int brake_right = 50;
int frame_Rate = 30; // частота обновления экрана
int send_Number = 1; // переменная для счетчика отправки данных
int send_Rate = int(frame_Rate / 2); // частота отправки данных (1 - каждый цикл draw, 2 - 1 раз в 2 цикла и т.д.)

// передаваемые параметры
int light_left = 100;
int light_forward = 100;
int light_right = 100;
int dist_left = 100;
int dist_forward_left = 100;
int dist_forward = 100;
int dist_forward_right = 100;
int dist_right = 100;

int step = 5; // шаг изменения для ручного изменения параметров для тестов
int dist_width = 50; // ширина прямоугольников для отрисовки расстояния

// параметры отрисовки
int diameter = 25;
int button_width = 100;  // ширина кнопки
int button_height = 50;   // высота кнопки

// координаты левых точек кнопок по горизонтали:
int button_left_x = 100;
int button_middle_x = 250;
int button_right_x = 400;
// координаты верхних точек кнопок по вертикали:
int button_up_y = 100;
int button_middle_y = 200;
int button_down_y = 300;

void setup()
{
  size(800, 600);
  background(204);
  stroke(0);

  if (!DEV) {
    Teacher = new Server(this, 12345);
    port = new Serial(this, Serial.list()[1], 9600);
    port.bufferUntil('\n');
  }
}

void draw() {
  frameRate(frame_Rate);
  initialUI();
  
  manualSensorChanging();

  // Data from client. Format is:
  // Student.write(direction + " " + speed_left + " " + speed_right + " " + brake_left + " " + brake_right + " " + frame_Rate + "\n");
  if (!DEV) Student = Teacher.available();
  if (Student != null) {
    input = Student.readString();
    input = input.substring(0, input.indexOf("\n"));
    data = int(split(input, ' '));
    
    direction = data[0];
    speed_left = data[1];
    speed_right = data[2];
    brake_left = data[3];
    brake_right = data[4];
    frame_Rate = data[5];
  }

  print(direction + "," + speed_left + "," + speed_right + "," + brake_left + "," + brake_right + "," + frame_Rate + "\n");

  if (!DEV) {
    if (send_Number >= send_Rate) {
      port.write(direction + "," + speed_left + "," + speed_right + "," + brake_left + "," + brake_right + "*" + "\n");
      Teacher.write(light_left + " " + light_forward + " " + light_right + " " + dist_left + " " + dist_forward_left + " " 
        + dist_forward + " " + dist_forward_right + " " + dist_right + "\n");

      send_Number = 1;
    }
    send_Number = send_Number + 1;
  }
  
  drawSpaceBoundaries();
}

void initialUI() {
  background(150);
  fill(light_left);
  rect(0, 0, width/3, height);
  fill (light_forward);
  rect(width/3, 0, width*2/3, height);
  fill (light_right);
  rect(width*2/3, 0, width, height);
}

void drawSpaceBoundaries() {
  strokeWeight(5); 
  line (width/2 - dist_left, height - dist_forward - dist_width/2, width/2 - dist_left, height); 
  line (width/2 - dist_left, height - dist_forward - dist_width/2, dist_right + width/2, height - dist_forward - dist_width/2);
  line (dist_right + width/2, height - dist_forward - dist_width/2, dist_right + width/2, height);
  strokeWeight(1); 

  fill (255, 255, 0, 70);   
  translate (width/2, height-dist_width/2); 
  rotate (radians(90)); 
  rect (-dist_width/2, 0, dist_width, dist_left);
  rotate (radians(45));
  rect (-dist_width/2, 0, dist_width, dist_forward_left);
  rotate (radians(45));
  rect (-dist_width/2, 0, dist_width, dist_forward);
  rotate (radians(45));
  rect (-dist_width/2, 0, dist_width, dist_forward_right);
  rotate (radians(45));
  rect (-dist_width/2, 0, dist_width, dist_right);
}

void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    float[] colors = float(split(inString, ","));
    
    if (colors.length >= 8) {
      light_left = int(map(colors[0], 0, 1023, 0, 255));
      light_forward = int(map(colors[1], 0, 1023, 0, 255));
      light_right = int(map(colors[2], 0, 1023, 0, 255));

      dist_left = int(10 * colors[3]);
      dist_forward_left = int(10 * colors[4]);
      dist_forward = int(10 * colors[5]);
      dist_forward_right = int(10 * colors[6]);
      dist_right = int(10 * colors[7]);
    }
  }
}

void manualSensorChanging() {
  if (keyPressed) { // если кнопка нажата
    if (key == 'r') {
      light_left = light_left + step;
    }
    if (key == 'f') {
      light_left = light_left - step;
    }
    if (key == 't') {
      light_forward = light_forward + step;
    }
    if (key == 'g') {
      light_forward = light_forward - step;
    }
    if (key == 'y') {
      light_right = light_right + step;
    }
    if (key == 'h') {
      light_right = light_right - step;
    }
    if (key == 'u') {
      dist_left = dist_left + step;
    }
    if (key == 'j') {
      dist_left = dist_left - step;
    }
    if (key == 'i') {
      dist_forward_left = dist_forward_left + step;
    }
    if (key == 'k') {
      dist_forward_left = dist_forward_left - step;
    }
    if (key == 'o') {
      dist_forward = dist_forward + step;
    }
    if (key == 'l') {
      dist_forward = dist_forward - step;
    }
    if (key == 'p') {
      dist_forward_right = dist_forward_right + step;
    }
    if (key == ';') {
      dist_forward_right = dist_forward_right - step;
    }
    if (key == '[') {
      dist_right = dist_right + step;
    }
    if (key == '\'') {
      dist_right = dist_right - step;
    }
  }
}
