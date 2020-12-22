class DataPrinterOnScreen {
  
  MovementData movementData;
  Repository repository;

  final int minX = 1000;
  final int maxX = width;
  final int maxY = height;

  DataPrinterOnScreen(MovementData movementData, Repository repository) {
    this.movementData = movementData;
    this.repository = repository;
  }

  void print() {
    stroke(0);
    fill(25);
    rect(minX, 0, maxX, maxY);

    fill(250);
    textAlign(LEFT);

    textSize(20);
    text("Movement Data", minX + 25, 50);
    textSize(16);
    text(this.serializeMovementData(), minX + 5, 80);

    textSize(20);
    text("Control Data", minX + 35, maxY / 2 + 50);
    textSize(16);
    text(this.serializeRepository(), minX + 5, maxY / 2 + 80);
  }

  private String serializeMovementData() {
    return String.format(
      "Dist left: %d\n" + 
      "Dist forward-left: %d\n" +
      "Dist forward: %d\n" +
      "Dist froward-right: %d\n" +
      "Dist right: %d\n\n" +
      "Light left: %d\n" +
      "Light forward: %d\n" +
      "Light right: %d",
      this.movementData.distLeft,
      this.movementData.distForwardLeft,
      this.movementData.distForward,
      this.movementData.distForwardRight,
      this.movementData.distRight,
      this.movementData.lightLeft,
      this.movementData.lightForward,
      this.movementData.lightRight
    );
  }

  private String serializeRepository() {
    return String.format(
      "Direction: %d\n" +
      "Speed left: %d\n" +
      "Speed right: %d\n" +
      "Brake left: %d\n" +
      "Brake right: %d\n" +
      "Frame rate: %d\n" +
      "Send rate: %d\n" +
      "Sending/second: %.2f",
      this.repository.getDirection(),
      this.repository.getSpeedLeft(),
      this.repository.getSpeedRight(),
      this.repository.getBrakeLeft(),
      this.repository.getBrakeRight(),
      this.repository.getFrameRate(),
      this.repository.getSendRate(),
      (float)this.repository.getFrameRate() / (float)this.repository.getSendRate()
    );
  }
}
