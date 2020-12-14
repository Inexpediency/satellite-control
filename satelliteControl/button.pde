class Button extends Publisher {
  String label;
  float x, y;
  
  float w = 100;
  float h = 50;
  
  EventManager events;
  
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
      rect(x, y, w, h, 10);
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
