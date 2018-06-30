/*
 * An UnknownFileFormatException class that works as a custom exception class that gets thrown when an unknown file format is specified.
 */

class UnknownFileFormatException extends Exception {
  public UnknownFileFormatException() {
    super();
  }
  
  public UnknownFileFormatException(String message) {
    super(message);
  }
}
