//======================= ControlPoint Class ====================== //

// ------------------- Example Code for Testing ------------------- //
////***************************** INPUTS Section *****************************//

//int nx = (int)pow(2,6); // x-dir resolution
//int ny = (int)pow(2,6); // y-dir resolution

//int N = 20; // number of control points to create

//PVector gravity = new PVector(0,10);

//float t = 0; // time keeping
//float dt = 0.01; // time step size

////============================ END of INPUTS Section ============================//

////***************************** Setup Section *****************************//
//Window view; // convert pixels to non-dim frame
//ControlPoint [] cpoints = new ControlPoint[N]; // create the set of points
//WriteInfo myWriter; // output information

//// provision to change aspect ratio of window only instead of actual dimensions
//void settings(){
//    size(600, 600);
//}


//void setup() {
//  Window view = new Window( 1, 1, nx, ny, 0, 0, width, height);
//  for (int i=0; i<N; i++) {
//    float m = random(1,5); // assign random mass on each control point
//    float th = m/2; // the size of each point is proportional to its mass
//    cpoints[i] = new ControlPoint( new PVector(random(nx), random(ny)), m, th, view);
//  }
  
//  myWriter = new WriteInfo(cpoints);
//} // end of setup

////***************************** Draw Section *****************************//
//void draw() {
//  background(185);
//  fill(0); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Update
//  for (ControlPoint cp : cpoints) {
//    cp.clearForce();
//    cp.applyForce(gravity);
//    cp.update(dt);
//  }
  
//  // Display
//  for (ControlPoint cp : cpoints) {
//    if (cp.position.y > ny) cp.position.y = ny; // basic collision at the bottom 
//    cp.display();
//  }
  
//  // Write output
//  myWriter.InfoCPoints();
  
//  t += dt;
//} // end of draw


//// Gracefully terminate writing...
//void keyPressed() {
  
//  myWriter.closeInfos();
//  exit(); // Stops the program 
//}
// ---------------------------------------------------------------- //

class ControlPoint {
  //================= Attributes ====================//
  
  PVector position; // current position
  PVector positionOld;
  PVector velocity; // current velocity
  PVector velocityOld;
  PVector acceleration; // current acceleration
  PVector force; // force acting on the point-mass
  float mass; // mass of the point
  boolean fixed; // fix the particle at its location
  boolean xfixed; // fix the particle at its y-axis
  boolean yfixed; // fix the particle at its x-ayis
  
  Window myWindow; // viewing window
  color c; // for displaying
  float thick; // for collisions model
  
  //================= Constructor ====================//
  ControlPoint(PVector position_, float m,  float thk, Window myWindow_) {
    position = position_;
    velocity = new PVector(0, 0);
    force = new PVector(0, 0);
    mass = m;
    
    fixed = false;
    xfixed = false;
    yfixed = false;
    
    myWindow = myWindow_;
    c = color(random(1,255), random(1,255), random(1,255));
    thick = thk;
    
    positionOld = position.copy();
    velocityOld = velocity.copy();
  }
  
  ControlPoint(PVector position_, float m, Window myWindow_) {this(position_, m,  1, myWindow_);}
  
  
  //================= Methods =====================//
  
  // Display
  void display() {
    noStroke();
    fill(c);
    ellipse(myWindow.px(position.x), myWindow.py(position.y), myWindow.px(thick), myWindow.py(thick));
  }
  
  void impDisplay() {
    noStroke();
    fill(255, 0, 0);
    ellipse(myWindow.px(position.x), myWindow.py(position.y), myWindow.px(thick+.3), myWindow.py(thick+.3));
  }
  
  // Clear any forces acting on the particle
  void clearForce() {
    force.mult(0);
  }
  
  // Accumulate all the forces acting on the particle
  void applyForce(PVector FF) {
    force.add(FF);
  }
  
  // Find the acceleration due to forces
  void calculateAcceleration() {
    PVector accel = force.copy();
    acceleration = accel.div(mass);
  }
  
  // Make the particle free of constraints
  void makeFree() {
    fixed = false;
    xfixed = false;
    yfixed = false;
  }
  
  void makeFreex() { xfixed = false; }
  void makeFreey() { yfixed = false; }
  
  // Constrain the particle at its location
  void makeFixed() {
    fixed = true;
    xfixed = true;
    yfixed = true;
  }
  
  // Constrain the particle at its y-axis
  void makeFixedx() { xfixed = true; }
  
  // Constrain the particle at its x-axis
  void makeFixedy() { yfixed = true; }
  
  
  // Get the distance between control points
  float distance(ControlPoint other) {
    float d = this.position.dist(other.position);
    return d;
  }
  
  // For testing...
  void move() {
    PVector randVel = new PVector(random(-1,1), random(-1,1));
    position.add(randVel);
  }
  
  // 
  void update(float t) {
    //PVector accel = PVector.div(force, mass);
    calculateAcceleration();
    velocity.add(PVector.mult(acceleration,t));
    position.add(PVector.mult(velocity,t));
  }
  
  void UpdatePosition(float x, float y) {
    position.x = x;
    position.y = y;
  }
  
  void UpdateVelocity(float x, float y) {
    velocity.x = x;
    velocity.y = y;
  }
} // end of ControlPoint class