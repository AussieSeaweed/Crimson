/*
 * An Application class that handles the cores of the program.
 */

class Application {
  
  /*
   * A Properties class that stores all the properties of the program.
   */
  
  private class Properties {
    public boolean isOpen;
    public String filename;
    public float angleX;
    public float angleY;
    public float angleZ;
    public float zoom;
    public float zoomScale;
    public float angleScalar;
    public boolean GUIVisible;
    public color backgroundColor;
    public color fillColor;
    public color strokeColor;
    public float strokeWeightValue;
    public color widgetFillColor;
    public color widgetActiveFillColor;
    public color widgetStrokeColor;
    public float widgetStrokeWeightValue;
    public color widgetDisabledFillColor;
    public color textColor1;
    public color textColor2;
    public boolean noFill;
    public boolean zoomToFit;
    public boolean moveAngleXPos;
    public boolean moveAngleXNeg;
    public boolean moveAngleYPos;
    public boolean moveAngleYNeg;
    public boolean moveAngleZPos;
    public boolean moveAngleZNeg;
    public float defaultAngleXValue;
    public float defaultAngleYValue;
    public float defaultAngleZValue;
    public float defaultZoomValue;
    public float mouseInputSuppressor;
    public boolean connectedTo3DScanner;
    public boolean scanning;
    public boolean zoomIn;
    public boolean zoomOut;
    
    public int pmouseX;
    public int pmouseY;
    public boolean pmousePressed;
    public int pwidth;
    public int pheight;
    
    public Properties() {
      isOpen = false;
      filename = null;
      angleX = 0;
      angleY = 0;
      angleZ = 0;
      zoom = 0;
      zoomScale = 2;
      angleScalar = PI;
      GUIVisible = true;
      backgroundColor = color(150);
      fillColor = color(255);
      strokeColor = color(0);
      strokeWeightValue = 1;
      widgetFillColor = color(255);
      widgetActiveFillColor = color(200);
      widgetStrokeColor = color(0);
      widgetStrokeWeightValue = 2;
      widgetDisabledFillColor = color(200);
      textColor1 = color(0);
      textColor2 = color(255);
      noFill = false;
      zoomToFit = true;
      moveAngleXPos = false;
      moveAngleXNeg = false;
      moveAngleYPos = false;
      moveAngleYNeg = false;
      moveAngleZPos = false;
      moveAngleZNeg = false;
      defaultAngleXValue = 0;
      defaultAngleYValue = 0;
      defaultAngleZValue = 0;
      defaultZoomValue = 0;
      mouseInputSuppressor = 0.1;
      connectedTo3DScanner = false;
      scanning = false;
      zoomIn = false;
      zoomOut = false;
      
      pmouseX = width / 2;
      pmouseY = height / 2;
      pmousePressed = false;
      pwidth = width;
      pheight = height;
    }
    
    /*
     * A method that updates the geometry (i.e. camera position).
     */
    
    public void update() {
      if (isOpen) {
        if (moveAngleXPos)
          angleX += perSecond(angleScalar);
        if (moveAngleXNeg)
          angleX -= perSecond(angleScalar);
        if (moveAngleYPos)
          angleY += perSecond(angleScalar);
        if (moveAngleYNeg)
          angleY -= perSecond(angleScalar);
        if (moveAngleZPos)
          angleZ += perSecond(angleScalar);
        if (moveAngleZNeg)
          angleZ -= perSecond(angleScalar);
        if (zoomIn)
          zoom += perSecond(zoomScale);
        if (zoomOut)
          zoom -= perSecond(zoomScale);
      }
    }
    
    /*
     * A method that resets the geometry (i.e. camera position).
     */
    
    public void resetGeometry() {
      angleX = defaultAngleXValue;
      angleY = defaultAngleYValue;
      angleZ = defaultAngleZValue;
      zoom = defaultZoomValue;
    }
    
    /*
     * A method that modifies the rotation of the object based on mouse drag.
     */
    
    public void setCameraOffset(PVector offset) {
      angleY += offset.x * mouseInputSuppressor * radians(angleScalar);
      angleX += offset.y * mouseInputSuppressor * radians(angleScalar);
    }
    
    /*
     * A method that modifies the properties depending on the file opened.
     */
    
    public void open(String filename, float maxDimension) {
      isOpen = true;
      this.filename = filename;
      
      if (zoomToFit) {
        float scalar = min(width, height) * 0.65 / maxDimension;
        defaultZoomValue = log(scalar);
      } else {
        defaultZoomValue = 0;
      }
      
      zoom = defaultZoomValue;
    }
    
    /*
     * A method that handles the properties in that the file is closed.
     */
    
    public void close() {
      isOpen = false;
      filename = null;
      resetGeometry();
    }
    
    /*
     * A method that returns the current style attributes depending on the set properties.
     */
    
    public color getFillColor() {
      if (noFill) return color(255, 0);
      else return fillColor;
    }
    
    public color getStrokeColor() {
      return strokeColor;
    }
    
    public float getStrokeWeightValue() {
      return strokeWeightValue;
    }
    
    public void connectTo3DScanner() {
      connectedTo3DScanner = true;
      scanning = false;
    }
    
    public void disconnectTo3DScanner() {
      connectedTo3DScanner = false;
      scanning = false;
    }
    
    public void beginScan() {
      scanning = true;
    }
    
    public void endScan() {
      scanning = false;
    }
  }
  
  public final String appTitle = "Crimson - by Juho Kim and Ryan Green";
  
  public Crimson root;
  public Properties properties;
  private Object3D obj;
  private Robot robot;
  private SerialStream serialStream;
  private final int refreshRate = 9600;
  
  public float unit;
  
  private ArrayList<Widget> widgets;
  
  public Application(Crimson root) {
    this.root = root;
    this.properties = new Properties();
    this.obj = null;
    
    try {
      this.robot = new Robot();
    } catch(AWTException error) {
      println(error.getMessage());
      exit();
    }
    
    serialStream = new SerialStream(root, null, refreshRate);
    
    unit = min(0.1 * width, 0.1 * height);
    
    setWindow();
    createWidgets();
    disableCloseFileAndExportButtons();
    disableScanButton();
  }
  
  /*
   * A method that sets the properties of the root window of the program.
   */
  
  private void setWindow() {
    setTitle(appTitle);
    root.getSurface().setResizable(true);
    mouseX = width / 2;
    mouseY = height / 2;
  }
  
  /*
   * A method that sets the title of the root window.
   */
  
  private void setTitle(String title) {
    surface.setTitle(title);
  }
  
  /*
   * A method that creates the widgets of the program.
   */
  
  private void createWidgets() {
    widgets = new ArrayList<Widget>();
    
    widgets.add(new Compass(0.85 * width, 0.85 * height, 0, 0, this));
    widgets.add(new VisualBar(0.5 * width, 0.02 * height, width, 0.04 * height, this));
    widgets.add(new OpenFileButton(0.1 * width, 0.02 * height, 0.2 * width, 0.04 * height, this, "Open File"));
    widgets.add(new CloseFileButton(0.3 * width, 0.02 * height, 0.2 * width, 0.04 * height, this, "Close File"));
    widgets.add(new ExportButton(0.5 * width, 0.02 * height, 0.2 * width, 0.04 * height, this, "Export"));
    widgets.add(new ScanButton(0.7 * width, 0.02 * height, 0.2 * width, 0.04 * height, this, "Scan"));
  }
  
  /*
   * A method that activates the widgets if it is to be activated.
   */
  
  private void activateWidgets(float x, float y, boolean isActive, boolean takeAction) {
    for (Widget widget : widgets) {
      if (widget.contains(x, y) && widget.isActive() && takeAction) {
        widget.action();
      }
      
      if (widget.contains(x, y) && isActive) {
        widget.setActive(true);
      } else {
        widget.setActive(false);
      }
    }
  }
  
  /*
   * A method that updates the geomtery and the properties of the program.
   */
  
  public void update() {
    updateCursor();
    properties.update();
    updateGeometry();
    updateScanner();
  }
  
  /*
   * A method that handles properties related to the 3D scanner.
   */
  
  private void updateScanner() {
    if (!properties.scanning) {
      String portName = autoDetect();
      if (portName != null) {
        if (!serialStream.isConnected() || !serialStream.portName.equals(portName))
          serialStream.retry(portName);
          
        if (serialStream.isConnected()) {
          properties.connectTo3DScanner();
          enableScanButton();
        }
      } else {
        properties.disconnectTo3DScanner();
        disableScanButton();
      }
    } else if (serialStream.messageSynced()) {
      String message = serialStream.getSyncedMessage();
      serialStream.resetMessage();
      enableScanButton();
      properties.endScan();
      openObject3D(message.split("\n"), "Scanned File", "crm");
    }
  }
  
  /*
   * A method that scans the object.
   */
   
  public void scan() {
    if (properties.connectedTo3DScanner) {
      properties.beginScan();
      serialStream.write("scan\n");
      disableScanButton();
    }
  }
  
  /*
   * A method that displays the program.
   */
  
  public void display() {
    displayBackground();
    
    if (properties.isOpen) {
      displayObject3D();
    } else {
      pushStyle();
      fill(0);
      textSize(0.1 * height);
      text("No File Opened", 0.5 * width, 0.5 * height);
      popStyle();
    }
    
    if (properties.GUIVisible) {
      displayWidgets();
    }
  }
  
  /*
   * A method that displays the background of the program.
   */
   
  private void displayBackground() {
    background(properties.backgroundColor);
  }
  
  /*
   * A method that returns the window location of the program in the screen.
   */
  
  private PVector getWindowLocation() {
    com.jogamp.nativewindow.util.Point point = new com.jogamp.nativewindow.util.Point();
    ((com.jogamp.newt.opengl.GLWindow) root.getSurface().getNative()).getLocationOnScreen(point);
    
    return new PVector(point.getX(), point.getY());
  }
  
  /*
   * A method that returns the mouse location of the program in the screen, not the window.
   */
   
  private PVector getMouseLocation() {
    Point point = MouseInfo.getPointerInfo().getLocation();
 
    return new PVector((int) point.getX(), (int) point.getY());
  }
   
  /*
   * A method that handles the mouse dragging.
   */
   
  private void dragMouse() {
    PVector mouseLocation = getMouseLocation();
    int dx, dy;
    
    dx = int(mouseLocation.x) - properties.pmouseX;
    dy = int(mouseLocation.y) - properties.pmouseY;
    
    PVector offset = new PVector(dx, dy);
    properties.setCameraOffset(offset);
  }
   
  /*
   * A method that updates the mouse cursor position if pressed.
   */
   
  private void updateCursor() {
    PVector mouseLocation = getMouseLocation();
    
    if (root.focused && mousePressed) {
      if (mouseLocation.x == 0) {  // Mouse is at the left border of the screen.
        robot.mouseMove(displayWidth - 2, int(mouseLocation.y));
        mouseLocation.x = displayWidth - 2;
        properties.pmouseX = displayWidth - 1;
      } else if (mouseLocation.x == displayWidth - 1) {  // Mouse is at the right border of the screen.
        robot.mouseMove(1, int(mouseLocation.y));
        mouseLocation.x = 1;
        properties.pmouseX = 0;
      }
      
      if (mouseLocation.y == 0) {  // Mouse is at the top border of the screen.
        robot.mouseMove(int(mouseLocation.x), displayHeight - 2);
        mouseLocation.y = displayHeight - 1;
        properties.pmouseY = displayHeight - 1;
      } else if (mouseLocation.y == displayHeight - 1) {  // Mouse is at the bottom border of the screen.
        robot.mouseMove(int(mouseLocation.x), 1);
        mouseLocation.y = 1;
        properties.pmouseY = 0;
      }
    }
    
    if (mousePressed && properties.pmousePressed)
      dragMouse();
    
    properties.pmousePressed = mousePressed;
    properties.pmouseX = int(mouseLocation.x);
    properties.pmouseY = int(mouseLocation.y);
  }
  
  /*
   * A method that displays the loading screen.
   */
  
  private void displayLoadingScreen() {
    pushStyle();
    ortho();
    fill(1, 150);
    noStroke();
    rect(0.5 * width, 0.5 * height, width, height);
    fill(properties.textColor2);
    textSize(height * 0.1);
    text("Loading...", 0.5 * width, 0.5 * height);
    perspective();
    popStyle();
  }
  
  /*
   * A method that updates the geometry of the program, namely the window's and the widgets' sizes.
   */
  
  private void updateGeometry() {
    for (Widget widget : widgets) {
      widget.x = widget.x / properties.pwidth * width;
      widget.y = widget.y / properties.pheight * height;
      widget.width = widget.width / properties.pwidth * width;
      widget.height = widget.height / properties.pheight * height;
    }
    
    properties.pwidth = width;
    properties.pheight = height;
    unit = min(0.1 * width, 0.1 * height);
  }
  
  /*
   * A method that displays the 3D object.
   */
  
  private void displayObject3D() {
    pushMatrix();
    scale(1, -1, 1);
    
    translate(0.5 * width, -0.5 * height);
    
    float mathematicalZoom = getMathematicalZoom(properties.zoom);
    scale(mathematicalZoom, mathematicalZoom, mathematicalZoom);
    
    rotateX(properties.angleX);
    rotateY(properties.angleY);
    rotateZ(properties.angleZ);
    
    obj.display();
    popMatrix();
  }
  
  /*
   * A method that displays the widgets.
   */
  
  private void displayWidgets() {
    ortho();
    
    for (Widget widget : widgets) {
      widget.display();
    }
    
    perspective();
  }
  
  /*
   * A method that enables the close file button and the export button.
   */

  private void enableCloseFileAndExportButtons() {
    for (Widget widget : widgets) {
      if (widget instanceof CloseFileButton || widget instanceof ExportButton) {
        widget.setDisabled(false);
      }
    }
  }
  
  /*
   * A method that disables the close file button and the export button.
   */
  
  private void disableCloseFileAndExportButtons() {
    for (Widget widget : widgets) {
      if (widget instanceof CloseFileButton || widget instanceof ExportButton) {
        widget.setDisabled(true);
      }
    }
  }
  
  /*
   * A method that enables the scan button.
   */
  
  private void enableScanButton() {
    for (Widget widget : widgets) {
      if (widget instanceof ScanButton) {
        widget.setDisabled(false);
      }
    }
  }
  
  /*
   * A method that disabled the scan button.
   */
  
  private void disableScanButton() {
    for (Widget widget : widgets) {
      if (widget instanceof ScanButton) {
        widget.setDisabled(true);
      }
    }
  }
    
  /*
   * A method that opens the 3D object, given the file path.
   */
  
  public void openObject3D(String path) {
    openObject3D(path, getFileFormat(path));
  }
  
  /*
   * A method that opens the 3D object, given the file path and the file format.
   */
  
  public void openObject3D(String path, String fileFormat) {
    openObject3D(loadStrings(path), path, fileFormat);
  }
  
  public void openObject3D(String[] lines, String path, String fileFormat) {
    if (properties.isOpen) closeObject3D();
    
    try {
      DataParser dp = new DataParser(lines, fileFormat);
      obj = dp.getObject3D();
      obj.setStyle(properties.getFillColor(), properties.getStrokeColor(), properties.getStrokeWeightValue());
      
      String filename = getFilename(path);
      
      enableCloseFileAndExportButtons();
      properties.open(filename, obj.getMaxDimension());
      setTitle(filename + " | " + appTitle);
    } catch (UnknownFileFormatException error) {
      println(error.getMessage());
    } catch (Exception error) {
      println("Error processing file");
    }
  }
  
  /*
   * A method that closes the 3D object.
   */
  
  public void closeObject3D() {
    if (!properties.isOpen) return;
    
    setTitle(appTitle);
    
    obj = null;
    disableCloseFileAndExportButtons();
    properties.close();
  }
  
  /*
   * A method that exports the opened object into a selected file format to a given path.
   */
  
  public void exportObject3D(String path) {
    exportObject3D(path, getFileFormat(path));
  }
  
  /*
   * A method that exports the opened object to a given path in a given file format.
   */
  
  public void exportObject3D(String path, String fileFormat) {
    try {
      Exporter exporter = new Exporter(obj, fileFormat);
      saveStrings(path, exporter.getRawFileData().toArray(new String[0]));
    } catch (UnknownFileFormatException error) {
      println(error.getMessage());
    }
  }
  
  /*
   * A method that gets the actual scale value, given the zoom value. I use the equation: y=e^x. Any base works, as far as I am aware of.
   */
  
  private float getMathematicalZoom(float zoom) {
    return pow((float) Math.E, zoom);
  }
  
  /*
   * A method that removes the fill style attribute of the 3D object.
   */
  
  private void setNoFill(boolean noFill) {
    if (!properties.isOpen) return;
    properties.noFill = noFill;
    
    if (noFill) {
      obj.setFill(color(255, 0));
    } else {
      obj.setFill(properties.fillColor);
    }
  }
  
  public void mousePressed() {
    activateWidgets(mouseX, mouseY, true, false);
  }
  
  public void mouseReleased() {
    activateWidgets(mouseX, mouseY, false, true);
  }
  
  public void keyPressed() {
    if (key != CODED) {
      switch(key) {
        case 'w':
        properties.moveAngleXPos = true;
        break;
        case 's':
        properties.moveAngleXNeg = true;
        break;
        case 'a':
        properties.moveAngleYPos = true;
        break;
        case 'd':
        properties.moveAngleYNeg = true;
        break;
        case 'q':
        properties.moveAngleZPos = true;
        break;
        case 'e':
        properties.moveAngleZNeg = true;
        break;
        case 'r':
        properties.resetGeometry();
        break;
        case 'c':
        closeObject3D();
        break;
        case 'o':
        selectInput("Select input", "openObject3D");
        break;
        case 'k':
        if (properties.isOpen)
          selectOutput("Select output", "exportObject3D");
        break;
        case 'h':
        properties.GUIVisible = !properties.GUIVisible;
        break;
        case 'm':
        setNoFill(!properties.noFill);
        break;
      }
    } else {
      switch(keyCode) {
        case UP:
        properties.zoomIn = true;
        break;
        case DOWN:
        properties.zoomOut = true;
        break;
      }
    }
  }
  
  public void keyReleased() {
    if (key != CODED) {
      switch(key) {
        case 'w':
        properties.moveAngleXPos = false;
        break;
        case 's':
        properties.moveAngleXNeg = false;
        break;
        case 'a':
        properties.moveAngleYPos = false;
        break;
        case 'd':
        properties.moveAngleYNeg = false;
        break;
        case 'q':
        properties.moveAngleZPos = false;
        break;
        case 'e':
        properties.moveAngleZNeg = false;
        break;
      }
    } else {
      switch(keyCode) {
        case UP:
        properties.zoomIn = false;
        break;
        case DOWN:
        properties.zoomOut = false;
        break;
      }
    }
  }
  
  public void mouseWheel(MouseEvent event) {
    int count = event.getCount();
    
    properties.zoom += -0.025 * count * properties.zoomScale;
  }
}

void openObject3D(File file) {  // A helper function for opening files using file selection dialog.
  if (file == null) return;
  
  Event displayLoadingScreenEvent = new DisplayLoadingScreenEvent(application);
  Event openFileEvent = new OpenFileEvent(application, file.getAbsolutePath());
  eventQueue.add(displayLoadingScreenEvent);
  eventQueue.add(openFileEvent);
}

void exportObject3D(File file) {  // A helper function for exporting 3D objects using the file selection dialog.
  if (file == null) return;
  
  String path = file.getAbsolutePath();
  
  if (getFileFormat(path).equals("")) {
    path += ".obj";
  }
  
  application.exportObject3D(path);
}

String getFilename(String path) {  // A function that gets the filename from a path.
  int lastIndex = path.lastIndexOf(File.separator);
  
  if (lastIndex == -1) {
    return path;
  } else {
    return path.substring(lastIndex + 1);
  }
}

String getFileFormat(String path) {  // A function that gets the file format, given the path.
  int lastIndex = path.lastIndexOf(".");
  
  if (lastIndex == -1) {
    return "";
  } else {
    return path.substring(lastIndex + 1);
  }
}

float perSecond(float scalar) {  // A function that modifies the scalar (out of seconds) so that it reflects the framerate of the program.
  return scalar / frameRate;
}
