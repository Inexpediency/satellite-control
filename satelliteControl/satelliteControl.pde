import processing.net.*;
import java.util.List;
import java.util.HashMap;

final boolean IS_DEV = true; // DEVELOPMENT -> TRUE; REAL_TEST -> FALSE;

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

final int maxDrawableDist = 150; 

EventManager eventManager;
List<Button> buttons;
HashMap<String, Button> movementButtons;
Repository repository;
MovementData movementData;

SensorsVisualization sensorsVisualization = new SensorsVisualization();
UserInterfaceUpdater userInterfaceUpdater;

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
  initControlElements(buttons, movementButtons);

  userInterfaceUpdater = new UserInterfaceUpdater(eventManager, repository, buttons);
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
  
  sensorsVisualization.updateLightPanels(
    movementData.getLightLeft(),
    movementData.getLightForward(),
    movementData.getLightRight()
  );
  
  sensorsVisualization.updateRadar(
    movementData.getDistLeft(),
    movementData.getDistForwardLeft(), 
    movementData.getDistForward(),
    movementData.getDistForwardRight(),
    movementData.getDistRight()
  );

  userInterfaceUpdater.update();
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

void initControlElements(List<Button> buttons, HashMap<String, Button> movementButtons) {
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
