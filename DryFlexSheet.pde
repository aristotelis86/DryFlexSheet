//***************************** INPUTS Section *****************************//

int nx = (int)pow(2,8); // x-dir resolution
int ny = (int)pow(2,8); // y-dir resolution

float t = 0; // time keeping
float dt; // time step size

float L1 = ny/5.;
float L2 = nx/2.;
float th = 2;
float M1 = 1;
float M2 = 2;
int resol =1;
float stiffness1 = 1000;
float stiffness2 = 10000;
float xpos1 = nx/2.;
float xpos2 = nx/4.;
float ypos1 = ny/10.;
float ypos2 = 7.*ny/10.;
PVector align1 = new PVector(0, 1);
PVector align2 = new PVector(1, 0);
PVector gravity = new PVector(0, 10);

boolean saveVidFlag = true;
//============================ END of INPUTS Section ============================//

//***************************** Setup Section *****************************//
Window view; // convert pixels to non-dim frame
FlexibleSheet sheet1, sheet2;
WriteInfo myWriter; // output information

// provision to change aspect ratio of window only instead of actual dimensions
void settings(){
    size(600, 600);
}

void setup() {
  view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  
  sheet1 = new FlexibleSheet( L1, th, M1, resol, stiffness1, xpos1, ypos1, align1, view );
  sheet1.cpoints[0].makeFixed();
  sheet1.Calculate_Stretched_Positions( gravity );
  
  sheet2 = new FlexibleSheet( L2, th, M2, resol, stiffness2, xpos2, ypos2, align2, view );
  sheet2.cpoints[0].makeFixed();
  sheet2.cpoints[sheet2.numOfpoints-1].makeFixed();
  sheet2.Calculate_parabola( gravity );
  
  float dt1 = sheet1.dtmax;
  float dt2 = sheet2.dtmax;
  dt = min(dt1, dt2);
  
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
  sheet2.update( dt, gravity );
  sheet2.update2( dt, gravity );
  
  // Display
  sheet1.display();
  sheet2.display();
  
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