int W               = 50;
int H               = 50;
int steps           = 10000;
int branches        = 255; 
boolean[][] fractal = new boolean[H][W];
int minX            = 0;
int maxX            = 0;
int minY            = 0;
int maxY            = 0; 
void settings(){
  size(W, H);
}
void setup() {
  background(255);
  initFractal();
  run();
}

void initFractal() {
  for (int i=0; i<H; ++i) {
    for (int j=0; j<W; ++j) {
      fractal[i][j] = false;
    }
  }
  fractal[(int)H/2][(int)W/2] = true;
  minX = (int)W/2;
  maxX = (int)W/2;
  minY = (int)H/2;
  maxY = (int)H/2;
}

int getPbc(int n, int L) {
  int ret = n;
  ret = ret>L-1 ? ret-(L-1) : ret;
  ret = ret<0   ? ret+L-1   : ret;
  return ret;
}

boolean surrounded(PVector point, boolean[][] fractal) {
  if (fractal[getPbc((int)point.y-1, H)][(int)point.x]) {
    return true;
  }
  if (fractal[(int)point.y][getPbc((int)point.x+1, W)]) {
    return true;
  }
  if (fractal[getPbc((int)point.y+1, H)][(int)point.x]) {
    return true;
  }
  if (fractal[(int)point.y][getPbc((int)point.x-1, W)]) {
    return true;
  }
  return false;
}

void run() {
  PVector point = new PVector(0, 0);
  
  int k = 0;
  while (k<branches) {
    point = new PVector((int)(random(-maxX, minX)), (int)(random(-maxY, minY)));
    //println(point.x+" "+point.y);
    //stroke(36, 130, 51);
    //point(getPbc((int)point.x, W), getPbc((int)point.y, H));
    for(int i = 0; i<steps; ++i){
      int direction = (int)(random(0, 4));
      switch(direction){
        case 0: --point.y; break;
        case 1: ++point.x; break;
        case 2: ++point.y; break;
        case 3: --point.x; break;
      }
      point.x = getPbc((int)point.x, W);
      point.y = getPbc((int)point.y, H);
      
      if (surrounded(point, fractal)) {
        println((int)(k*100/branches)+"%");
        fractal[(int)point.y][(int)point.x] = true;
        minX = min(minX, (int)point.x);
        maxX = max(maxX, (int)point.x);
        minY = min(minY, (int)point.y);
        maxY = max(maxY, (int)point.y);
        ++k;
        break;
      }
    }
  }
  for (int i=0; i<H; ++i) {
    for (int j=0; j<W; ++j) {
      if (fractal[i][j]) {
        stroke(130, 36, 51);
        point(j, i);
        //ellipse(j, i, 10/log(j+1), 10/log(i+1));
      }
    }
  }
  saveFrame("frames/r="+W+"s="+branches+".png");
  println("frames/r="+W+"s="+branches+".png");
}

void keyPressed() {
  switch (Character.toLowerCase(key)) {
  case 'i':
    println("Saving Frame");
    saveFrame("frames/frame-####.png");
    break;

  default:
    setup();
    break;
  }
}