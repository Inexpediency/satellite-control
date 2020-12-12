import processing.net.*;
import java.util.List;
import java.util.HashMap;

final boolean IS_DEV = true; // DEV -> 0; PROD -> 1;

final float x1 = 100;
final float x2 = 250;
final float x3 = 400;
final float x4 = 650;
final float x5 = 800;

final float y1 = 100;
final float y2 = 200;
final float y3 = 300;
final float y4 = 400;
final float y5 = 500;

final float diameter = 30;

Boolean isForward = false;
Boolean isLeft = false;
Boolean isRight = false;
Boolean isDown = false;

final int maxDrawableDist = 100; 

EventManager eventManager;
List<Button> buttons;
HashMap<String, Button> movementButtons;
Repository repository;
MovementData movementData;

void setup() {
  size(1000, 600);
  background(150);
  stroke(0);
  
  Client server = new Client(this, "someport", 1234);

  if (IS_DEV) {
    movementData = new MovementData();
  } else {
    movementData = new MovementData(server);
  }

  repository = new Repository();
  eventManager = new EventManager(repository);

  if (!IS_DEV) {
    eventManager.subscribe(new ServerListener(server)); 
  }
  eventManager.subscribe(new Printer());
  
  movementButtons = new HashMap<String, Button>();
  buttons = new ArrayList<Button>();

  // init movement buttons
  Button forwardButton = new Button("forward", x2, y1, eventManager);
  buttons.add(forwardButton);
  movementButtons.put("forward", forwardButton);

  Button downButton = new Button("down", x2, y3, eventManager);
  buttons.add(downButton);
  movementButtons.put("down", downButton);

  Button leftButton = new Button("left", x1, y2, eventManager);
  buttons.add(leftButton);
  movementButtons.put("left", leftButton);

  Button rightButton = new Button("right", x3, y2, eventManager);
  buttons.add(rightButton);
  movementButtons.put("right", rightButton);
  
  Button forwardLeftButton = new Button("forwardLeft", x1, y1, eventManager);
  buttons.add(forwardLeftButton);
  movementButtons.put("forwardLeft", forwardLeftButton);

  Button forwardRightButton = new Button("forwardRight", x3, y1, eventManager);
  buttons.add(forwardRightButton);
  movementButtons.put("forwardRight", forwardRightButton);

  Button downLeftButton = new Button("downLeft", x1, y3, eventManager);
  buttons.add(downLeftButton);
  movementButtons.put("downLeft", downLeftButton);

  Button downRightButton = new Button("downRight", x3, y3, eventManager);
  buttons.add(downRightButton);
  movementButtons.put("downRight", downRightButton);
  
  // init control buttons
  buttons.add(new Button("speedLeft-", x4, y1, eventManager));
  buttons.add(new Button("speedLeft+", x5, y1, eventManager));
  buttons.add(new Button("speedRight-", x4, y2, eventManager));
  buttons.add(new Button("speedRight+", x5, y2, eventManager));
  
  buttons.add(new Button("brakeLeft-", x4, y3, eventManager));
  buttons.add(new Button("brakeLeft+", x5, y3, eventManager));
  buttons.add(new Button("brakeRight-", x4, y4, eventManager));
  buttons.add(new Button("brakeRight+", x5, y4, eventManager));
  
  buttons.add(new Button("frameRate-", x1, y4, eventManager)); 
  buttons.add(new Button("frameRate+", x2, y4, eventManager));
  buttons.add(new Button("sendRate-", x1, y5, eventManager)); 
  buttons.add(new Button("sendRate+", x2, y5, eventManager));
}

void draw() {
  background(150);
  frameRate(repository.getFrameRate());

  if (IS_DEV) {
    movementData.updateDataManually();
    print(movementData.serialize());
  } else {
    movementData.updateData();
  }
  
  updateLightPanels(
    movementData.getLightLeft(),
    movementData.getLightForward(),
    movementData.getLightRight()
  );
  
  updateRadar(
    movementData.getDistLeft(),
    movementData.getDistForwardLeft(), 
    movementData.getDistForward(),
    movementData.getDistForwardRight(),
    movementData.getDistRight()
  );
  
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).print();
  }
  drawCircles();
  
  handleButtonsMovement(eventManager);
  
  if (mousePressed && mouseButton == LEFT) {
    for (int i = 0; i < buttons.size(); i++) {
      buttons.get(i).update();
    }
  } else if (!isSomeMovementButtonPressed()) {
    eventManager.notify("chill");
  }
  
  updateCircles(repository);
}

Boolean isSomeMovementButtonPressed() {
  return isForward || isDown || isLeft || isRight;
}

void handleButtonsMovement(EventManager eventManager) {
  if (isForward && isRight) {
    movementButtons.get("forwardRight").setPressed();
    eventManager.notify("forwardRight");
  } else if (isForward && isLeft) {
    movementButtons.get("forwardLeft").setPressed();
    eventManager.notify("forwardLeft");
  } else if (isDown && isRight) {
    movementButtons.get("downRight").setPressed();
    eventManager.notify("downRight");
  } else if (isDown && isLeft) {
    movementButtons.get("downLeft").setPressed();
    eventManager.notify("downLeft");
  } else if (isForward) {
    movementButtons.get("forward").setPressed();
    eventManager.notify("forward");
  } else if (isDown) {
    movementButtons.get("down").setPressed();
    eventManager.notify("down");
  } else if (isLeft) {
    movementButtons.get("left").setPressed();
    eventManager.notify("left");
  } else if (isRight) {
    movementButtons.get("right").setPressed();
    eventManager.notify("right");
  }
}

void keyPressed() {
  switch (key) {
    case 'w':
      isForward = true;
      break;
    case 'a':
      isLeft = true;
      break;
    case 'd':
      isRight = true;
      break;
    case 's':
      isDown = true;
      break;
  }
}

void keyReleased() {
  switch (key) {
    case 'w':
      isForward = false;
      break;
    case 'a':
      isLeft = false;
      break;
    case 'd':
      isRight = false;
      break;
    case 's':
      isDown = false;
      break;
  }
}

void drawCircles() {
  fill(255, 0, 0); 
  ellipse(x2 + 20, y2, diameter, diameter);
  ellipse(x2 + 80, y2, diameter, diameter);
  ellipse(x2 + 20, y2 + 50, diameter, diameter);
  ellipse(x2 + 80, y2 + 50, diameter, diameter);
}

void fillYellow() { fill(255, 255, 1); }
void fillGreen() { fill(0, 255, 0); }

void updateCircles(Repository repository) {
  switch (repository.direction) {
    case 1:
      fillGreen();
      ellipse(x2 + 20, y2, diameter, diameter);
      ellipse(x2 + 80, y2, diameter, diameter);
      break;
    case 2:
      fillGreen();
      ellipse(x2 + 20, y2 + 50, diameter, diameter);
      ellipse(x2 + 80, y2 + 50, diameter, diameter);
      break;
    case 3:
      fillGreen();
      ellipse(x2 + 80, y2, diameter, diameter);
      ellipse(x2 + 20, y2 + 50, diameter, diameter);
      break;
    case 4: 
      fillGreen();
      ellipse(x2 + 20, y2, diameter, diameter);
      ellipse(x2 + 80, y2 + 50, diameter, diameter);
      break;
    case 5:
      fillYellow();
      ellipse(x2 + 20, y2, diameter, diameter);
      fillGreen();
      ellipse(x2 + 80, y2, diameter, diameter);
      break;
    case 6:
      fillGreen(); 
      ellipse(x2 + 20, y2, diameter, diameter);
      fillYellow();
      ellipse(x2 + 80, y2, diameter, diameter);
      break;
    case 7:
      fillYellow();
      ellipse(x2 + 20, y2 + 50, diameter, diameter);
      fillGreen();
      ellipse(x2 + 80, y2 + 50, diameter, diameter);
      break;
    case 8:
      fillGreen(); 
      ellipse(x2 + 20, y2 + 50, diameter, diameter);
      fillYellow();
      ellipse(x2 + 80, y2 + 50, diameter, diameter);
  }
}

abstract class Publisher {
   abstract public void update();
}

abstract class EventListener {
  abstract public void sendUpdate(String data);
}

class Notifier extends EventListener {
  Client client;
  Notifier(Client client) {
    this.client = client;
  }
  
  void sendUpdate(String data) {
     this.client.write(data);
  }
}

class Printer extends EventListener {
  void sendUpdate(String data) {
    print(data); 
  }
}

class ServerListener extends EventListener {
  private Client server;
  
  ServerListener(Client server) {
    this.server = server;
  }
  
  void sendUpdate(String data) {
    this.server.write(data);
  }
}

class Repository {
  private int speedDelta = 7;
  
  int direction = 0;
  int speedLeft = 150;
  int speedRight = 150;
  int brakeLeft = 50;
  int brakeRight = 50;
  
  private int frameRate = 10;
  private int sendRate = 1;
  
  public void setFrameRate(int fr) { 
    if (fr < 1) fr = 1; 
    if (fr > 60) fr = 60;
    this.frameRate = fr;
  };
  public int getFrameRate() { return this.frameRate; }
  
  public void setSendRate(int sr) { 
    if (sr < 1) sr = 1;
    if (sr > 20) sr = 20;
    this.sendRate = sr; 
  };
  public int getSendRate() { return this.sendRate; }
  
  void incSpeedLeft() { this.speedLeft += speedDelta; }
  void incSpeedRight() { this.speedRight += speedDelta; }
  void incBrakeLeft() { this.brakeLeft += speedDelta; }
  void incBrakeRight() { this.brakeRight += speedDelta; }
  
  void decSpeedLeft() { this.speedLeft -= speedDelta; }
  void decSpeedRight() { this.speedRight -= speedDelta; }
  void decBrakeLeft() { this.brakeLeft -= speedDelta; }
  void decBrakeRight() { this.brakeRight -= speedDelta; }
  
  String toString() {
    return direction + " " + speedLeft + " " + speedRight + " " + brakeLeft + " " + brakeRight + " " + frameRate + "\n";
  }
}

void updateLightPanels(int lightLeft, int lightForward, int lightRight) {
  fill(map(lightLeft, 0, 1024, 0, 255));
  rect(0, 0, width/3, height);

  fill(map(lightForward, 0, 1024, 0, 255));   
  rect(width/3, 0, width*2/3, height);

  fill(map(lightRight, 0, 1024, 0, 255));
  rect(width*2/3, 0, width, height);
}

void setupGradient(
  float dist, float x1, float y1, float x2, float y2, float x3, float y3
) {
  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  color yel = color(255, 255, 0);
  
  int maxd = maxDrawableDist;
  
  for (int i = 0; i <= dist; i++) {
    color c;
    
    if (i <= maxd / 2) {
      c = lerpColor(red, yel, pow(float(i * 2) / maxd, 0.8));
    } else {
      c = lerpColor(yel, green, pow(float(i * 2 - maxd) / maxd, 1.5));
    }
    
    stroke(c);
    line(
      (x1 - x2) * float(i) / dist,
      y1 - i,
      (x1 - x3) * float(i) / dist,
      y1 - i
    );
  }
  
  stroke(0);
}

void updateRadar(
  int distLeft, int distForwardLeft, int distForward, int distForwardRight, int distRight
) {
  translate(width/2, height - 70);
  
  int x = 0;
  int y = 0;

  float alpha = 22.5;

  float dl = map(distLeft, 0, 1024, 0, maxDrawableDist);
  float dfl = map(distForwardLeft, 0, 1024, 0, maxDrawableDist);
  float df = map(distForward, 0, 1024, 0, maxDrawableDist);
  float dfr = map(distForwardRight, 0, 1024, 0, maxDrawableDist);
  float dr = map(distRight, 0, 1024, 0, maxDrawableDist);
  
  // forward
  setupGradient(df, x, y,
    x - df * tan(radians(alpha)), y - df, 
    x + df * tan(radians(alpha)), y - df
  );
  
  // forward-left
  rotate(radians(-45));
  setupGradient(dfl, x, y,
    x - dfl * tan(radians(alpha)), y - dfl, 
    x + dfl * tan(radians(alpha)), y - dfl
  );
  
  // left
  rotate(radians(-45));
  setupGradient(dl, x, y,
    x - dl * tan(radians(alpha)), y - dl, 
    x + dl * tan(radians(alpha)), y - dl
  );
  
  // forward-right
  rotate(radians(135));
  setupGradient(dfr, x, y,
    x - dfr * tan(radians(alpha)), y - dfr, 
    x + dfr * tan(radians(alpha)), y - dfr
  );
  
  // right
  rotate(radians(45));
  setupGradient(dr, x, y,
    x - dr * tan(radians(alpha)), y - dr, 
    x + dr * tan(radians(alpha)), y - dr
  );
  
  rotate(radians(-90));
  translate(-width / 2, -height + 70);
}

class MovementData {
  private Client server;

  private int lightLeft = 100;
  private int lightForward = 100;
  private int lightRight = 100;
  
  private int distLeft = 500;
  private int distForwardLeft = 500;
  private int distForward = 500;
  private int distForwardRight = 500;
  private int distRight = 500;

  private int step = 50;

  MovementData() {}

  MovementData(Client server) {
    this.server = server;
  }

  void updateData() {
    if (server.available() > 0) {
      String input = server.readString();
      input = input.substring(0, input.indexOf("\n"));
      int[] data = int(split(input, ' '));

      lightLeft = data[0]; 
      lightForward = data[1]; 
      lightRight = data[2]; 

      distLeft = data[3]; 
      distForwardLeft = data[4]; 
      distForward = data[5]; 
      distForwardRight = data[6];
      distRight = data[7];
    }
  }

  String serialize() {
    return "light: " + " left: " + lightLeft + " right: " + lightRight + " forward: " + lightForward + "\n" +
      distLeft + " " + distForwardLeft + " " + distForward + " " + distForwardRight + " " + distRight + "\n";
  }

  void setLightLeft(int ll) {
    if (ll > 1024) this.lightLeft = 1024;
    else if (ll < 0) this.lightLeft = 0;
    else this.lightLeft = ll;
  }
  int getLightLeft() { return this.lightLeft; }

  void setLightForward(int ll) {
    if (ll > 1024) this.lightForward = 1024;
    else if (ll < 0) this.lightForward = 0;
    else this.lightForward = ll;
  }
  int getLightForward() { return this.lightForward; }

  void setLightRight(int ll) {
    if (ll > 1024) this.lightRight = 1024;
    else if (ll < 0) this.lightRight = 0;
    else this.lightRight = ll;
  }
  int getLightRight() { return this.lightRight; }


  void setDistLeft(int dd) {
    if (dd > 1024) this.distLeft = 1024;
    else if (dd < 0) this.distLeft = 0;
    else this.distLeft = dd;
  }
  int getDistLeft() { return this.distLeft; }

  void setDistForwardLeft(int dd) {
    if (dd > 1024) this.distForwardLeft = 1024;
    else if (dd < 0) this.distForwardLeft = 0;
    else this.distForwardLeft = dd;
  }
  int getDistForwardLeft() { return this.distForwardLeft; }

  void setDistForward(int dd) {
    if (dd > 1024) this.distForward = 1024;
    else if (dd < 0) this.distForward = 0;
    else this.distForward = dd;
  }
  int getDistForward() { return this.distForward; }

  void setDistForwardRight(int dd) {
    if (dd > 1024) this.distForwardRight = 1024;
    else if (dd < 0) this.distForwardRight = 0;
    else this.distForwardRight = dd;
  }
  int getDistForwardRight() { return this.distForwardRight; }

  void setDistRight(int dd) {
    if (dd > 1024) this.distRight = 1024;
    else if (dd < 0) this.distRight = 0;
    else this.distRight = dd;
  }
  int getDistRight() { return this.distRight; }

  void updateDataManually() {
    if (!keyPressed) return;

    switch (key) {
      case 'r':
        this.setLightLeft(this.lightLeft + step / 5);
        break;
      case 'f':
        this.setLightLeft(this.lightLeft - step / 5);
        break;
      case 't':
        this.setLightForward(this.lightForward + step / 5);
        break;
      case 'g':
        this.setLightForward(this.lightForward - step / 5);
        break;
      case 'y':
        this.setLightRight(this.lightRight + step / 5);
        break;
      case 'h':
        this.setLightRight(this.lightRight - step / 5);
        break;
      case 'u':
        this.setDistLeft(distLeft + step);
        break;
      case 'j':
        this.setDistLeft(distLeft - step);
        break;
      case 'i':
        this.setDistForwardLeft(distForwardLeft + step);
        break;
      case 'k':
        this.setDistForwardLeft(distForwardLeft - step);
        break;
      case 'o':
        this.setDistForward(distForward + step);
        break;
      case 'l':
        this.setDistForward(distForward - step);
        break;
      case 'p':
        this.setDistForwardRight(distForwardRight + step);
        break;
      case ';':
        this.setDistForwardRight(distForwardRight - step);
        break;
      case '[':
        this.setDistRight(distRight + step);
        break;
      case '\'':
        this.setDistRight(distRight - step);
        break;
    }
  }
}

class EventManager {
  List<EventListener> listeners = new ArrayList<EventListener>();
  int sendNumber = 0;
  
  Repository data;
  
  EventManager(Repository data) {
    this.data = data;
  }
  
  void subscribe(EventListener listener) {
     listeners.add(listener);
  }
  
  void notify(String eventType) {
    if (eventType == "chill") {
      this.data.direction = 0;
    } else if (eventType == "forward") {
      this.data.direction = 1;
    } else if (eventType == "down") {
      this.data.direction = 2;
    } else if (eventType == "left") {
      this.data.direction = 3;
    } else if (eventType == "right") {
      this.data.direction = 4;
    } else if (eventType == "forwardLeft") {
      this.data.direction = 5;
    } else if (eventType == "forwardRight") {
      this.data.direction = 6;
    } else if (eventType == "downLeft") {
      this.data.direction = 7;
    } else if (eventType == "downRight") {
      this.data.direction = 8;
    } else if (eventType == "frameRate+") {
      this.data.setFrameRate(this.data.getFrameRate() + 1);
    } else if (eventType == "frameRate-") {
      this.data.setFrameRate(this.data.getFrameRate() - 1);
    } else if (eventType == "sendRate+") {
      this.data.setSendRate(this.data.getSendRate() + 1);
    } else if (eventType == "sendRate-") {
      this.data.setSendRate(this.data.getSendRate() - 1);
    } else if (eventType == "speedLeft+") {
      this.data.incSpeedLeft();
    } else if (eventType == "speedLeft-") {
      this.data.decSpeedLeft();
    } else if (eventType == "speedRight+") {
      this.data.incSpeedRight();
    } else if (eventType == "speedRight-") {
      this.data.decSpeedRight();
    } else if (eventType == "brakeLeft+") {
      this.data.incBrakeLeft();
    } else if (eventType == "brakeLeft-") {
      this.data.decBrakeLeft();
    } else if (eventType == "brakeRight+") {
      this.data.incBrakeRight();
    } else if (eventType == "brakeRight-") {
      this.data.decBrakeRight();
    }
    
   if (this.sendNumber >= this.data.getSendRate()) {
     for (int i = 0; i < listeners.size(); i++) {
        listeners.get(i).sendUpdate(this.data.toString());
     }
     this.sendNumber = 1;
   } 
   this.sendNumber++;
  }
}

class Button extends Publisher {
  String label;
  float x, y;
  
  float w = 100;
  float h = 50;
  
  EventManager events;
  
  Button(String label, float x, float y, EventManager events) {
    this.events = events;
    this.label = label;
    this.x = x;
    this.y = y;
  }
    
  void setPressed() {
    fill(0, 50, 255);
    rect(x, y, w, h, 10);

    fill(255);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  void print() {
      fill(0, 0, 200);
      rect(x, y, w, h, 10);
      textAlign(CENTER, CENTER);
      textSize (14);
      fill(255);
      text(label, x + (w / 2), y + (h / 2));
  }
  
  void update() {    
    if (mouseX > this.x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
        this.setPressed();
        events.notify(label);
     }
  }
}
