// CS5764 HW5 Treemap sample code.
// Make a tree structure out of a categorical csv data table.

import java.util.Arrays;

TreeNode root;
double totalSize = 0.0;
int infoBoxWidth = 200, infoBoxHeight = 100;
float changeMax = 100, changeMin = -100;
int[] GREENS = {#006400, #6B8E23, #7FFF00};
int[] REDS = {#FF0000, #B22222, #800000};

void setup(){
  root = new TreeNode("treemap-stocks.csv", 3, 5);
  //root = new TreeNode("treemap-counties.csv", 3, 4);
  println(root.size, root.children[0].size, root.children[0].children[0].size, 
    root.children[0].children[0].children[0].size);
  //root.slicemeup() ?
  traverse(root);
  println(root.children.length + "\n\n\n");
  size(1200, 650);
  //noLoop();
  preProcess(root, 0.0, 0.0, width, height);
}

void preProcess(TreeNode currentRoot, float currentLeft, float currentTop, float currentWidth, float currentHeight) {
  float left = currentLeft;
  float top = currentTop;
  int start = 0, end = 0;
  TreeNode[] nodes = currentRoot.children;
  if (nodes == null) {
    return;
  }
  for (int i = 0; i < nodes.length; i++) {
    end = i;
    TreeNode node = currentRoot.children[i];
    node.price = node.data.getFloatColumn("Price")[0];
    node.change = node.data.getFloatColumn("Change")[0];
    node.volume = node.data.getIntColumn("Volume")[0];
    node.symbol = node.data.getStringColumn("Symbol")[0];
    node.fullName = node.data.getStringColumn("Name")[0];
    float w = (node.size / currentRoot.size) * currentWidth;
    float h = currentHeight;
    node.rect = new Rect(left, top, w, h);
    if (start < end) {
      float rowWidth = 0.0;
      float colSizes = 0.0;
      for (int j = start; j <= end; j++) {
        TreeNode tn = nodes[j];
        rowWidth += (tn.size / currentRoot.size) * currentWidth;
        colSizes += tn.size;
      }
      TreeNode rowStart = nodes[start];
      float tempH = (rowStart.size / colSizes) * currentHeight;
      float tempAspectRatio = max(rowWidth / tempH, tempH / rowWidth);
      if (tempAspectRatio < rowStart.rect.getAspectRatio()) {
        float tempTop = currentTop;
        for (int j = start; j <= end; j++) {
          TreeNode tn = nodes[j];
          Rect r = tn.rect;
          r.left = rowStart.rect.left;
          r.top = tempTop;
          r.w = rowWidth;
          r.h = (tn.size / colSizes) * currentHeight;
          tempTop += r.h;
        }
        left = rowStart.rect.left + rowWidth;
      } else {
        if (i - 1 >= 0) {
          TreeNode tn = nodes[i - 1];
          Rect r = tn.rect;
          left += r.w;
        }
        start = end;
      }
    } else {
        left += w;
    }
  }
  
  for (int i = 0; i < nodes.length; i++) {
      TreeNode tn = nodes[i];
      Rect r = tn.rect;
      preProcess(tn, r.left, r.top + 22, r.w, r.h);
  }
}

void draw() {
  background(0);
  TreeNode tn = recursiveDraw(root, 0);
  drawInfoBox(tn);
  //root.drawme() ?
}

void drawInfoBox(TreeNode tn) {
  int left = mouseX + 5, top = mouseY + 5;
  if (mouseX + infoBoxWidth > width - 20) {
    left = mouseX - infoBoxWidth - 5;
  }
  if (mouseY + infoBoxHeight > height - 20) {
    top = mouseY - infoBoxHeight - 5;
  }
  rect(left, top, infoBoxWidth, infoBoxHeight);
  if (tn != null) {
    //println(tn.price);
    fill(0, 0, 255);
    text(tn.fullName + " (" + tn.symbol + ")", left, top + 4, infoBoxWidth, infoBoxHeight);
    textSize(16);
    text("Price: " + tn.price, left, top + 25, infoBoxWidth, infoBoxHeight);
    
    textSize(28);
    String changePercentage = tn.change + "%";
    if (tn.change > 0) {
      fill(0, 255, 0);
      changePercentage = "+" + changePercentage;
    } else if (tn.change < 0) {
      fill(255, 0, 0);
    } else {
      fill(80, 80, 80);
    }
    text(changePercentage, left, top + 55, infoBoxWidth, infoBoxHeight);
  }
}

TreeNode recursiveDraw(TreeNode currentRoot, int level) {
  TreeNode[] nodes = currentRoot.children;
  if (nodes == null) {
    return null;
  }
  TreeNode tnToReturn = null;
  for (int i = 0; i < nodes.length; i++) {
    TreeNode node = nodes[i];
    boolean isHovered = false;
    Rect r = node.rect;
    if (r == null)
      continue;
    if ((mouseX >= r.left) && (mouseX <= r.left + r.w) && (mouseY >= r.top) && (mouseY <= r.top + r.h)) {
      isHovered = true;
      if (level == 2) {
        tnToReturn = node;
      }
    }
    backgroundByLevel(level, isHovered, node.change);
    strokeWeight(3 - level);
    if (isHovered) {
      stroke(#FFD700);
    }
    rect(r.left, r.top, r.w, r.h);
    strokeWeight(1);
    stroke(0);
    
    textSize(10);
    textColorByLevel(level, isHovered);
    textAlign(CENTER);
    text(node.name, r.left + 5, r.top + 5, r.w - 10, r.h);
    TreeNode tnStack = recursiveDraw(node, level + 1);
    if ((level != 2) && (tnStack != null))
        tnToReturn = tnStack;
  }
  return tnToReturn;
}

void backgroundByLevel (int level, boolean isHovered, float change) {
  switch (level) {
    case 0:
      if (isHovered)
        fill(244, 164, 96);
      else
        fill(210, 105, 30);
      break;
    case 1:
      if (isHovered)
        fill(138,43,226);
      else
        fill(119,136,153);
      break;
    case 2:
      int colorIndex = 0;
      int hexColor = #555555;
      if (change > 0) {
        colorIndex = floor(map(change, changeMin, changeMax, 0, 2.99999));
        hexColor = GREENS[colorIndex];
      } else if (change < 0) {
        colorIndex = floor(map(change, changeMin, changeMax, 0, 2.99999));
        hexColor = REDS[colorIndex];
      }
      fill(hexColor);
      break;
  }
}

void textColorByLevel (int level, boolean isHovered) {
  switch (level) {
    case 0:
      if (isHovered)
        fill(20, 20, 20);
      else
        fill(240, 240, 240);
      break;
    case 1:
      fill(255, 255, 255);
      break;
    case 2:
      fill(255, 255, 255);
      break;
  }
}

void traverse(TreeNode node) {
  if (node == null)
    return;
  if (node.level > 1)
    return;
  //println(node.level + ". " + node.name);
  if (node.children == null) {
    return;
  }
  //println("Children: " + node.children.length + " " + node.size);
  Arrays.sort(node.children);
  for (int i = 0; i < node.children.length; i++) {
    traverse(node.children[i]);
  }
}


int numLevels=0, sizeColIdx=0;  // Data file parameters

public class Rect {
  public float left, top, w, h;
  public Rect(float l, float t, float wi, float hi) {
    left = l;
    top = t;
    w = wi;
    h = hi;
  }
  
  public float getAspectRatio () {
    return max(w/h, h/w);
  }
}

public class TreeNode implements Comparable<TreeNode> {
  public int level;          // my level in the tree, 0=root
  public String name;        // my name
  public Table data;         // table of data for all my leaf descendents
  public float size;         // my total size, computed from size data column
  public boolean isLeaf;     // am i a leaf?
  public TreeNode[] children;// my list of children nodes
  
  public Rect rect;
  public float price, change;
  public int volume;
  public String symbol, fullName;

  // Create a tree from csv file, 
  // with lvls number of categoral levels starting at column index 1
  // and using column index sz for the leaf node size data.
  // Uses recursion to build the tree.
  TreeNode(String file, int lvls, int sz) {  // other params needed ...?
    numLevels = lvls;
    sizeColIdx = sz;
    data = loadTable(file, "header"); 
    println(data.getRowCount(), data.getColumnCount()); 
    float[] changeColumn = data.getFloatColumn("Change");
    changeMin = min(changeColumn);
    changeMax = max(changeColumn);
    init(0, "Root", data);
  }
  TreeNode(int lev, String nm, Table d) {
    init(lev, nm, d);
  }
  public int compareTo(TreeNode n) {  //Comparable, useful for Arrays.sort(children)
    return size > n.size ? -1 : (size == n.size) ? 0 : 1;   // sort by name or some other attribute?
  }

  private void init(int lev, String nm, Table d) {
    level = lev;
    name = nm; 
    data = d;
    size = getSize();
    isLeaf = (level >= numLevels);
    //println("\n" + level + ". " + name);
    children = getChildrenList();
  }
  private float getSize() {  // compute size of this node from leaf data
    float sum=0.0;
    for (float e : data.getFloatColumn(sizeColIdx))
      sum += e;
    return(sum);
  }
  private String[] getChildrenNames() {  // find names of children of this node from next level column of data
    return(data.getUnique(level+1));
  }
  private Table getChildData(String childname) {  // filter data for a given child
    return(new Table(data.findRows(childname, level+1)));
  }
  private TreeNode[] getChildrenList() {  // setup a list of children
    if (isLeaf) return null;
    String[] childNames = getChildrenNames();
    TreeNode[] childs = new TreeNode[childNames.length];
    for (int i=0; i<childNames.length; i++) {
      childs[i] = new TreeNode(level+1, childNames[i], getChildData(childNames[i]));  // Recursion happens here.
      //print(childNames[i] + " ");
    }
    return childs;
  }
  
  // slicing, drawing, ...?
}