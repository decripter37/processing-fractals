\int          n = 4;
int          m = n; //#Attrattori attivi
float        r = kiss(n); 
PVector[]    a = new PVector[n];
PVector      p = new PVector(width/2, height/2);
float sizeRate = .5;
int      steps = 100000;
int          H = 500;
int          W = 500;
int[][]      d = new int[H][W];
float    theta = 0.*PI/180.;
float[][]    M = new float[2][2];

PrintWriter output;

void initMatrix(){
  M[0][0] =  r*cos(theta);
  M[0][1] = -r*sin(theta);
  M[1][0] =  r*sin(theta);
  M[1][1] =  r*cos(theta);
}

void setup() {
  //Non posso usare H e W dentro size, non ha senso, però vabbè
  size(500, 500);
  stroke(0, 100, 200, 255);
  background(255);
  
  initMatrix();
  
  println(r);
  attractors();
  run();
}

float kiss(int n){
  float c=0;
  for(int k = 0; k<=floor(n/4.); ++k){
    c += cos(2.*PI*k/n);
  }
  return 1-1/(2*c);
}

void fillOutput() {
  String row = new String();
  output = createWriter("fractal.csv");
  for (int i=0; i<H; ++i) {
    row = "";
    for (int j=0; j<(W-1); ++j) {
      row += d[i][j] + ", ";
    }
    row += d[i][W-1];
    output.println(row);
  }
  output.flush();
  output.close();
}

void calculateDensity() {
  float sum;
  r = 0.65;
  int t = 1000;
  float dr = 0.02/t;
  println("DENSITY START");
  output = createWriter("n"+n+"_t"+t+".csv");
  for (int k=0; k<t; ++k) {
    sum=0.0;
    for (int i=0; i<H; ++i) {
      for (int j=0; j<W; ++j) {
        sum += d[i][j];
      }
    }
    output.println(r + ", " + sum);
    println(r);
    r+=dr;
    run();
  }
  output.flush();
  output.close();
  println("DENSITY STOP");
}

void draw() {
}

void run() {
  int sel;
  int[] col;
  for (int i = 0; i < steps; i ++) {
    sel = (int)(random(0, m));
    p.x = p.x + M[0][0]*(a[sel].x - p.x) + M[0][1]*(a[sel].y - p.y);
    p.y = p.y + M[1][0]*(a[sel].x - p.x) + M[1][1]*(a[sel].y - p.y);
    if ((p.x<W) && (p.y<H) && (p.x>0) && (p.y>0)) {
      d[floor(p.y)][floor(p.x)] = 1;
    }
    col = selToRgb(sel);
    //stroke(col[0], col[1], col[2], 255);
    stroke(130, 36, 51);
    point(p.x, p.y);
  }
}

//Questa funzione ritorna un vettore int[3] con un colore diverso per ogni vertice scelto da sel
//Ho preferito non usare librerie esterne, sono così fiero di questo mio algoritmo! XD
int[] selToRgb(int sel) {
  float h = (sel * 6)/n;
  int[] col = {0, 0, 0};
  switch(floor(h)) {
  case 0:
    col[0] = 255; 
    col[1] = floor( h*255. ); 
    col[2] = 0;
    break;
  case 1:
    col[0] = floor( (2.-h)*255. ); 
    col[1] = 255; 
    col[2] = 0;
    break;
  case 2:
    col[0] = 0; 
    col[1] = 255; 
    col[2] = floor( (h-2.)*255. );
    break;
  case 3:
    col[0] = 0; 
    col[1] = floor( (4.-h)*255. ); 
    col[2] = 255;
    break;
  case 4:
    col[0] = floor( (h-4.)*255. ); 
    col[1] = 0; 
    col[2] = 255;
    break;
  case 5:
    col[0] = 255; 
    col[1] = 0; 
    col[2] = floor( (6.-h)*255. );
    break;
  }
  return col;
}

void attractors() {
  float x, y;
  float ray = min(height, width) * sizeRate;
  float d = TWO_PI/n;
  a = new PVector[n];
  for (int i = 0; i < n; i++) {
    x = width/2. + ray*cos(d*i);
    y = height/2. + ray*sin(d*i);
    //ellipse(x, y, 5, 5);
    a[i] = new PVector(x, y);
  }
}

//Attrattori in posizioni casuali per testare figure concave
//Naturalmente serve solo se n>4
void randomAttractors() {
  float x, y;
  a = new PVector[n];
  for (int i = 0; i < n; i++) {
    x = random(0, width);
    y = random(0, height);
    //ellipse(x, y, 5, 5);
    a[i] = new PVector(x, y);
  }
}

//Ho tolto tutte le if e usato uno switch , spero sia chiaro
void keyPressed() {
  float rr = 1;
  switch (Character.toLowerCase(key)) {
  case 'v':
  case 'c': 
    rr /= 10;
  case 'x': 
    rr /= 10;
  case 'z': 
    rr /= 10;
    r += rr;
    setup();
    break;
  case 'f':
  case 'd': 
    rr /= 10;
  case 's': 
    rr /= 10;
  case 'a': 
    rr /= 10;
    r -= rr;
    setup();
    break;

  case 'q':
    n -= 1;
    if (n<1) n=1;
    m = n;
    r = kiss(n); 
    println("New Fractal incoming", n);
    setup();
    break;
  case 'w':
    n += 1;
    m = n;
    r = kiss(n); 
    println("New Fractal incoming", n);
    setup();
    break;

  case 'e':
    m -= 1;
    if (m<1) m=1;
    setup();
    break;
  case 'r':
    m += 1;
    if (m>n) m=n;
    setup();
    break;

  case 'i':
    println("Saving Frame");
    saveFrame("frames/frame-####.png");
    break;

  case 'p':
    calculateDensity();
    break;

  case 'n':
    fillOutput();
    break; 

  default:
    setup();
    run();
    break;
  }
}