/*
 * A SerialStream class that functions as a wrapper class of the AP_Sync class, used to connect the program to the 3D printer.
 */

class SerialStream {
  private Crimson root;
  private String portName;
  private int refreshRate;
  private Serial streamer;
  private String syncedMessage;
  private boolean encounteredEnd;
  
  public SerialStream(Crimson root, String portName, int refreshRate) {
    this.root = root;
    this.portName = portName;
    this.refreshRate = refreshRate;
    syncedMessage = "";
    encounteredEnd = false;
    if (isConnected())
      createStreamer();
    else
      streamer = null;
  }
  
  public boolean isConnected() {
    return portName != null;
  }
  
  public boolean retry(String portName) {
    if (portName != null) {
      this.portName = portName;
      createStreamer();
      return true;
    } else {
      return false;
    }
  }
  
  private void createStreamer() {
    streamer = new Serial(root, portName, refreshRate);
  }
  
  public void write(String token) {
    if (isConnected())
      streamer.write(token);
  }
  
  public void update() {
    if (encounteredEnd) return;
    String token = streamer.readString();

    if (token == "end\n") {
      encounteredEnd = true;
      return;
    }
    if (token != null && token.length() > 0 && !token.equals("null"))
      syncedMessage += token;
  }
  
  public boolean messageSynced() {
    update();
    return encounteredEnd;
  }
  
  public String getSyncedMessage() {
    update();
    return isConnected() ? syncedMessage : null;
  }
  
  public void resetMessage() {
    syncedMessage = "";
    encounteredEnd = false;
  }
}

/*
 * A function that detects the printer from the mounted hardware.
 */

String autoDetect() {
  return Serial.list().length > 0 ? Serial.list()[0] : null;
}
