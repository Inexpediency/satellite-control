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
    fill(200);
    rect(minX, 0, maxX, maxY);

    // print data on screen
  }
}
