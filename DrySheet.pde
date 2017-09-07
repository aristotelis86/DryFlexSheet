//////////////////////////////////////////////////////////////////////
//////////////////////// INPUTS Section //////////////////////////////

int nx = (int)pow(2,9); // x-dir resolution
int ny = (int)pow(2,9); // y-dir resolution
float xpos = nx/2.; // x-location of leading point
float ypos = 2.; // y-location of leading point

float L = 20; // length of filament in grid units
int res = 1; // resolution
float thick = 1; // thickness of filament
float M = 10; // line mass density 

float stiff = 1000; // stiffness of each spring used (non-dim)

float t = 0; // time keeping variable
float dt; // time step size

PVector align = new PVector(0,1); // initial alignment of filament
PVector gravity = new PVector(0, 10); // constant gravity

float maxVel = 20;

//////////////////////// END of INPUTS Section //////////////////////////////
/////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
////////////////////////// Setup Section ///////////////////////////////////
FlexibleSheet filament;
Window view; // convert pixels to non-dim frame
WriteInfo myWriter;


void settings(){
    size(800, 600);
}

void setup() {
  
  Window view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  
  filament = new FlexibleSheet( L, thick, M, res, stiff, xpos, ypos, align, view);
  filament.cpoints[0].makeFixed();
  
  filament.Calculate_Stretched_Positions( gravity );
  
  // Create the distortion
  int N = filament.numOfpoints;
  
  // Add an impulse (x-dir) to the particles
  for (int i = 1; i < N; i++) {
    filament.cpoints[i].velocity.x += ((i-1)/(N-2)) * maxVel;
  }

  dt = filament.dtmax;
  
  myWriter = new WriteInfo(filament);
} // end of setup


////////////////////////////////////////////////////////////////////////////
////////////////////////// Draw Section ///////////////////////////////////
void draw() {
  background(185);
  fill(0, 0, 0);
  textSize(32);
  text(t, 10, 30);
  
  // Update
  filament.update(dt, gravity);
  filament.update2(dt, gravity);
  
  // Display
  filament.display();
  
  // Write Information to files
  myWriter.InfoSheet(t, gravity, ny);
  
  t += dt;
  
  if (t>120) terminateRun();
  //noLoop();
}


// Gracefully terminate writing...
void keyPressed() {
  myWriter.closeInfos();
  exit(); // Stops the program 
}
void terminateRun() {
  myWriter.closeInfos();
  exit(); // Stops the program 
}