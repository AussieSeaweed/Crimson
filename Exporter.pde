/*
 * An Exporter class that exports the given 3D object into files.
 */

class Exporter {
  
  /*
   * An object cannot be exported into 'crm' files, as 'crm' file formats are too specialized. Thus, it is only compatible with a certain group of shapes.
   * Due to this, the only way to obtain the files of crm format would be to use the 3D scanner, which would be built.
   */
  
  public final String[] fileFormats = {  // Supported file formats.
    "obj"
  };
  
  private ArrayList<String> rawFileData;
  
  public Exporter(Object3D obj) throws UnknownFileFormatException {
    this(obj, "obj");
  }
  
  public Exporter(Object3D obj, String fileFormat) throws UnknownFileFormatException {
    rawFileData = new ArrayList<String>();
    final ArrayList<Point3D> vertices = obj.getVertices();
    final ArrayList<ArrayList<Integer>> planeIndices = obj.getPlaneIndices();
    
    /*
     * The exporting process is simpler than parsing process.
     */
    
    switch(fileFormat) {
      case "obj": {
        rawFileData.add("# Created with Crimson by Juho Kim and Ryan Green\n");
        
        for (Point3D vertex : vertices) {
          rawFileData.add("v " + vertex.x + " " + vertex.y + " " + vertex.z);
        }
        
        for (ArrayList<Integer> plane : planeIndices) {
          String line = "f";
          
          for (int i : plane) {
            line += " " + (i + 1);
          }
          
          rawFileData.add(line);
        }
        
        break;
      }
      
      default: {
        throw new UnknownFileFormatException("Unkown Data Type: " + fileFormat);
      }
    }
  }
  
  /*
   * A method that returns the raw file data to be written into files.
   */
  
  public ArrayList<String> getRawFileData() {
    return rawFileData;
  }
}
