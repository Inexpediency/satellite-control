class Repository {
  
  private float tickDelta = 0.25;
  
  private int direction = 0;
  private float speedLeft = 130;
  private float speedRight = 130;
  private float brakeLeft = 40;
  private float brakeRight = 40;
  
  private float frameRate = 40;
  private float sendRate = 20;

  void setDirection(int dir) {
    this.direction = dir;
  }
  int getDirection() {
    return this.direction;
  }

  void incFrameRate() {
    if (this.frameRate < 60) this.frameRate += this.tickDelta; 
  }
  void decFrameRate() {
    if (this.frameRate > 10) this.frameRate -= this.tickDelta;
  }
  int getFrameRate() {
    return (int)this.frameRate;
  }

  void incSendRate() {
    if (this.sendRate < 30) this.sendRate += this.tickDelta; 
  }
  void decSendRate() {
    if (this.sendRate > 1) this.sendRate -= this.tickDelta;
  }
  int getSendRate() {
    return (int)this.sendRate;
  }
  
  void incSpeedLeft() {
    if (this.speedLeft < 255) {
      this.speedLeft += tickDelta;
    }
  }
  void incSpeedRight() { 
    if (this.speedLeft < 255) {
      this.speedRight += tickDelta;
    }
  }
  void incBrakeLeft() { 
    if (this.speedLeft < 255) {
      this.brakeLeft += tickDelta;
    }
  }
  void incBrakeRight() {
    if (this.speedLeft < 255) {
      this.brakeRight += tickDelta;
    }
  }

  void decSpeedLeft() { 
    if (this.speedLeft > 0) {
      this.speedLeft -= tickDelta;
    }
  }
  void decSpeedRight() { 
    if (this.speedRight > 0) {
      this.speedRight -= tickDelta; 
    }
  }
  void decBrakeLeft() { 
    if (this.brakeLeft > 0) {
      this.brakeLeft -= tickDelta; 
    }
  }
  void decBrakeRight() { 
    if (this.brakeRight > 0) {
      this.brakeRight -= tickDelta; 
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
    return this.getDirection() + " " + this.getSpeedLeft() + " " + this.getSpeedRight() + " "
      + this.getBrakeLeft() + " " + this.getBrakeRight() + " " + this.getFrameRate() + "\n";
  }
}
