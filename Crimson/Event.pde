/*
 * An Event class that handles the processes that needs to be done in between frames.
 * The necessity of this class arises when it is necessary to display something and begin a costly operation.
 * Since the window is refreshed if and only if the global function 'draw' returns, it is necessary to start the costly operation after
 * the draw function that displays whatever that needs to be displayed is returned. Having this class simplifies the code vastly.
 */

abstract class Event {
  public abstract void call();
}

/*
 * Inherited classes with specializations.
 */

class DisplayLoadingScreenEvent extends Event {
  Application application;
  
  public DisplayLoadingScreenEvent(Application application) {
    this.application = application;
  }
  
  public void call() {
    application.displayLoadingScreen();
  }
}

class OpenFileEvent extends Event {
  Application application;
  String path;
  
  public OpenFileEvent(Application application, String path) {
    this.application = application;
    this.path = path;
  }
  
  public void call() {
    application.openObject3D(path);
  }
}
