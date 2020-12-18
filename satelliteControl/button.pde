class Button extends Publisher {
  
  private String label;
  private float x, y;
  
  private final float w = 97;
  private final float h = 55;
  
  private EventManager events;
  
  Button(String label, float x, float y, EventManager events) {
    this.events = events;
    this.label = label;
    this.x = x;
    this.y = y;
  }

  void setPressed() {
    fill(0, 50, 255);
    rect(x, y, w, h, 10);

    fill(255);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  void print() {
      fill(0, 0, 200);
      rect(x, y, w, h, 11);
      textAlign(CENTER, CENTER);
      textSize (14);
      fill(255);
      text(label, x + (w / 2), y + (h / 2));
  }
  
  void update() {    
    if (mouseX > this.x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
        this.setPressed();
        events.notify(label);
     }
  }
}
