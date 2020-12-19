class SensorsVisualization {

  private final int width = 1000;
  private final int height = 600;
  private final int maxDrawableDist = 150; 

  private final int maxAnalogReadValue = 255;

  public void updateLightPanels(int lightLeft, int lightForward, int lightRight) {
    stroke(0);
    
    fill(lightLeft);
    rect(0, 0, this.width/3, this.height);

    fill(lightForward);   
    rect(this.width/3, 0, this.width*2/3, this.height);

    fill(lightRight);
    rect(this.width*2/3, 0, this.width, this.height);
  }

  public void updateRadar(
    int distLeft, int distForwardLeft, int distForward, int distForwardRight, int distRight
  ) {
    translate(this.width/2, this.height - 70);

    int x = 0;
    int y = 0;

    final float alpha = 22.5;

    float dl = mapDistToDrawable(distLeft);
    float dfl = mapDistToDrawable(distForwardLeft);
    float df = mapDistToDrawable(distForward);
    float dfr = mapDistToDrawable(distForwardRight);
    float dr = mapDistToDrawable(distRight);

    // forward
    setupGradient(df, x, y,
      x - df * tan(radians(alpha)), y - df, 
      x + df * tan(radians(alpha)), y - df
    );
    
    // forward-left
    rotate(radians(-45));
    setupGradient(dfl, x, y,
      x - dfl * tan(radians(alpha)), y - dfl, 
      x + dfl * tan(radians(alpha)), y - dfl
    );
    
    // left
    rotate(radians(-45));
    setupGradient(dl, x, y,
      x - dl * tan(radians(alpha)), y - dl, 
      x + dl * tan(radians(alpha)), y - dl
    );
    
    // forward-right
    rotate(radians(135));
    setupGradient(dfr, x, y,
      x - dfr * tan(radians(alpha)), y - dfr, 
      x + dfr * tan(radians(alpha)), y - dfr
    );
    
    // right
    rotate(radians(45));
    setupGradient(dr, x, y,
      x - dr * tan(radians(alpha)), y - dr, 
      x + dr * tan(radians(alpha)), y - dr
    );
    
    rotate(radians(-90));
    translate(-this.width / 2, -this.height + 70);
  }

  private int mapDistToDrawable(int value) {
    return (int)map(value, 0, maxAnalogReadValue, 0, maxDrawableDist);
  }

  private void setupGradient(
    float dist, float x1, float y1, float x2, float y2, float x3, float y3
  ) {
    color red = color(255, 0, 0);
    color green = color(0, 255, 0);
    color yel = color(255, 255, 0);
    
    int maxd = maxDrawableDist;
    
    for (int i = 0; i <= dist; i++) {
      color c;
      
      if (i <= maxd / 2) {
        c = lerpColor(red, yel, pow(float(i * 2) / maxd, 0.8));
      } else {
        c = lerpColor(yel, green, pow(float(i * 2 - maxd) / maxd, 1.5));
      }
      
      stroke(c);
      line(
        (x1 - x2) * float(i) / dist,
        y1 - i,
        (x1 - x3) * float(i) / dist,
        y1 - i
      );
    }
    
    stroke(0);
  }
}
