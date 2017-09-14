//==================== Collisions Class ==================//

//*** Depends on Window, ControlPoint, Spring and FlexibleSheet classes ***//

class Collisions {
  
  //================ Attributes ================//
  Window myView;
  int Ncp, Nsp;
  
  ArrayList<ControlPoint> ListMass = new ArrayList<ControlPoint>();
  ArrayList<Spring> ListSpring = new ArrayList<Spring>();
  
  ControlPoint [] LocalPoints;
  Spring [] LocalSprings;
  
  ArrayList<ControlPoint> NBoundPointCol; // For point-boundary collisions
  ArrayList<ControlPoint> SBoundPointCol; // For point-boundary collisions
  ArrayList<ControlPoint> WBoundPointCol; // For point-boundary collisions
  ArrayList<ControlPoint> EBoundPointCol; // For point-boundary collisions
  
  ArrayList<ControlPoint> PointACol; // For point-point collisions
  ArrayList<ControlPoint> PointBCol; // For point-point collisions
    
  
  Collisions(FlexibleSheet sheet_, Window view_) { // single Sheet
    
    myView = view_;
    Ncp = sheet_.numOfpoints;
    Nsp = sheet_.numOfsprings;
    
    LocalPoints = new ControlPoint[Ncp];
    LocalSprings = new Spring[Nsp];
    
    LocalPoints = sheet_.cpoints;
    LocalSprings = sheet_.springs;
    
    NBoundPointCol = new ArrayList<ControlPoint>(); // North Bound collision
    SBoundPointCol = new ArrayList<ControlPoint>(); // South Bound collision
    WBoundPointCol = new ArrayList<ControlPoint>(); // West Bound collision
    EBoundPointCol = new ArrayList<ControlPoint>(); // East Bound collision
    
    PointACol = new ArrayList<ControlPoint>();
    PointBCol = new ArrayList<ControlPoint>();
        
  } // end of constructor #1
  
  //======================== Methods ===========================//
  
  // Detect Boundary Collisions
  boolean DetectBoundaryCollision() {
    float clearRad;
    int col_count = 0;
    boolean out = false;
    
    for (ControlPoint P : LocalPoints) {
      
      clearRad = P.thick/2;
      
      if (P.position.x < clearRad) {
        col_count += 1;
        WBoundPointCol.add(P);
      }
      else if (P.position.x > myView.x.inE - clearRad) {
        col_count += 1;
        EBoundPointCol.add(P);
      }
      if (P.position.y < clearRad) {
        col_count += 1;
        NBoundPointCol.add(P);
      }
      else if  (P.position.y > myView.y.inE - clearRad) {
        col_count += 1;
        SBoundPointCol.add(P);
      }
    } // end for loop over particles
    if (col_count>0) out = true;
    
    return out;
  } // end of Detect Boundary Collisions
  
  // Resolve Collisions with Boundaries
  void ResolveBoundary( float e ) {
    int NBP = NBoundPointCol.size();
    int SBP = SBoundPointCol.size();
    int WBP = WBoundPointCol.size();
    int EBP = EBoundPointCol.size();
    
    if (NBP>0) {
      // Resolve north bound
      for (int j = 0; j<NBP; j++) {
        ControlPoint myP = NBoundPointCol.get(j);
        myP.UpdatePosition(myP.position.x, myP.thick/2);
        myP.UpdateVelocity(myP.velocity.x, -e*myP.velocity.y);
      }
      NBoundPointCol = new ArrayList<ControlPoint>();
    }
    if (SBP>0) {
      // Resolve south bound
      for (int j = 0; j<SBP; j++) {
        ControlPoint myP = SBoundPointCol.get(j);
        myP.UpdatePosition(myP.position.x, myView.y.inE-myP.thick/2);
        myP.UpdateVelocity(myP.velocity.x, -e*myP.velocity.y);
      }
      SBoundPointCol = new ArrayList<ControlPoint>();
    }
    if (WBP>0) {
      // Resolve west bound
      for (int j = 0; j<WBP; j++) {
        ControlPoint myP = WBoundPointCol.get(j);
        myP.UpdatePosition(myP.thick/2, myP.position.y);
        myP.UpdateVelocity(-e*myP.velocity.x, myP.velocity.y);
      }
      WBoundPointCol = new ArrayList<ControlPoint>();
    }
    if (EBP>0) {
      // Resolve east bound
      for (int j = 0; j<EBP; j++) {
        ControlPoint myP = EBoundPointCol.get(j);
        myP.UpdatePosition(myView.x.inE-myP.thick/2, myP.position.y);
        myP.UpdateVelocity(-e*myP.velocity.x, myP.velocity.y);
      }
      EBoundPointCol = new ArrayList<ControlPoint>();
    }
    
  } // end of ResolveBoundary method
  
  // Detect Particle-Particle Collisions
  boolean DetectPointPointCollision() {
    float clearRad;
    int col_count = 0;
    boolean out = false;
    
    for (int i = 0; i < Ncp-1; i++) {
      ControlPoint pi = LocalPoints[i];
      
      for (int j = i+1; j < Ncp; j++) {
        ControlPoint pj = LocalPoints[j];
        
        clearRad = (pi.thick/2 + pj.thick/2)/4;
        
        if (pi.position.dist(pj.position)<=clearRad) {
          col_count += 1;
          PointACol.add(pi);
          PointBCol.add(pj);
        }
      } // end for loop over particles #2
    } // end for loop over particles #1
    
    if (col_count>0) out = true;
    
    return out;
  } // end of Detect Point-Point Collisions
  
  // Detect Particle-Particle Collisions
  boolean DetectCPointCPointCollision() {
    float clearRad;
    float dtx, dty;
    int col_count = 0;
    boolean out = false;
    
    for (int i = 0; i < Ncp-1; i++) {
      ControlPoint pi = LocalPoints[i];
      
      for (int j = i+1; j < Ncp; j++) {
        ControlPoint pj = LocalPoints[j];
        
        clearRad = (pi.thick/2 + pj.thick/2)/4;
        
        dtx = (pi.position.x+pj.positionOld.x-pi.positionOld.x-pj.position.x)/(pj.positionOld.x-pi.positionOld.x);
        dty = (pi.position.y+pj.positionOld.y-pi.positionOld.y-pj.position.y)/(pj.positionOld.y-pi.positionOld.y);
        
        if ((dtx>0) && (dtx<1)) {
          if ((dty>0) && (dty<1)) {
            col_count += 1;
            PointACol.add(pi);
            PointBCol.add(pj);
            pi.impDisplay();
            pj.impDisplay();
            noLoop();
          }
        }
      } // end for loop over particles #2
    } // end for loop over particles #1
    
    if (col_count>0) out = true;
    
    return out;
  } // end of Detect Point-Point Collisions
  
  // Resolve Collisions occuring between points
  void ResolvePointPoint( float dt ) {
    int Npp = PointACol.size();
    
    if (Npp>0) {
      // resolve point-point
      for (int j = 0; j<Npp; j++) {
        ControlPoint pi = PointACol.get(j);
        ControlPoint pj = PointBCol.get(j);
        float piMass = pi.mass;
        float pjMass = pj.mass;
        
        float xinew = pi.positionOld.x + dt*(pi.position.x-pi.positionOld.x);
        float yinew = pi.positionOld.y + dt*(pi.position.y-pi.positionOld.y);
        float Vxi = (pi.velocity.x*(piMass-pjMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pj.velocity.x;
        float Vyi = (pi.velocity.y*(piMass-pjMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pj.velocity.y;

        float xjnew = pj.positionOld.x + dt*(pj.position.x-pj.positionOld.x);
        float yjnew = pj.positionOld.y + dt*(pj.position.y-pj.positionOld.y);
        float Vxj = (pj.velocity.x*(pjMass-piMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pi.velocity.x;
        float Vyj = (pj.velocity.y*(pjMass-piMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pi.velocity.y;
        
        if ((!pi.fixed) && (!pj.fixed)) {
          pi.UpdatePosition(xinew,yinew); pi.UpdateVelocity(Vxi,Vyi);
          pj.UpdatePosition(xjnew,yjnew); pj.UpdateVelocity(Vxj,Vyj);
        }
        else if (!pi.fixed) { pi.UpdatePosition(xinew,yinew); pi.UpdateVelocity(Vxi,Vyi); }
        else if (!pj.fixed) { pj.UpdatePosition(xjnew,yjnew); pj.UpdateVelocity(Vxj,Vyj); }
        
        //pi.impDisplay();
        //pj.impDisplay();
        //noLoop();
        
      }
      PointACol = new ArrayList<ControlPoint>();
      PointBCol = new ArrayList<ControlPoint>();
    }
    
  } // end ResolvePointPoint method
  
  
  // Master Method
  void SolveCollisions() {
    boolean pointBoundflag, pointPointflag;
    
    pointBoundflag = DetectBoundaryCollision();
    pointPointflag = DetectCPointCPointCollision();
    
    if (pointBoundflag) ResolveBoundary( 0.08 );
    if (pointPointflag) ResolvePointPoint( 0.2 );
  }// end of SolveCollisions method
  
}