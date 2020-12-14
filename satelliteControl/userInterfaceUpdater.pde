class UserInterfaceUpdater {
  private EventManager eventManager;
  private Repository repository;
  private List<Button> buttons;

  UserInterfaceUpdater(EventManager eventManager, Repository repository, List<Button> buttons) {
    this.eventManager = eventManager;
    this.repository = repository;
    this.buttons = buttons;
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
}
