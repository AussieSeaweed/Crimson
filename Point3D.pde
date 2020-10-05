/*
 * A Point3D class that stores the properties and the functions related to vectors.
 * This class is needed, as PVector cannot store indices of itself.
 */
 
class Point3D extends PVector {
  private int id;
  
  public Point3D(float x, float y, float z, int id) {
    super(x, y, z);
    
    this.id = id;
  }
  
  public void setID(int id) {
    this.id = id;
  }
  
  public int getID() {
    return id;
  }
}
