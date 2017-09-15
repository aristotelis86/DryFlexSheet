//***************************** INPUTS Section *****************************//
int nx = (int)pow(2,6); // x-dir resolution
int ny = (int)pow(2,6); // y-dir resolution

int N = 20; // number of control points to create

PVector gravity = new PVector(0,10);

float t = 0; // time keeping
float dt = 0.01; // time step size

boolean saveVidFlag = true;
//============================ END of INPUTS Section ============================//

//***************************** Setup Section *****************************//
Window view; // convert pixels to non-dim frame
ControlPoint [] cpoints = new ControlPoint[N]; // create the set of points
WriteInfo myWriter; // output information

// provision to change aspect ratio of window only instead of actual dimensions
void settings(){
    size(600, 600);
}

void setup() {
  Window view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  for (int i=0; i<N; i++) {
    float m = random(1,5); // assign random mass on each control point
    float th = m/2; // the size of each point is proportional to its mass
    cpoints[i] = new ControlPoint( new PVector(random(nx), random(ny)), m, th, view);
  }
  
  //myWriter = new WriteInfo(cpoints);
} // end of setup

//***************************** Draw Section *****************************//
void draw() {
  background(185);
  fill(0); // color of text for timer
  textSize(32); // text size of timer
  text(t, 10, 30); // position of timer
  
  // Update
  for (ControlPoint cp : cpoints) {
    cp.clearForce();
    cp.applyForce(gravity);
    cp.update(dt);
  }
  
  // Collision
  for (ControlPoint cp : cpoints) cp.BoundCollision( 0.05 );
  
  // Display
  for (ControlPoint cp : cpoints) cp.display();
  
  // Write output
  //myWriter.InfoCPoints();
  if (saveVidFlag) saveFrame("./movie/frame_######.png");
  
  t += dt;
} // end of draw


// Gracefully terminate writing...
void keyPressed() {
  //myWriter.closeInfos();
  exit(); // Stops the program 
}