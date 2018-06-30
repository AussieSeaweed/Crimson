/*
 * A DataParser class that parses the data from an opened file.
 */

class DataParser {
  public final String[] fileFormats = {  // Supported file formats.
    "crm",  // Custom file format created to read from the 3D printer.
    "obj"
  };
  
  private Object3D obj;
  private PVector dimensions;
  
  public DataParser(String rawData) throws UnknownFileFormatException, Exception {
    this(rawData.split("\n"), "crm");
  }
  
  public DataParser(String[] lines, String fileFormat) throws UnknownFileFormatException, Exception {
    ArrayList<Point3D> vertices = new ArrayList<Point3D>();
    ArrayList<ArrayList<Integer>> planeIndices = new ArrayList<ArrayList<Integer>>();
    ArrayList<PShape> planes = new ArrayList<PShape>();

    /*
     * Parsing files... 
     */

    switch (fileFormat) {
      case "crm": {
        int row = int(lines[0]);
        int col = int(lines[1]);
        
        Point3D[][] levelCoords = new Point3D[row][col];
        
        for (int i = 2; i < lines.length; i++) {
          String[] rawCoords = lines[i].split(" ");
          float x = float(rawCoords[0]);
          float y = float(rawCoords[1]);
          float z = float(rawCoords[2]);
          
          Point3D coord = y < 0 ? null : new Point3D(x, y, z, vertices.size());
          
          levelCoords[(i - 2) / col][(i - 2) % col] = coord;
          if (coord != null) {
            vertices.add(coord);
          }
        }

        centerCoords(vertices);
        
        for (int r = 0; r < row - 1; r++) {
          for (int c = 0; c < col; c++) {
            int nextC = (c + 1) % col;
            ArrayList<Point3D> coords = new ArrayList<Point3D>();
            
            if (levelCoords[r][c] != null) {
              coords.add(levelCoords[r][c]);
            }
            if (levelCoords[r][nextC] != null) {
              coords.add(levelCoords[r][nextC]);
            }
            if (levelCoords[r + 1][nextC] != null) {
              coords.add(levelCoords[r + 1][nextC]);
            }
            if (levelCoords[r + 1][c] != null) {
              coords.add(levelCoords[r + 1][c]);
            }
            
            if (coords.size() > 2) {
              ArrayList<Integer> indices = new ArrayList<Integer>();
              PShape plane = createShape();
              
              plane.beginShape();
              
              for (Point3D coord : coords) {
                indices.add(coord.id);
                plane.vertex(coord.x, coord.y, coord.z);
              }
              
              plane.endShape(CLOSE);
              
              planeIndices.add(indices);
              planes.add(plane);
            }
          }
        }
        
        ArrayList<Integer> baseIndices = new ArrayList<Integer>();
        PShape basePlane = createShape();
        ArrayList<Integer> topIndices = new ArrayList<Integer>();
        PShape topPlane = createShape();
        
        basePlane.beginShape();
        topPlane.beginShape();
        
        for (int c = 0; c < col; c++) {
          if (levelCoords[0][c] != null) {
            baseIndices.add(levelCoords[0][c].id);
            basePlane.vertex(levelCoords[0][c].x, levelCoords[0][c].y, levelCoords[0][c].z);
          }
          if (levelCoords[row - 1][c] != null) {
            topIndices.add(levelCoords[row - 1][c].id);
            topPlane.vertex(levelCoords[row - 1][c].x, levelCoords[row - 1][c].y, levelCoords[row - 1][c].z);
          }
        }
        
        basePlane.endShape(CLOSE);
        topPlane.endShape(CLOSE);
        
        planeIndices.add(baseIndices);
        planeIndices.add(topIndices);
        planes.add(basePlane);
        planes.add(topPlane);
        
        break;
      }
      
      case "obj": {
        boolean centeredCoords = false;
        
        for (String line : lines) {
          Scanner scanner = new Scanner(line);
          
          if (!scanner.hasNext()) continue;
          
          String type = scanner.next();
          
          switch (type) {
            case "v": {
              centeredCoords = false;
              
              float x = scanner.nextFloat();
              float y = scanner.nextFloat();
              float z = scanner.nextFloat();
              
              Point3D coord = new Point3D(x, y, z, vertices.size());
              
              vertices.add(coord);
              break;
            }
            
            case "f": {
              if (!centeredCoords) {
                centerCoords(vertices);
                centeredCoords = true;
              }
              
              ArrayList<Integer> indices = new ArrayList<Integer>();
              PShape plane = createShape();
              
              plane.beginShape();
              
              while (scanner.hasNext()) {
                String next = scanner.next();
                int lastIndex = next.indexOf("/");
                int i;
                
                if (lastIndex == -1) i = int(next);
                else i = int(next.substring(0, lastIndex));
                
                indices.add(i - 1);
                plane.vertex(vertices.get(i - 1).x, vertices.get(i - 1).y, vertices.get(i - 1).z);
              }
              
              plane.endShape(CLOSE);
              
              planeIndices.add(indices);
              planes.add(plane);
              break;              
            }
          }
          
          scanner.close();
        }
        
        break;
      }
      
      default: {
        throw new UnknownFileFormatException("Unknown Data Type: " + fileFormat);
      }
    }
    
    obj = new Object3D(vertices, planeIndices, planes, dimensions);
  }
  
  /*
   * A method that, given the ArrayList of points, centers all the points.
   */
  
  private void centerCoords(ArrayList<Point3D> vertices) {
    PVector min = new PVector(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY);
    PVector max = new PVector(Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY);
    
    for (Point3D vertex : vertices) {
      min.x = min(min.x, vertex.x);
      min.y = min(min.y, vertex.y);
      min.z = min(min.z, vertex.z);
      max.x = max(max.x, vertex.x);
      max.y = max(max.y, vertex.y);
      max.z = max(max.z, vertex.z);
    }
    
    PVector center = PVector.div(PVector.add(min, max), 2);
    
    for (Point3D vertex : vertices) {
      vertex.sub(center);
    }
    
    dimensions = PVector.sub(max, min);
  }
  
  /*
   * A method that returns the 3D object created from the file.
   */
  
  public Object3D getObject3D() {
    return obj;
  }
}
