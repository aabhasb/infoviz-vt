Table table;
int noOfBins = 35;
float colMin, colMax, kdeMin, kdeMax, difference, binSize;
float[] col, kdeValues;
int[] bins = new int[noOfBins];
int binWidth;

void setup() {
  table = loadTable("events-100K.csv");
  println(table.getRowCount());
  col = table.getFloatColumn(0);
  colMin = min(col);
  colMax = max(col);
  difference = colMax - colMin;
  binSize = difference / noOfBins;
  for (int i = 0; i < bins.length; i++) {
    bins[i] = 0;
  }
  for (int i = 0; i < col.length; i++) {
    for (int j = 0; j < noOfBins; j++) {
      if (col[i] <= colMin + (binSize * (j + 1))) {
        bins[j]++;
        break;
      }
    }
  }
  binWidth = width / noOfBins - 10;
  kdeValues = getKDEValues(col);
  kdeMin = min(kdeValues);
  kdeMax = max(kdeValues);
  size(920, 600);
  noLoop();
}

float[] getKDEValues(float[] inputs) {
  int inputsLength = inputs.length;
  float[] outputs = new float[inputsLength];
  for (int i = 0; i < inputsLength; i++) {
    println("Processing #" + (i + 1) + " of " + inputsLength);
    float value = inputs[i];
    float res = 0.0;
    for (float j: inputs) {
      float diff = value - j;
      res += Math.exp( - (diff * diff) / 1.0);
    }
    outputs[i] = res;
  }
  return outputs;
}

void invertYAxis() {
  translate(0, height - 1);
  scale(1,-1);
}

void draw() {
  invertYAxis();
  background(0);
  for (int i = 0; i < noOfBins; i++) {
    rect(i * (binWidth + 10) + 5, 300, binWidth, map(bins[i], min(bins), max(bins), 2, 300 - 20));
  }
  
  fill(255, 255, 0);
  beginShape();
  for (int i = 0; i < kdeValues.length; i++) {
    float x = map(i, 0, kdeValues.length - 1, 0, width);
    float y = map(kdeValues[i], kdeMin, kdeMax, 10, 290);
    stroke(i);
    curveVertex(x, y);
  }
  endShape();
}