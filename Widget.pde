/*
 * A widget class that works as a base class for all other specialized widget classes.
 */

abstract class Widget {
  protected float x, y, width, height;
  protected boolean isActive;
  protected boolean isDisabled;
  protected Application app;
  
  public Widget(float x, float y, float width, float height, Application app) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.isActive = false;
    this.app = app;
    this.isDisabled = false;
  }
  
  /*
   * A method that determines whether if the given coordinates are on the widget and returns the result.s
   */
  
  public boolean contains(float targetX, float targetY) {
    return x - 0.5 * width <= targetX && targetX <= x + 0.5 * width && 
            y - 0.5 * height <= targetY && targetY <= y + 0.5 * height;
  }
  
  /*
   * A method that determines if the widget is active or not, and returns the result.
   */
  
  public boolean isActive() {
    return isActive;
  }
  
  /*
   * A method that sets the state of the widget, in that it is either active or not active.
   */
  
  public void setActive(boolean isActive) {
    this.isActive = isActive;
  }
  
  /*
   * A method that determines if the widget is disabled or not, and returns the result.
   */
  
  public boolean isDisabled() {
    return isDisabled;
  }
  
  /*
   * A method that determines the state of the widget, in that it is either disabled or not disabled.
   */
  
  public void setDisabled(boolean isDisabled) {
    this.isDisabled = isDisabled;
  }
  
  /*
   * These methods need to be specialized.
   */
  
  abstract public void display();
  abstract public void action();
}

/*
 * Widget specializations.
 */

abstract class Button extends Widget {
  protected String text;
  
  public Button(float x, float y, float width, float height, Application app, String text) {
    super(x, y, width, height, app);
    
    this.text = text;
  }
  
  public void display() {
    pushStyle();
    if (isDisabled) {
      fill(app.properties.widgetDisabledFillColor);
    } else if (contains(mouseX, mouseY) || isActive) {
      fill(app.properties.widgetActiveFillColor);
    } else {
      fill(app.properties.widgetFillColor);
    }
    stroke(app.properties.widgetStrokeColor);
    strokeWeight(app.properties.widgetStrokeWeightValue);
    rect(x, y, width, height);
    
    fill(app.properties.textColor1);
    textSize(0.5 * height);
    text(text, x, y);
    popStyle();
  }
  
  public abstract void action();
}

class OpenFileButton extends Button {
  public OpenFileButton(float x, float y, float width, float height, Application app, String text) {
    super(x, y, width, height, app, text);
  }
  
  public void action() {
    if (!isDisabled)
      selectInput("Select input", "openObject3D");
  }
}

class CloseFileButton extends Button {
  public CloseFileButton(float x, float y, float width, float height, Application app, String text) {
    super(x, y, width, height, app, text);
  }
  
  public void action() {
    if (!isDisabled)
      application.closeObject3D();
  }
}

class ExportButton extends Button {
  public ExportButton(float x, float y, float width, float height, Application app, String text) {
    super(x, y, width, height, app, text);
  }
  
  public void action() {
    if (!isDisabled)
      selectOutput("Select output", "exportObject3D");
  }
}

class ScanButton extends Button {
  public ScanButton(float x, float y, float width, float height, Application app, String text) {
    super(x, y, width, height, app, text);
  }
  
  public void action() {
    if (!isDisabled)
      app.scan();
  }
}

class VisualBar extends Widget {
  public VisualBar(float x, float y, float width, float height, Application app) {
    super(x, y, width, height, app);
  }
  
  public void display() {
    pushStyle();
    fill(app.properties.widgetFillColor);
    stroke(app.properties.widgetStrokeColor);
    strokeWeight(app.properties.widgetStrokeWeightValue);
    rect(x, y, width, height);
    popStyle();
  }
  
  public void action() {
    
  }
}

class Compass extends Widget {
  public Compass(float x, float y, float width, float height, Application app) {
    super(x, y, width, height, app);
  }
  
  public void display() {
    pushMatrix();
    translate(x, y);
    scale(1, -1, 1);
    rotateX(app.properties.angleX);
    rotateY(app.properties.angleY);
    rotateZ(app.properties.angleZ);
    
    pushStyle();
    noFill();
    strokeWeight(app.properties.widgetStrokeWeightValue);
    stroke(color(255, 0, 0));
    line(0, 0, 0, app.unit, 0, 0);
    stroke(color(0, 255, 0));
    line(0, 0, 0, 0, app.unit, 0);
    stroke(color(0, 0, 255));
    line(0, 0, 0, 0, 0, app.unit);
    popStyle();
    
    popMatrix();
  }
  
  public void action() {
    
  }
}
