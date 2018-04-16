abstract class IRepresentation {
  PShape shape;
  ArrayList<Vector> vertices;
  ArrayList<Vector> faces;

  IRepresentation() {    
    vertices = new ArrayList<Vector>();
    faces = new ArrayList<Vector>();
  }

  // Compute both solid vertices and pshape
  abstract void buildShape();

  // Transfer geometry every frame
  abstract void drawImmediate();

  void draw() {
    pushStyle();
    if(immediateMode == 1){
      drawImmediate();
    } else{
      shape(shape);
    }
    popStyle();
  }
}
