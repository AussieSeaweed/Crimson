/*
 * An Object3D class that handles the drawing and the style attributes of the 3D shapes.
 */

class Object3D {
  private ArrayList<Point3D> vertices;
  private ArrayList<ArrayList<Integer>> planeIndices;
  private ArrayList<PShape> planes;
  private PVector dimensions;

  public Object3D(ArrayList<Point3D> vertices, ArrayList<ArrayList<Integer>> planeIndices, ArrayList<PShape> planes, PVector dimensions) {
    this.vertices = vertices;
    this.planeIndices = planeIndices;
    this.planes = planes;
    this.dimensions = dimensions;
    cache();
  }
  
  /*
   * A method that caches the object. This is necessary, as spontaneous drawing process may cause some planes to not be displayed properly.
   * Notice how it is just 'displaying' the shapes. Throughout the program, caching is only done after the data is parsed. I am still not
   * too sure why this eliminates the aforesaid problem, but it works.
   */
  
  private void cache() {
    for (PShape plane : planes) {
      shape(plane);
    }
  }
  
  /*
   * A method that displays the 3D shape.
   */
  
  public void display() {
    for (PShape plane : planes) {
      shape(plane);
    }
  }
  
  /*
   * A method that sets the style properties of the 3D shape.
   */
  
  public void setFill(color fillColor) {
    for (PShape plane : planes) {
      plane.setFill(fillColor);
    }
  }
  
  public void setStroke(color strokeColor) {
    for (PShape plane : planes) {
      plane.setStroke(strokeColor);
    }
  }
  
  public void setStrokeWeight(float strokeWeightValue) {
    for (PShape plane : planes) {
      plane.setStrokeWeight(strokeWeightValue);
    }
  }
  
  public void setStyle(color fillColor, color strokeColor, float strokeWeightValue) {
    setFill(fillColor);
    setStroke(strokeColor);
    setStrokeWeight(strokeWeightValue);
  }
  
  /*
   * A method that gets all the vertices of the 3D shape.
   */
  
  public final ArrayList<Point3D> getVertices() {
    return vertices;
  }
  
  /*
   * A method that gets the plane indices of the 3D shape.
   */
  
  public final ArrayList<ArrayList<Integer>> getPlaneIndices() {
    return planeIndices;
  }
  
  /*
   * A method that gets the dimensions of the 3D shape. Note that this is not a minimum bounding box of the 3D shape, but rather a bounding box of
   * the smallest size that is aligned with the x, y, and z axis.
   */
  
  public PVector getDimensions() {
    return dimensions.copy();
  }
  
  /*
   * A method that returns the largest of the x, y, or z dimensions of the 3D shape.
   */
  
  public float getMaxDimension() {
    return max(dimensions.x, dimensions.y, dimensions.z);
  }
}
