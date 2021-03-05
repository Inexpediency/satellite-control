class Repository {
  
  private float tickDelta = 0.25;
  
  private int direction = 0;
  private float speedLeft = 135;
  private float speedRight = 135;
  private float brakeLeft = 45;
  private float brakeRight = 45;
  
  private float frameRate = 60;

  Repository copy() {
    Repository r = new Repository();

    r.tickDelta = this.tickDelta;

    r.direction = this.direction;
    r.speedLeft = this.speedLeft;
    r.speedRight = this.speedRight;
    r.brakeLeft = this.brakeLeft;
    r.brakeRight = this.brakeRight;

    r.frameRate = this.frameRate;

    return r;
  }

  Boolean differenceBetweenSendableData(Repository last) {
    if (
      this.getDirection() != last.getDirection() ||
      this.getSpeedLeft() != last.getSpeedLeft() ||
      this.getSpeedRight() != last.getSpeedRight() ||
      this.getBrakeLeft() != last.getBrakeLeft() ||
      this.getBrakeRight() != last.getBrakeRight() ||
      this.getFrameRate() != last.getFrameRate()
    ) return true;

    return false;
  }

  String toString() {
    return this.getDirection() + " " + this.getSpeedLeft() + " " + this.getSpeedRight() + " "
      + this.getBrakeLeft() + " " + this.getBrakeRight() + " " + this.getFrameRate() + "\n";
  }

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
}
