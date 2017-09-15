//***************************** INPUTS Section *****************************//
int nx = (int)pow(2,7); // x-dir resolution
int ny = (int)pow(2,7); // y-dir resolution

float t = 0; // time keeping
float dt; // time step size

float L1 = ny/5.;
float th = 2;
float M1 = 1;
int resol =2;
float stiffness1 = 100;
float xpos1 = nx/2.;
float ypos1 = 6*ny/10.;
PVector align1 = new PVector(0, 1);
PVector gravity = new PVector(0, 10);

boolean saveVidFlag = true;
//============================ END of INPUTS Section ============================//

//***************************** Setup Section *****************************//
Window view; // convert pixels to non-dim frame
FlexibleSheet sheet1;
WriteInfo myWriter; // output information
Collisions collider1;
CollisionSolver collider2;

// provision to change aspect ratio of window only instead of actual dimensions
void settings(){
    size(600, 600);
}

void setup() {
  
  view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  
  sheet1 = new FlexibleSheet( L1, th, M1, resol, stiffness1, xpos1, ypos1, align1, view );
  
  float dt1 = sheet1.dtmax;
  dt = dt1;
  
  collider1 = new Collisions( sheet1, view );
  collider2 = new CollisionSolver( sheet1, view);
  
  myWriter = new WriteInfo( sheet1 );
} // end of setup

//***************************** Draw Section *****************************//
void draw() {
  background(185);
  fill(0); // color of text for timer
  textSize(32); // text size of timer
  text(t, 10, 30); // position of timer
  
  // Update
  sheet1.update( dt, gravity );
  sheet1.update2( dt, gravity );
  
  //collider1.SolveCollisions();
  //collider2.SolveCollisions();
  
  // Display
  sheet1.mydisplay();
  
  // Write output
  //myWriter.InfoSheet( t, gravity, ny );
  if (saveVidFlag) saveFrame("./movie/frame_######.png");
  
  if (t>60) terminateRun();
  t += dt;
} // end of draw

// Gracefully terminate writing...
void keyPressed() {  
  myWriter.closeInfos();
  exit(); // Stops the program 
}
void terminateRun() {  
  myWriter.closeInfos();
  exit(); // Stops the program 
}