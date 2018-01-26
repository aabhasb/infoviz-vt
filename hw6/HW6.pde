// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 1000000;  // a big number
int divisor = 100;
int detailLevel = 10000;
// ADD A ZERO TO ALL THREE DATA PARAMETERS TO INCREASE AMOUNT OF DATA

float[] data = new float[maxI];
float[] dataReduced = new float[maxI / divisor];
float[] pointsX = new float[maxI];
float[] pointsY = new float[maxI];
float[] pointsXReduced = new float[maxI / divisor];
float[] pointsYReduced = new float[maxI / divisor];
float minD, maxD;

int windowWidth = 1000, windowHeight = 700, mainGraphHeight = 500;

void setup() {
  size(1000, 700);
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  int sum = 0;
  for (int i=1, j = 0; i<maxI; i++) {
    data[i] = data[i-1] + random(-1.0, 1.0);
    if (i % divisor == 0) {
      dataReduced[j] = sum / divisor;
      sum = 0;
      j++;
    } else {
      sum += data[i];
    }
  }
  minD = min(data);
  maxD = max(data);
  for (int i = 0, j = 0; i < maxI; i++) {
    if (i % divisor == 0) {
      float xReduced = map(j, 0, maxI / divisor - 1, 0, width-1);
      float yReduced = map(dataReduced[j], minD, maxD, mainGraphHeight-1, 0.0);
      pointsXReduced[j] = xReduced;
      pointsYReduced[j] = yReduced;
      j++;
    }
    float x = map(i, 0, maxI - 1, 0, width-1);
    float y = map(data[i], minD, maxD, mainGraphHeight-1, 0.0);
    pointsX[i] = x;
    pointsY[i] = y;
  }
  cursor(HAND);
  //noLoop();
}

void draw() {
  background(255);
  // very simple timeseries visualization, VERY slow
  stroke(0, 0, 51);
  for (int i=0; i<maxI / divisor; i++) {
    point(pointsXReduced[i], pointsYReduced[i]);
  }
  stroke(255, 0, 0);
  int x = (int) map(mouseX, 0, width, 0, maxI);
  int j = 0;
  float[] pointsXZoomed = new float[maxI];
  float[] pointsYZoomed = new float[maxI];
  for (int i = x - detailLevel; i < x + detailLevel; i++) {
    if (i >= 0 && i < maxI) {
      point(pointsX[i], pointsY[i]);
      pointsXZoomed[j] = map(j, 0, detailLevel * 2, width / 2 - 100, width - 50);
      pointsYZoomed[j] = map(data[i], minD, maxD, windowHeight - 50, mainGraphHeight + 50);
    }
    j++;
  }
  stroke(0);
  line(0, mainGraphHeight, width, mainGraphHeight);
  line(width / 2 - 100, mainGraphHeight + 50, width - 50, mainGraphHeight + 50);
  line(width / 2 - 100, mainGraphHeight + 50, width / 2 - 100, windowHeight - 50);
  line(width / 2 - 100, windowHeight - 50, width - 50, windowHeight - 50);
  line(width - 50, mainGraphHeight + 50, width - 50, windowHeight - 50);
  stroke(139,69,19);
  for (int i = 0; i < j; i++) {
    if (i >= 0 && i < maxI) {
      point(pointsXZoomed[i], pointsYZoomed[i]);
    }
  }
  fill(50, 50, 50);
  text("Highlighted Values Index Range: " + max((x - detailLevel), 0) + " - " + min(maxI, (x + detailLevel)), 50, windowHeight - 100);
  text(maxD, width / 2 - 100, mainGraphHeight + 40);
  text(minD, width / 2 - 100, windowHeight - 30);
  
}