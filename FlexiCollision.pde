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
  
  
  
  
  
} // end of FlexiCollision class