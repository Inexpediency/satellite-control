class Repository {
  private int speedDelta = 7;
  
  int direction = 0;
  int speedLeft = 150;
  int speedRight = 150;
  int brakeLeft = 50;
  int brakeRight = 50;
  
  private int frameRate = 60;
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
