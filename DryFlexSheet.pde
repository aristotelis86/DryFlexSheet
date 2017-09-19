Window view; // window in h-units

int nx = (int)pow(2,6); // x-dir
int ny = (int)pow(2,6); // y-dir

float L = nx/4.;
float thick = 1;
float M = 2;
float stiff = 100;

float xpos = nx/2.;
float ypos = ny/4;
PVector align = new PVector(0, 1);
PVector gravity = new PVector (0,5);

float t=0;
float dt;

FlexibleSheet sheet;
FlexiCollision collider;

void setup() {
  
  //size(1080, 600);
  size(600, 600);
  //view = new Window(nx, ny);
  view = new Window( 1, 1, nx, ny, 0, 0, width, height);
  
  sheet = new FlexibleSheet(L, thick, M, stiff, xpos, ypos, align, view);
  
  sheet.cpoints[0].makeFixed(); // pinning leading point
  sheet.Calculate_Stretched_Positions(gravity);
  
  dt = sheet.dtmax;
  
  collider = new FlexiCollision( sheet );
  
} // end of setup


void draw() {
  background(185);
  float x0, y0;
  y0 = sheet.cpoints[0].position.y;
  x0 = sheet.cpoints[0].position.x + 0.003*sin(2*PI*t/2);
  sheet.cpoints[0].UpdatePosition(x0,y0);
  
  sheet.update( dt, gravity );
  sheet.update2( dt, gravity );
  
  //collider.HandleCollisions();
  
  sheet.display();
  
  t += dt;
  //noLoop();
}