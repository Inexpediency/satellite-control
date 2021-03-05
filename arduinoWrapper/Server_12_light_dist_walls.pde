import processing.net.*;
Server Teacher;
Client Student;
String input;
int data[];

import processing.serial.*;
Serial port;
String inString;   // данные, получаемые с последовательного порта, в виде строки
int inByte;           // переменная для хранения полученного из порта числа


// принимаемые параметры:
int direction = 0;   // направление
int speed_left = 150;  // скорости
int speed_right = 150;
int brake_left = 50;
int brake_right = 50;
int frame_Rate = 30; // частота обновления экрана
int send_Number = 1; // переменная для счетчика отправки данных
int send_Rate = int (frame_Rate/2); // частота отправки данных (1 - каждый цикл draw, 2 - 1 раз в 2 цикла и т.д.)

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
  Teacher = new Server(this, 12345); // Start a simple server on a port

  println(Serial.list());
  // раскомментировать для связи с Arduino:
  port = new Serial(this, Serial.list()[1], 9600);
  // не генерировать serialEvent() пока не получен символ перехода на следующую строчку (т.е. число полностью передано):
  port.bufferUntil('\n');
}

void draw() {
  frameRate(frame_Rate);
  background(150);  // цвет экрана серый, экран перерисовывается при каждом цикле
 


  // ручное изменение параметров датчиков для тестирования визуализации
  // символы в латинской раскладке!
  if (keyPressed){ // если кнопка нажата
    if (key == 'r'){
      light_left = light_left + step;
    }
    if (key == 'f'){
      light_left = light_left - step;
    }
    if (key == 't'){
      light_forward = light_forward + step;
    }
    if (key == 'g'){
      light_forward = light_forward - step;
    }
    if (key == 'y'){
      light_right = light_right + step;
    }
    if (key == 'h'){
      light_right = light_right - step;
    }
    
    if (key == 'u'){
      dist_left = dist_left + step;
    }
    if (key == 'j'){
      dist_left = dist_left - step;
    }
    if (key == 'i'){
      dist_forward_left = dist_forward_left + step;
    }
    if (key == 'k'){
      dist_forward_left = dist_forward_left - step;
    }
    if (key == 'o'){
      dist_forward = dist_forward + step;
    }
    if (key == 'l'){
      dist_forward = dist_forward - step;
    }
    if (key == 'p'){
      dist_forward_right = dist_forward_right + step;
    }
    if (key == ';'){
      dist_forward_right = dist_forward_right - step;
    }
    if (key == '.'){
      dist_right = dist_right + step;
    }
    if (key == ','){
      dist_right = dist_right - step;
    }
  }
  fill (light_left);
  rect(0, 0, width/3, height);
  fill (light_forward);
  rect(width/3, 0, width*2/3, height);
  fill (light_right);
  rect(width*2/3, 0, width, height);
  
  
  fill(0, 0, 200);                  // заливаем кнопки синим цветом
  // рисуем левые кнопки
  rect(button_left_x, button_up_y, button_width, button_height);
  rect(button_left_x, button_middle_y, button_width, button_height);
  rect(button_left_x, button_down_y, button_width, button_height);
  // рисуем центральные (по горизонтали) кнопки:
  rect(button_middle_x, button_up_y, button_width, button_height);
  rect(button_middle_x, button_down_y, button_width, button_height);
  // рисуем правые кнопки:
  rect(button_right_x, button_up_y, button_width, button_height);
  rect(button_right_x, button_middle_y, button_width, button_height);
  rect(button_right_x, button_down_y, button_width, button_height);

  // рисуем эллипсы
  fill(255, 0, 0);  // заливка красным цветом
  ellipse(button_middle_x + 20, button_middle_y, diameter, diameter);
  ellipse(button_middle_x + 80, button_middle_y, diameter, diameter);
  ellipse(button_middle_x + 20, button_middle_y + 50, diameter, diameter);
  ellipse(button_middle_x + 80, button_middle_y + 50, diameter, diameter);


  // Принимаем данные с клиента
  // клиент передает данные командой
  // Student.write(direction + " " + speed_left + " " + speed_right + " " + brake_left + " " + brake_right + " " + frame_Rate + "\n");
  Student = Teacher.available();
  if (Student != null) {
    input = Student.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    direction = data[0];
    speed_left = data[1];
    speed_right = data[2];
    brake_left = data[3];
    brake_right = data[4];
    frame_Rate = data[5];
  }

  // для теста - имитации принятых сигналов в отсутствие клиента
  if (keyPressed) {
    direction = int(key) - 48 ;
  }
  
  // показ управляющих команд Клиента в Мониторе порта
  print(direction + "," + speed_left + "," + speed_right + "," + brake_left + "," + brake_right + "," + frame_Rate + "\n");
  
  // ограничиваем отправку данных (не каждый цикл, чтобы не забивать порт)
  if (send_Number >= send_Rate){
    // передаем данные серверу: направление, скорости, частоту обновления экрана 
    // и параллельно печатаем
    // раскомментировать для отправки данных в Arduino:
    port.write(direction + "," + speed_left + "," + speed_right + "," + brake_left + "," + brake_right + "*" + "\n");
    //port.write("1,150,150,50,50,10*"); // для теста отправки
    
    // передаем данные с датчиков Arduino Клиенту
    Teacher.write(light_left + " " + light_forward + " " + light_right + " " + dist_left + " " + dist_forward_left + " " 
    + dist_forward + " " + dist_forward_right + " " + dist_right + "\n");
    
    send_Number = 1;
  }
  send_Number = send_Number + 1;
 
  


  switch (direction) {
    case 1:
      fill(0, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y, diameter, diameter);
      ellipse(button_middle_x + 80, button_middle_y, diameter, diameter);
      fill(0, 50, 255);
      rect(button_middle_x, button_up_y, button_width, button_height);
      break;

    case 2:
      fill(0, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y + 50, diameter, diameter);
      ellipse(button_middle_x + 80, button_middle_y + 50, diameter, diameter);
      fill(0, 50, 255);
      rect(button_middle_x, button_down_y, button_width, button_height);
      break;

    case 3:
      fill(0, 255, 0);
      ellipse(button_middle_x + 80, button_middle_y, diameter, diameter);
      ellipse(button_middle_x + 20, button_middle_y + 50, diameter, diameter);
      fill(0, 50, 255);
      rect(button_left_x, button_middle_y, button_width, button_height);
      break;

    case 4:
      fill(0, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y, diameter, diameter);
      ellipse(button_middle_x + 80, button_middle_y + 50, diameter, diameter);
      fill(0, 50, 255);
      rect(button_right_x, button_middle_y, button_width, button_height);
      break;

    case 5:
      fill(255, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y, diameter, diameter);
      fill(0, 255, 0);
      ellipse(button_middle_x + 80, button_middle_y, diameter, diameter);
      fill(0, 50, 255);
      rect(button_left_x, button_up_y, button_width, button_height);
      break;

    case 6:
      fill(0, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y, diameter, diameter);
      fill(255, 255, 0);
      ellipse(button_middle_x + 80, button_middle_y, diameter, diameter);
      fill(0, 50, 255);
      rect(button_right_x, button_up_y, button_width, button_height);
      break;

    case 7:
      fill(255, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y + 50, diameter, diameter);
      fill(0, 255, 0);
      ellipse(button_middle_x + 80, button_middle_y + 50, diameter, diameter);
      fill(0, 50, 255);
      rect(button_left_x, button_down_y, button_width, button_height);
      break;

    case 8:
      fill(0, 255, 0);
      ellipse(button_middle_x + 20, button_middle_y + 50, diameter, diameter);
      fill(255, 255, 0);
      ellipse(button_middle_x + 80, button_middle_y + 50, diameter, diameter);
      fill(0, 50, 255);
      rect(button_right_x, button_down_y, button_width, button_height);
      break;
  }
  
  
  // рисуем текстовые обозначения на кнопках:
  fill(255);
  textSize(20);
  text("ВПЕРЕД", button_middle_x + 15, button_up_y + 35);
  text("НАЗАД", button_middle_x + 15, button_down_y + 35);
  text("ВЛЕВО", button_left_x + 15, button_middle_y + 35);
  text("ВПРАВО", button_right_x + 15, button_middle_y + 35);

  textSize(12);
  text("ВПЕРЕД-ВЛЕВО", button_left_x + 1, button_up_y + 35);
  text("ВПЕРЕД-ВПРАВО", button_right_x + 1, button_up_y + 35);
  text("НАЗАД-ВЛЕВО", button_left_x + 1, button_down_y + 35);
  text("НАЗАД-ВПРАВО", button_right_x + 1, button_down_y + 35);
  
  
  // рисуем контуры "помещения" по датчикам расстояния
  strokeWeight(5);  // увеличить толщину линий "стенок"
  line (width/2 - dist_left, height - dist_forward - dist_width/2, width/2 - dist_left, height);   // левая стенка
  line (width/2 - dist_left , height - dist_forward - dist_width/2, dist_right + width/2, height - dist_forward - dist_width/2); // передняя стенка
  line (dist_right + width/2, height - dist_forward - dist_width/2, dist_right + width/2, height); // правая стенка
  strokeWeight(1);  // вернуть стандартную толщину линий
  //line (width/2 - dist_forward_left - dist_width, height, width/2 , height - dist_forward_left - dist_width); // передняя левая стенка (не совсем корректно)
  //line (dist_forward_right + width/2 - dist_width, height, width/2 + dist_width/2, height - dist_forward_right);
  
   // рисуем прямоугольники для расстояния
  fill (255, 255, 0, 70);          // добавляем прозрачность (четвертое число), чтобы прямоугольники не закрывали интерфейс
  translate (width/2, height-dist_width/2);   // переносим начало координат в центр по горизонтали и вниз
  // поворачиваем прямоугольние левого расстояния из исходного направления (вниз) на 90 градусов по часовой стрелке
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

// прием данных с солнечных батарей
void serialEvent(Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // split the string on the commas and convert the resulting substrings
      // into an integer array:
      float[] colors = float(split(inString, ","));
      // if the array has at least three elements, you know you got the whole
      // thing.  Put the numbers in the color variables: 
      if (colors.length >= 8) {
        // map them to the range 0-255:
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
