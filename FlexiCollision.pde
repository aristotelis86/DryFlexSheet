class FlexiCollision {
  ArrayList<ControlPoint> colCpoints = new ArrayList<ControlPoint>();
  ArrayList<Spring> colSprings = new ArrayList<Spring>();
  int Nfs;
  
  FlexiCollision( FlexibleSheet fs ) {
    Nfs = 1;
    
    for (int i=0; i<fs.numOfpoints; i++) {
      colCpoints.add(fs.cpoints[i]);
    }
    for (int i=0; i<fs.numOfsprings; i++) {
      colSprings.add(fs.springs[i]);
    }
  }
  FlexiCollision( FlexibleSheet [] fs ) {
    Nfs = fs.length;
    
    for (int i=0; i<Nfs; i++) {
      for (int j=0; j<fs[i].numOfpoints; j++) {
        colCpoints.add(fs[i].cpoints[j]);
      }
      for (int j=0; j<fs[i].numOfsprings; j++) {
        colSprings.add(fs[i].springs[j]);
      }
    }
  }
  
  void HandleCollisions() {
    int Ncp = colCpoints.size();
    int Nsp = colSprings.size();
    ControlPoint myCp, myCpi, myCpj;
    
    // Boundary Collision
    for (int j=0; j<Ncp; j++) {
      myCp = colCpoints.get(j);
      myCp.BoundCollision( 0.8 );
    }
    // Point-Point Collision
    for (int i=0; i<Ncp-1; i++) {
      for (int j=i+1; j<Ncp; j++) {
        myCpi = colCpoints.get(i);
        myCpj = colCpoints.get(j);
        
        myCpi.CPointCPointCollision( myCpj );
        myCpi.FastCPointCPointCollision(myCpj);
      }
    }
    // Point-Spring Collision
    for (int i=0; i<Ncp; i++) {
      myCp = colCpoints.get(i);
      
      for (int j=0; j<Nsp; j++) {
        Spring mySpring = colSprings.get(j);
        ControlPoint myCp1 = mySpring.p1;
        ControlPoint myCp2 = mySpring.p2;
        
        if ((myCp!=myCp1) && (myCp!=myCp2)) {
          myCp.LineSweepsPoint( mySpring );
        }
      }
    }
  }
  
} // end of FlexiCollision class