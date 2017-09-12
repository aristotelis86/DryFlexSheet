//***************************** INPUTS Section *****************************//

int nx = (int)pow(2,7); // x-dir resolution
int ny = (int)pow(2,7); // y-dir resolution


float t = 0; // time keeping
float dt; // time step size

float L = ny/3.;
float th = 1;
float M = 2;
int resol =1;
float stiffness = 500;
float xpos = nx/2.;
float ypos = ny/10.;
PVector align = new PVector(0, 1);
PVector gravity = new PVector(0, 10);

float maxVel = 30; // amplitude of init velocity at the bottom

boolean saveVidFlag = true;
//============================ END of INPUTS Section ============================//

//***************************** Setup Section *****************************//
Window view; // convert pixels to non-dim frame
FlexibleSheet sheet;
WriteInfo myWriter; // output information

// provision to change aspect ratio of window only instead of actual dimensions
void settings(){
    size(600, 600);
}

void setup() {
  view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  sheet = new FlexibleSheet( L, th, M, resol, stiffness, xpos, ypos, align, view );
  sheet.cpoints[0].makeFixed();
  sheet.Calculate_Stretched_Positions( gravity );
  
  // Apply the impulse
  int N = sheet.numOfpoints;
  
  // Add an impulse (x-dir) to the particles
  for (int i = 1; i < N; i++) {
    sheet.cpoints[i].velocity.x += ((i-1)/(N-2)) * maxVel;
  }
  
  dt = sheet.dtmax;
  
  myWriter = new WriteInfo( sheet );
} // end of setup

//***************************** Draw Section *****************************//
void draw() {
  background(185);
  fill(0); // color of text for timer
  textSize(32); // text size of timer
  text(t, 10, 30); // position of timer
  
  // Update
  sheet.update( dt, gravity );
  sheet.update2( dt, gravity );
  
  // Display
  sheet.display();
  
  // Write output
  myWriter.InfoSheet( t, gravity, ny );
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