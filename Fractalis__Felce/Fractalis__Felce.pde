int          n = 4;
int          m = n; //#Attrattori attivi
float sizeRate = .5;
int      steps = 1000000;
//L'array per la probabilità pesata
int[]     vecP = new int[100];

float[][]    M1 = new float[2][2];
float[]      V1 = new float[2];
float        P1;

float[][]    M2 = new float[2][2];
float[]      V2 = new float[2];
float        P2;

float[][]    M3 = new float[2][2];
float[]      V3 = new float[2];
float        P3;

float[][]    M4 = new float[2][2];
float[]      V4 = new float[2];
float        P4;

PrintWriter output;

void initFern(){
  M1[0][0] = 0.;
  M1[0][1] = 0.;
  M1[1][0] = 0.;
  M1[1][1] = 0.16;
  V1[0]    = 0.;
  V1[1]    = 0.;
  P1       = 0.01;
  
  M2[0][0] = 0.85;
  M2[0][1] = 0.04;
  M2[1][0] = -0.04;
  M2[1][1] = 0.85;
  V2[0]    = 0.;
  V2[1]    = 1.60;
  P2       = 0.85;
  
  M3[0][0] = 0.2;
  M3[0][1] = -0.26;
  M3[1][0] = 0.23;
  M3[1][1] = 0.22;
  V3[0]    = 0.;
  V3[1]    = 1.60;
  P3       = 0.07;
  
  M4[0][0] = -0.15;
  M4[0][1] = 0.28;
  M4[1][0] = 0.26;
  M4[1][1] = 0.24;
  V4[0]    = 0.;
  V4[1]    = 0.44;
  P4       = 0.07;
  
  for(int i=0; i<vecP.length; ++i){
    if(i<floor(P1*100)){
      vecP[i] = 0;
    }else if(i<floor((P1+P2)*100)){
      vecP[i] = 1;
    }else if(i<floor((P1+P2+P3)*100)){
      vecP[i] = 2;
    }else{
      vecP[i] = 3;
    }
  }
}
int          W = 500;
int          H = 700;
void setup() {
  //Non posso usare H e W dentro size, non ha senso, però vabbè
  size(500, 700);
  stroke(0, 100, 200, 255);
  background(255);
  initFern();
  run();
}

void draw() {
}

void run() {
  PVector min = new PVector(W, H);
  PVector max = new PVector(0, 0);
  PVector zoom = new PVector(20, 20);
  PVector shift = new PVector(W/2, H/2);
  PVector p = new PVector(0, 0);
  float[][] points = new float[steps][2];
  int sel;
  float[][] M = new float[2][2];  
  float[] V = new float[2];
  for (int i = 0; i<steps; ++i){
    sel = vecP[(int)(random(0, 100))];
    switch(sel){
      case 0: M=M1; V=V1; break;
      case 1: M=M2; V=V2; break;
      case 2: M=M3; V=V3; break;
      case 3: M=M4; V=V4; break;
    }
    p.x = p.x*M[0][0] + p.y*M[0][1] + V[0];
    p.y = p.x*M[1][0] + p.y*M[1][1] + V[1];
    points[i][0] = p.x;
    points[i][1] = p.y;
    if (p.x<min.x) min.x = p.x;
    if (p.x>max.x) max.x = p.x;
    if (p.y<min.y) min.y = p.y;
    if (p.y>max.y) max.y = p.y;
  }
  shift.x = -min.x;
  shift.y = -min.y;
  zoom.x = W/(max.x-min.x);
  zoom.y = H/(max.y-min.y);
  //Qui fa il disegno
  for(int i=0; i < steps; ++i){
    stroke(36, 130, 51);
    point((points[i][0]+shift.x)*zoom.x, (points[i][1]+shift.y)*zoom.y);
  }
}

//Ho tolto tutte le if e usato uno switch , spero sia chiaro
void keyPressed() {
  switch (Character.toLowerCase(key)) {
  case 'i':
    println("Saving Frame");
    saveFrame("frames/frame-####.png");
    break;

  default:
    setup();
    run();
    break;
  }
}
