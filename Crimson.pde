/*
 * A Program that displays 3D objects of various file formats.
 */

import java.util.*;
import java.util.concurrent.*;
import java.lang.*;
import java.awt.*;
import processing.serial.*;

Application application;  // An application instance.
LinkedBlockingQueue<Event> eventQueue;  // A concurrent thread-safe queue that stores events that needs to be taken care of in between frames.

/*
 * A function that gets called when the program is initiated.
 */

void setup() {
  size(1280, 720, P3D);
  frameRate(1000);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  application = new Application(this);
  eventQueue = new LinkedBlockingQueue();
}

/*
 * A function that gets called every frame.
 */

void draw() {
  application.update();
  application.display();
  
  if (!eventQueue.isEmpty())  // If some events need to be handled...
    eventQueue.remove().call();
}

void keyPressed() {
  application.keyPressed();
}

void keyReleased() {
  application.keyReleased();
}

void mousePressed() {
  application.mousePressed();
}

void mouseReleased() {
  application.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  application.mouseWheel(event);
}
