import processing.net.*;
import java.util.List;
import java.util.HashMap;

final boolean IS_DEV = true; // DEVELOPMENT -> TRUE; REAL_TEST -> FALSE;

EventManager eventManager;
Repository repository;
MovementData movementData;

SensorsVisualization sensorsVisualization;
UserInterfaceUpdater userInterfaceUpdater;

Boolean isForward = false;
Boolean isLeft = false;
Boolean isRight = false;
Boolean isDown = false;

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
  
  userInterfaceUpdater = new UserInterfaceUpdater(eventManager, repository);
  sensorsVisualization = new SensorsVisualization();
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
