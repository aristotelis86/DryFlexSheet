//=========================== Spring Class ========================//

//-------------------- Example Code for Testing -------------------//
////***************************** INPUTS Section *****************************//

//int nx = (int)pow(2,6); // x-dir resolution
//int ny = (int)pow(2,6); // y-dir resolution

//int N = 4; // number of control points to create

//float t = 0; // time keeping
//float dt = 0.01; // time step size

//float restLength = 4;
//float stiffness = 10;
//float damping = 2;
//float thickness = 1;

////============================ END of INPUTS Section ============================//

//***************************** Setup Section *****************************//
//Window view; // convert pixels to non-dim frame
//ControlPoint [] cpoints = new ControlPoint[N]; // create the set of points
//Spring spring1, spring2;
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
  
//  spring1 = new Spring( cpoints[0], cpoints[1], restLength, stiffness, damping, thickness, view);
//  spring2 = new Spring( cpoints[2], cpoints[3], restLength, stiffness, damping, thickness, view);
  
//  myWriter = new WriteInfo(cpoints);
//} // end of setup

////***************************** Draw Section *****************************//
//void draw() {
//  background(185);
//  fill(0); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Update
//  for (ControlPoint cp : cpoints) { cp.clearForce(); }
//  spring1.applyAllForces();
//  spring2.applyAllForces();
//  for (ControlPoint cp : cpoints) { cp.update(dt); }
  
//  // Display
//  spring1.display();
//  spring2.display();
//  for (ControlPoint cp : cpoints) { cp.display(); }
  
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

class Spring {
  //========== Attributes - Physical ============//
  float stiffness; // stiffness of spring
  float restLength; // resting length 
  float damping; // damping for simulating the presence of dashpot
  ControlPoint p1, p2; // particle that it is connected to
  
  // For display purposes
  Window myWindow;
  float thick; // default thickness = 1
  color c; // default random coloring
  
  //=============== Constructor =================//
  Spring( ControlPoint a, ControlPoint b, float r, float s, float d, float th_, Window w ) {
    p1 = a;
    p2 = b;
    
    stiffness = s;
    restLength = r;
    damping = d;
    
    myWindow = w;
    thick = myWindow.pdx(th_);
    c = color(random(1,255), random(1,255), random(1,255));
  }
  Spring( ControlPoint a, ControlPoint b, float r, float s, float d, Window w) { 
    this( a, b, r, s, d, 1, w);}
  
  //=================== Methods ================//
  
  // Display
  void display(){
    strokeWeight(thick);
    stroke(c);
    line(myWindow.px(p1.position.x), myWindow.py(p1.position.y), myWindow.px(p2.position.x), myWindow.py(p2.position.y));
  }
  
  // Apply Forces on connected particles
  void applyAllForces() {
    // apply force due to spring
    PVector springDir = PVector.sub(p1.position, p2.position);
    
    float stretch = springDir.mag();
    stretch -= restLength;
    
    springDir.normalize();
    PVector Tension = PVector.mult(springDir,-stiffness * stretch);
    p1.force.add(Tension);
    Tension.mult(-1);
    p2.force.add(Tension);
    
    // apply force due to dashpot
    PVector RelatVel = PVector.sub(p1.velocity, p2.velocity);
    
    float DampMag = PVector.dot(RelatVel, springDir);
    DampMag = (-1)*DampMag*damping;
    
    PVector DampVec = PVector.mult(springDir, DampMag);
    
    p1.force.add(DampVec);
    DampVec.mult(-1);
    p2.force.add(DampVec);
  }
  
  // Get the stretch of the spring
  float getStretch() {
    PVector SpringDir = PVector.sub(p1.position, p2.position);
    float stretch = SpringDir.mag();
    stretch -= restLength;
    
    return stretch;
  }
  
  // Assign different stiffness from the one constructed
  void updateStiffness(float kk) {
    stiffness = kk;
  }
  
  // Update the damping coefficient if needed
  void UpdateDamping(float dd) {
    damping = dd;
  }
  
} // end of Spring class