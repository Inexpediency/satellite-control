class Repository {
  private int speedDelta = 2;
  
  int direction = 0;
  int speedLeft = 150;
  int speedRight = 150;
  int brakeLeft = 50;
  int brakeRight = 50;
  
  private float frameRate = 60;
  private float sendRate = 1;
  
  public void setFrameRate(float fr) { 
    if (fr < 1) fr = 1; 
    else if (fr > 60) fr = 60;
    else this.frameRate = fr;
  };
  public float getFrameRate() { return this.frameRate; }
  
  public void setSendRate(float sr) { 
    if (sr < 1) sr = 1;
    else if (sr > 20) sr = 20;
    else this.sendRate = sr; 
  };
  public float getSendRate() { return this.sendRate; }
  
  void incSpeedLeft() {
    if (this.speedLeft < 1024) {
      this.speedLeft += speedDelta;
    }
  }
  void incSpeedRight() { 
    if (this.speedLeft < 1024) {
      this.speedRight += speedDelta;
    }
  }
  void incBrakeLeft() { 
    if (this.speedLeft < 1024) {
      this.brakeLeft += speedDelta;
    }
  }
  void incBrakeRight() {
    if (this.speedLeft < 1024) {
      this.brakeRight += speedDelta;
    }
  }

  void decSpeedLeft() { 
    if (this.speedLeft > 0) {
      this.speedLeft -= speedDelta;
    }
  }
  void decSpeedRight() { 
    if (this.speedRight > 0) {
      this.speedRight -= speedDelta; 
    }
  }
  void decBrakeLeft() { 
    if (this.brakeLeft > 0) {
      this.brakeLeft -= speedDelta; 
    }
  }
  void decBrakeRight() { 
    if (this.brakeRight > 0) {
      this.brakeRight -= speedDelta; 
    }
  }
  
  String toString() {
    return direction + " " + speedLeft + " " + speedRight + " " + brakeLeft + " " + brakeRight + " " + frameRate + "\n";
  }
}
