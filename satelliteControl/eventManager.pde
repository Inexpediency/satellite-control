class EventManager {
  
  private List<EventListener> listeners = new ArrayList<EventListener>();
  
  private Repository data;
  private Repository previousData;
  
  EventManager(Repository data) {
    this.data = data;

    this.previousData = new Repository();
  }
  
  void subscribe(EventListener listener) {
     listeners.add(listener);
  }
  
  void notify(String eventType) {
    if (eventType == "chill") {
      this.data.setDirection(0);
    } else if (eventType == "forward") {
      this.data.setDirection(1);
    } else if (eventType == "down") {
      this.data.setDirection(2);
    } else if (eventType == "left") {
      this.data.setDirection(3);
    } else if (eventType == "right") {
      this.data.setDirection(4);
    } else if (eventType == "forwardLeft") {
      this.data.setDirection(5);
    } else if (eventType == "forwardRight") {
      this.data.setDirection(6);
    } else if (eventType == "downLeft") {
      this.data.setDirection(7);
    } else if (eventType == "downRight") {
      this.data.setDirection(8);
    } else if (eventType == "frameRate+") {
      this.data.incFrameRate();
    } else if (eventType == "frameRate-") {
      this.data.decFrameRate();
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
    
    if (this.data.differenceBetweenSendableData(this.previousData)) {
      for (int i = 0; i < listeners.size(); i++) {
        listeners.get(i).sendUpdate(this.data.toString());
      }
    }

    this.previousData = this.data.copy();
  }
}
