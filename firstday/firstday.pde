Table table;
int i = 0;
int incomeMin, incomeMax;
int popMin, popMax;
float collegeGradMin, collegeGradMax;

void setup() {
  println("hello world");
  size(500, 500);
  table = loadTable("states.csv", "header");
  println(table.getRowCount());
  incomeMin = min(table.getIntColumn("IncomeperCapita"));
  incomeMax = max(table.getIntColumn("IncomeperCapita"));
  collegeGradMin = min(table.getFloatColumn("CollegeGrad"));
  collegeGradMax = max(table.getFloatColumn("CollegeGrad"));
  popMin = min(table.getIntColumn("Population"));
  popMax = max(table.getIntColumn("Population"));
  noLoop();
}

void invertYAxis() {
  translate(0, height - 1);
  scale(1,-1);
}

void draw() {
  invertYAxis();
  background(0);
  //i++;
  fill(70, 130, 180, 200);
  //stroke(0, 255, 0);
  //ellipse(100, 500 - 50, 30, 30);
  //ellipse(mouseX, mouseY, 30, 30);
  for (TableRow r: table.rows()) {
    float s = map(r.getInt("Population"), popMin, popMax, 10, 50);
    ellipse(
      map(r.getInt("IncomeperCapita"), incomeMin, incomeMax, 10, 490),
      map(r.getFloat("CollegeGrad"), collegeGradMin, collegeGradMax, 10, 490),
      s,
      s
    );
  }
}