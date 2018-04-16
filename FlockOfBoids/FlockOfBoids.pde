/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 * 
 * This example displays the 2D famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 and then adapted to Processing in 3D by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * Boids under the mouse will be colored blue. If you click on a boid it will be
 * selected as the scene avatar for the eye to follow it.
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the mesh visual mode.
 * Press 't' to shift timers: sequential and parallel.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 * Modes: i for Processing immediate mode; r for Processing retained mode;
 */

import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;
import java.util.Map;

Scene scene;
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

// visual modes
// 0. Faces and edges
// 1. Wireframe (only edges)
// 2. Only faces
// 3. Only points

int mode;
int immediateMode;
int vertexVertexRepresentation;

int initBoidNum = 100; // amount of boids to start the program with
ArrayList<Boid> flock;
Node avatar;
boolean animate = true;

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  Eye eye = new Eye(scene);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.fitBall();
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
}

void draw() {
  background(0);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  // Calls Node.visit() on all scene nodes.
  scene.traverse();
  showStats();
}
 int xPos = 1;  
 float x1 = 0;
 float x2;
 float y1;
 float y2 = height / 2;
Map<Integer,Float> grafica = new HashMap<Integer,Float>();
int value = 0;
int increment = 2;
float max = 0;
float min = 1000;
void showStats(){
   //SHOW STATS
    textSize(28); 
    fill(0, 102, 153);
    text("Frame rate: " + frameRate, 40, 60);
    text(" Max: "+max, 400, 60);
    text(" Min: "+min, 700, 60);
    text(" Birds: "+initBoidNum, 1000, 60);
   fill(204, 102, 0);
   float inByte = map(frameRate, 0, 70, 0, height);
   // draw the line:
   stroke(204);
   grafica.put(value,y1);
   value++;
   grafica.put(value,y2);
   value++;
   for(int i = 1; i<grafica.size();i++){
     line((i-1)*increment, grafica.get(i-1),(i)*increment, grafica.get(i));
   }
   y1 = y2;
   y2 = height - inByte;
   // at the edge of the screen, go back to the beginning:
   if (xPos >= flockDepth+30) {
   xPos = 0;
   value = 0;
   }else {
   // increment the horizontal position:
   xPos+=increment;
   }
   
   if(value>2){
     if (max<frameRate) max=frameRate;
     if (min>frameRate) min=frameRate;
   }
   
}

void walls() {
  pushStyle();
  noFill();
  stroke(255);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case 'i':
    immediateMode = immediateMode == 0 ? 1 : 0;
    break;
  case 'm':
    mode = mode < 3 ? mode+1 : 0;
    break;
  case 'x':
    vertexVertexRepresentation = vertexVertexRepresentation == 0 ? 1 : 0;
    break;
  case ' ':
    if (scene.eye().reference() != null) {
      scene.lookAt(scene.center());
      scene.fitBallInterpolation();
      scene.eye().setReference(null);
    } else if (avatar != null) {
      scene.eye().setReference(avatar);
      scene.interpolateTo(avatar);
    }
    break;
  }
}
