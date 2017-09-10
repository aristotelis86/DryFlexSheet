class WriteInfo {
  
  PrintWriter outputPos; // output for positions
  PrintWriter outputVel; // output for velocities
  PrintWriter outputForce; // output for forces
  PrintWriter outputEnergy; // output for energy
  
  int Ncp, Nsg, Nfs; // number of lines to write per call
  ArrayList<ControlPoint> myCPoints = new ArrayList<ControlPoint>();
  ArrayList<Spring> mySprings = new ArrayList<Spring>();
  
  boolean posFlag = false;
  boolean velFlag = false;
  boolean forFlag = false;
  boolean eneFlag = false;
  
  //================= Constructor ====================//
  WriteInfo(ControlPoint cp) {
    Ncp = 1;
    myCPoints.add(cp);
    InitPositionOut(); posFlag = true;
    InitVelocityOut(); velFlag = true;
    InitForceOut(); forFlag = true;
  }
  
  WriteInfo(ControlPoint [] cp) {
    Ncp = cp.length;
    for (int i=0; i<Ncp; i++) { myCPoints.add(cp[i]); }
    InitPositionOut(); posFlag = true; InitPoints(outputPos);
    InitVelocityOut(); velFlag = true; InitPoints(outputVel);
    InitForceOut(); forFlag = true; InitPoints(outputForce);
  }
  
  WriteInfo(Spring sg) {
    Nsg = 1;
    mySprings.add(sg);
    InitEnergyOut(); eneFlag = true;
  }
  
  WriteInfo(Spring [] sg) {
    Nsg = sg.length;
    for (int i=0; i<Nsg; i++) { mySprings.add(sg[i]); }
    InitEnergyOut();  eneFlag = true;
  }
  
  WriteInfo(FlexibleSheet fs) {
    Nfs = 1;
    Ncp = fs.numOfpoints;
    Nsg = fs.numOfsprings;
    
    for (int i=0; i<Ncp; i++) { myCPoints.add(fs.cpoints[i]); }
    InitPositionOut(); posFlag = true;
    InitVelocityOut(); velFlag = true;
    InitForceOut(); forFlag = true;
    
    for (int i=0; i<Nsg; i++) { mySprings.add(fs.springs[i]); }
    InitEnergyOut();  eneFlag = true;
    
    InitSheetOut( fs );
  }
  
  //================= Methods ====================//
  void InitPositionOut() {
    outputPos = createWriter("./info/positions.txt");
    outputPos.println("=========== Positions ==========");
  }
  
  void InitVelocityOut() {
    outputVel = createWriter("./info/velocities.txt");
    outputVel.println("=========== Velocities ==========");
  }
  
  void InitForceOut() {
    outputForce = createWriter("./info/forces.txt");
    outputForce.println("=========== Forces ==========");
  }
  
  void InitEnergyOut() {
    outputEnergy = createWriter("./info/energy.txt");
    outputEnergy.println("=========== Energy ==========");
  }
  
  void InitSheetOut( FlexibleSheet fs ) {
    outputPos.println("Length: "+fs.Length+" Mass: "+fs.Mass+" Points: "+fs.numOfpoints+" Stiffness: "+fs.stiffness+" Damping: "+fs.damping+" dt: "+fs.dtmax);
    outputVel.println("Length: "+fs.Length+" Mass: "+fs.Mass+" Points: "+fs.numOfpoints+" Stiffness: "+fs.stiffness+" Damping: "+fs.damping+" dt: "+fs.dtmax);
    outputForce.println("Length: "+fs.Length+" Mass: "+fs.Mass+" Points: "+fs.numOfpoints+" Stiffness: "+fs.stiffness+" Damping: "+fs.damping+" dt: "+fs.dtmax);
    outputEnergy.println("Length: "+fs.Length+" Mass: "+fs.Mass+" Points: "+fs.numOfpoints+" Stiffness: "+fs.stiffness+" Damping: "+fs.damping+" dt: "+fs.dtmax);
  }
  
  void InitPoints( PrintWriter out ) {
    out.println("Points: "+Ncp);
  }
  
  
  void InfoCPoints() {
    outputPos.println("=============================");
    outputVel.println("=============================");
    outputForce.println("=============================");
    for (int i=0; i<Ncp; i++) {
      ControlPoint cp = myCPoints.get(i);
      outputPos.println(cp.position.x + " " + cp.position.y);
      outputVel.println(cp.velocity.x + " " + cp.velocity.y);
      outputForce.println(cp.force.x + " " + cp.force.y);
    }
  }
  
  void InfoCPoints( float t ) {
    outputPos.println("============= t = "+t+" ================");
    outputVel.println("============= t = "+t+" ================");
    outputForce.println("============= t = "+t+" ================");
    for (int i=0; i<Ncp; i++) {
      ControlPoint cp = myCPoints.get(i);
      outputPos.println(cp.position.x + " " + cp.position.y);
      outputVel.println(cp.velocity.x + " " + cp.velocity.y);
      outputForce.println(cp.force.x + " " + cp.force.y);
    }
  }
  
  void InfoSprings() {
    float EE;
    
    outputEnergy.println("=============================");
    for (int i=0; i<Nsg; i++) {
      Spring spr = mySprings.get(i);
      EE = .5 * spr.stiffness * spr.getStretch() * spr.getStretch();
      outputEnergy.println(EE);
    }
  }
  
  void InfoSprings( float t ) {
    float EE;
    
    outputEnergy.println("============= t = "+t+" ================");
    for (int i=0; i<Nsg; i++) {
      Spring spr = mySprings.get(i);
      EE = .5 * spr.stiffness * spr.getStretch() * spr.getStretch();
      outputEnergy.println(EE);
    }
  }
  
  void InfoSheet() {
    InfoCPoints();
    float EE = 0;
    
    outputEnergy.println("=============================");
    for (int i=0; i<Nsg; i++) {
      Spring spr = mySprings.get(i);
      EE += .5 * spr.stiffness * spr.getStretch() * spr.getStretch();
    }
    for (int i=0; i<Ncp; i++) {
      ControlPoint cpoi = myCPoints.get(i);
      EE += .5 * cpoi.mass * cpoi.velocity.mag() * cpoi.velocity.mag();
    }
    outputEnergy.println(EE);
  }
  
  void InfoSheet( float t ) {
    InfoCPoints( t );
    float EE = 0;
    
    outputEnergy.println("============= t = "+t+" ================");
    for (int i=0; i<Nsg; i++) {
      Spring spr = mySprings.get(i);
      EE += .5 * spr.stiffness * spr.getStretch() * spr.getStretch();
    }
    for (int i=0; i<Ncp; i++) {
      ControlPoint cpoi = myCPoints.get(i);
      EE += .5 * cpoi.mass * cpoi.velocity.mag() * cpoi.velocity.mag();
    }
    outputEnergy.println(EE);
  }
  
  void InfoSheet( float t, PVector g, float b ) {
    float gMag = g.mag();
    InfoCPoints( t );
    float EE = 0;
    
    outputEnergy.println("============= t = "+t+" ================");
    for (int i=0; i<Nsg; i++) {
      Spring spr = mySprings.get(i);
      EE += .5 * spr.stiffness * spr.getStretch() * spr.getStretch();
    }
    for (int i=0; i<Ncp; i++) {
      ControlPoint cpoi = myCPoints.get(i);
      EE += .5 * cpoi.mass * cpoi.velocity.mag() * cpoi.velocity.mag();
      EE += cpoi.mass * gMag * cpoi.position.dist(new PVector(0, b));
    }
    outputEnergy.println(EE);
  }
  void closeInfos() {
    if (posFlag) terminateFile(outputPos);
    if (velFlag) terminateFile(outputVel);
    if (forFlag) terminateFile(outputForce);
    if (eneFlag) terminateFile(outputEnergy);
  }
  
  void terminateFile(PrintWriter file) {
    file.flush(); // Writes the remaining data to the file
    file.close(); // Finishes the file
  }
 
}