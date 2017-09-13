//==================== Collisions Class ==================//

//*** Depends on Window, ControlPoint, Spring and FlexibleSheet classes ***//

class Collisions {
  
  //================ Attributes ================//
  Window myView;
  int Ncp, Nsp;
  
  ArrayList<ControlPoint> ListMass = new ArrayList<ControlPoint>();
  ArrayList<Spring> ListSpring = new ArrayList<Spring>();
  
  ControlPoint [] LocalMass;
  Spring [] LocalSpring;
  
  ArrayList<ControlPoint> NBoundPointCol; // For point-boundary collisions
  ArrayList<ControlPoint> SBoundPointCol; // For point-boundary collisions
  ArrayList<ControlPoint> WBoundPointCol; // For point-boundary collisions
  ArrayList<ControlPoint> EBoundPointCol; // For point-boundary collisions
  
  
  
}