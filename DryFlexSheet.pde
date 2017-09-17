//***************************** INPUTS Section *****************************//
int nx = (int)pow(2,6); // x-dir resolution
int ny = (int)pow(2,6); // y-dir resolution

float L = ny/4.;
float thick = 1;
float M = 0.5;
int resol = 1;
float stiffness = 100;
float xpos = nx/2.;
float ypos = ny/4.;

PVector align = new PVector(0,1);

PVector gravity = new PVector(0,10);

float t = 0; // time keeping
float dt; // time step size

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
  Window view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  
  sheet = new FlexibleSheet( L, thick, M, resol, stiffness, xpos, ypos, align, view );
  sheet.cpoints[0].makeFixed();
  sheet.Calculate_Stretched_Positions( gravity );
  
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
  
  // Collision
  
  
  // Display
  sheet.display();
  
  // Write output
  myWriter.saveInfoSheet( t, gravity, ny, 0 );
  if (saveVidFlag) saveFrame("./movie/frame_######.png");
  
  t += dt;
} // end of draw


// Gracefully terminate writing...
void keyPressed() {
  myWriter.closeInfos();
  exit(); // Stops the program 
}