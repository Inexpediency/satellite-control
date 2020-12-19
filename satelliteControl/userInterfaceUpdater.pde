class UserInterfaceUpdater {
  
  private EventManager eventManager;
  private Repository repository;

  private HashMap<String, Button> movementButtons = new HashMap<String, Button>();
  private ArrayList<Button> buttons = new ArrayList<Button>();

  private final float x1 = 100;
  private final float x2 = 250;
  private final float x3 = 400;
  private final float x4 = 650;
  private final float x5 = 800;

  private final float y1 = 70;
  private final float y2 = 170;
  private final float y3 = 270;
  private final float y4 = 370;
  private final float y5 = 470;

  private final float diameter = 30;

  private final int widthForData = 200;

  UserInterfaceUpdater(EventManager eventManager, Repository repository) {
    this.eventManager = eventManager;
    this.repository = repository;

    this.initControlElements();
  }

  public void update() {
    for (int i = 0; i < buttons.size(); i++) {
      buttons.get(i).print();
    }

    this.drawCircles();

    this.handleButtonsMovement();

    if (mousePressed && mouseButton == LEFT) {
      for (int i = 0; i < buttons.size(); i++) {
        buttons.get(i).update();
      }
    } else if (!this.isSomeMovementButtonPressed()) {
      eventManager.notify("chill");
    }

    this.updateCircles();
  }

  private void handleButtonsMovement() {
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

  private Boolean isSomeMovementButtonPressed() {
    return isForward || isDown || isLeft || isRight;
  }

  private void fillYellow() { fill(255, 255, 1); }
  
  private void fillGreen() { fill(0, 255, 0); }

  private void updateCircles() {
    switch (this.repository.direction) {
      case 1:
        this.fillGreen();
        ellipse(x2 + 20, y2, diameter, diameter);
        ellipse(x2 + 80, y2, diameter, diameter);
        break;
      case 2:
        this.fillGreen();
        ellipse(x2 + 20, y2 + 50, diameter, diameter);
        ellipse(x2 + 80, y2 + 50, diameter, diameter);
        break;
      case 3:
        this.fillGreen();
        ellipse(x2 + 80, y2, diameter, diameter);
        ellipse(x2 + 20, y2 + 50, diameter, diameter);
        break;
      case 4: 
        this.fillGreen();
        ellipse(x2 + 20, y2, diameter, diameter);
        ellipse(x2 + 80, y2 + 50, diameter, diameter);
        break;
      case 5:
        this.fillYellow();
        ellipse(x2 + 20, y2, diameter, diameter);
        this.fillGreen();
        ellipse(x2 + 80, y2, diameter, diameter);
        break;
      case 6:
        this.fillGreen(); 
        ellipse(x2 + 20, y2, diameter, diameter);
        this.fillYellow();
        ellipse(x2 + 80, y2, diameter, diameter);
        break;
      case 7:
        this.fillYellow();
        ellipse(x2 + 20, y2 + 50, diameter, diameter);
        this.fillGreen();
        ellipse(x2 + 80, y2 + 50, diameter, diameter);
        break;
      case 8:
        this.fillGreen(); 
        ellipse(x2 + 20, y2 + 50, diameter, diameter);
        this.fillYellow();
        ellipse(x2 + 80, y2 + 50, diameter, diameter);
    }
  }

  private void drawCircles() {
    fill(255, 0, 0); 
    ellipse(x2 + 20, y2, diameter, diameter);
    ellipse(x2 + 80, y2, diameter, diameter);
    ellipse(x2 + 20, y2 + 50, diameter, diameter);
    ellipse(x2 + 80, y2 + 50, diameter, diameter);
  }

  public void initControlElements() {
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
}
