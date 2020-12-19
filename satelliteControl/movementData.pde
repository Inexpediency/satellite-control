class MovementData {

  private Client server;

  private final int maxAnalogRead = 255;
  private final int step = 10;

  private int lightLeft = 100;
  private int lightForward = 100;
  private int lightRight = 100;
  
  private int distLeft = 150;
  private int distForwardLeft = 150;
  private int distForward = 150;
  private int distForwardRight = 150;
  private int distRight = 150;

  MovementData() {}

  MovementData(Client server) {
    this.server = server;
  }
  
  void updateData() {
    if (server.available() > 0) {
      String input = server.readString();
      input = input.substring(0, input.indexOf("\n"));
      int[] data = int(split(input, ' '));

      lightLeft = data[0]; 
      lightForward = data[1]; 
      lightRight = data[2]; 

      distLeft = data[3]; 
      distForwardLeft = data[4]; 
      distForward = data[5]; 
      distForwardRight = data[6];
      distRight = data[7];
    }
  }

  String serialize() {
    return "light: " + " left: " + lightLeft + " right: " + lightRight + " forward: " + lightForward + "\n" +
      distLeft + " " + distForwardLeft + " " + distForward + " " + distForwardRight + " " + distRight + "\n";
  }

  void setLightLeft(int ll) {
    if (ll > maxAnalogRead) this.lightLeft = maxAnalogRead;
    else if (ll < 0) this.lightLeft = 0;
    else this.lightLeft = ll;
  }
  int getLightLeft() { return this.lightLeft; }

  void setLightForward(int ll) {
    if (ll > maxAnalogRead) this.lightForward = maxAnalogRead;
    else if (ll < 0) this.lightForward = 0;
    else this.lightForward = ll;
  }
  int getLightForward() { return this.lightForward; }

  void setLightRight(int ll) {
    if (ll > maxAnalogRead) this.lightRight = maxAnalogRead;
    else if (ll < 0) this.lightRight = 0;
    else this.lightRight = ll;
  }
  int getLightRight() { return this.lightRight; }


  void setDistLeft(int dd) {
    if (dd > maxAnalogRead) this.distLeft = maxAnalogRead;
    else if (dd < 0) this.distLeft = 0;
    else this.distLeft = dd;
  }
  int getDistLeft() { return this.distLeft; }

  void setDistForwardLeft(int dd) {
    if (dd > maxAnalogRead) this.distForwardLeft = maxAnalogRead;
    else if (dd < 0) this.distForwardLeft = 0;
    else this.distForwardLeft = dd;
  }
  int getDistForwardLeft() { return this.distForwardLeft; }

  void setDistForward(int dd) {
    if (dd > maxAnalogRead) this.distForward = maxAnalogRead;
    else if (dd < 0) this.distForward = 0;
    else this.distForward = dd;
  }
  int getDistForward() { return this.distForward; }

  void setDistForwardRight(int dd) {
    if (dd > maxAnalogRead) this.distForwardRight = maxAnalogRead;
    else if (dd < 0) this.distForwardRight = 0;
    else this.distForwardRight = dd;
  }
  int getDistForwardRight() { return this.distForwardRight; }

  void setDistRight(int dd) {
    if (dd > maxAnalogRead) this.distRight = maxAnalogRead;
    else if (dd < 0) this.distRight = 0;
    else this.distRight = dd;
  }
  int getDistRight() { return this.distRight; }

  public void updateDataManually() {
    if (!keyPressed) return;

    switch (key) {
      case 'r':
        this.setLightLeft(this.lightLeft + step / 5);
        break;
      case 'f':
        this.setLightLeft(this.lightLeft - step / 5);
        break;
      case 't':
        this.setLightForward(this.lightForward + step / 5);
        break;
      case 'g':
        this.setLightForward(this.lightForward - step / 5);
        break;
      case 'y':
        this.setLightRight(this.lightRight + step / 5);
        break;
      case 'h':
        this.setLightRight(this.lightRight - step / 5);
        break;
      case 'u':
        this.setDistLeft(distLeft + step);
        break;
      case 'j':
        this.setDistLeft(distLeft - step);
        break;
      case 'i':
        this.setDistForwardLeft(distForwardLeft + step);
        break;
      case 'k':
        this.setDistForwardLeft(distForwardLeft - step);
        break;
      case 'o':
        this.setDistForward(distForward + step);
        break;
      case 'l':
        this.setDistForward(distForward - step);
        break;
      case 'p':
        this.setDistForwardRight(distForwardRight + step);
        break;
      case ';':
        this.setDistForwardRight(distForwardRight - step);
        break;
      case '[':
        this.setDistRight(distRight + step);
        break;
      case '\'':
        this.setDistRight(distRight - step);
        break;
    }
  }
}
