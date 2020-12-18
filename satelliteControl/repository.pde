class Repository {
  
  private float speedDelta = 0.25;
  
  private int direction = 0;
  private float speedLeft = 150;
  private float speedRight = 150;
  private float brakeLeft = 50;
  private float brakeRight = 50;
  
  private float frameRate = 50;
  private float sendRate = 1;

  void setDirection(int dir) {
    this.direction = dir;
  }
  int getDirection() {
    return this.direction;
  }
  
  void incFrameRate() {
  if (this.frameRate < 60) this.frameRate += this.speedDelta / 2; 
  }
  void decFrameRate() {
    if (this.frameRate > 10) this.frameRate -= this.speedDelta / 2;
  }
  int getFrameRate() {
    return (int)this.frameRate;
  }

  void incSendRate() {
  if (this.sendRate < 20) this.sendRate += this.speedDelta / 2; 
  }
  void decSendRate() {
    if (this.sendRate > 1) this.sendRate -= this.speedDelta / 2;
  }
  int getSendRate() {
    return (int)this.sendRate;
  }
  
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

  int getSpeedLeft() {
    return (int)this.speedLeft;
  }
  int getSpeedRight() {
    return (int)this.speedRight;
  }
  int getBrakeLeft() {
    return (int)this.brakeLeft;
  }
  int getBrakeRight() {
    return (int)this.brakeRight;
  }

  String toString() {
    return direction + " " + speedLeft + " " + speedRight + " " + brakeLeft + " " + brakeRight + " " + frameRate + "\n";
  }
}
