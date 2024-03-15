//Youngwook Kang
class Edge {
  float x, dx, yMax;
  float r, g, b;      
  float dr, dg, db;  

  Edge(float x, float dx, float yMax, color startColor, color endColor, float height) {
    this.x = x;
    this.dx = dx;
    this.yMax = yMax;

    // Calculate initial color and color change per scanline based on start and end colors.
    this.r = red(startColor);
    this.g = green(startColor);
    this.b = blue(startColor);
    this.dr = (red(endColor) - this.r) / height;
    this.dg = (green(endColor) - this.g) / height;
    this.db = (blue(endColor) - this.b) / height;
  }

  void step() {
    x += dx;
    r += dr;
    g += dg;
    b += db;
  }
}

class Vertex extends PVector {
  color col;

  Vertex(float x, float y, float z, color c) {
    super(x, y, z);
    this.col = c;
  }
}
void rasterizeTriangle(Vertex v1, Vertex v2, Vertex v3) {
  // Sort vertices by y-values to determine top, middle, and bottom vertices.
  Vertex[] vertices = {v1, v2, v3};
  sortVerticesByY(vertices);
  Vertex bottom = vertices[0];
  Vertex middle = vertices[1];
  Vertex top = vertices[2];

  Edge bottomToLeft = new Edge(bottom.x, -0.5, middle.y, bottom.col, middle.col, middle.y - bottom.y);
  Edge bottomToRight = new Edge(bottom.x, 0.5, top.y, bottom.col, top.col, top.y - bottom.y);
  for (float y = bottom.y; y <= middle.y; y++) {
    drawScanLine(y, bottomToLeft, bottomToRight);
    bottomToLeft.step();
    bottomToRight.step();
  }

}

void drawScanLine(float y, Edge edge1, Edge edge2) {
  for (float x = edge1.x; x <= edge2.x; x++) {
    float alpha = (x - edge1.x) / (edge2.x - edge1.x);
    color interpolatedColor = lerpColor(color(edge1.r, edge1.g, edge1.b), color(edge2.r, edge2.g, edge2.b), alpha);
    // Invert the y-coordinate
    set((int)x, (int)(height - y), interpolatedColor);  
  }
}


// Dummy routines for drawing commands.
// These are for you to write.
ArrayList<Vertex> vertexList = new ArrayList<Vertex>();
ArrayList<Integer> colorList = new ArrayList<Integer>();
color currentColor;

// Set the color for drawing
void Set_Color (float r, float g, float b) {
  currentColor = color(r * 255, g * 255, b * 255);  
  colorList.add(currentColor);
}

// Add a vertex to the list
void Vertex(float x, float y, float z) {
  vertexList.add(new Vertex(x, y, z, currentColor));
}

// Begin recording vertices for a shape
void Begin_Shape() {
  vertexList.clear();
}

// Draw the shape once we have all the vertices
void End_Shape() {
  if (colorList.size() == 1) {
    // Only for key = 1, 2, 3, 4, 5, 6, 7
      fill(currentColor);
  
    if (vertexList.size() == 3) {  
      PVector v1 = vertexList.get(0);
      PVector v2 = vertexList.get(1);
      PVector v3 = vertexList.get(2);
    
      triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);  
    } 
  } else {
    // Only for key = 8, 9
    if (vertexList.size() == 3) { 
      Vertex v1 = vertexList.get(0);
      Vertex v2 = vertexList.get(1);
      Vertex v3 = vertexList.get(2);
      rasterizeTriangle(v1, v2, v3);
    }
  
  }

  vertexList.clear();
  colorList.clear();
}

void sortVerticesByY(Vertex[] vertices) {
  if (vertices[0].y > vertices[1].y) {
    swap(vertices, 0, 1);
  }
  if (vertices[1].y > vertices[2].y) {
    swap(vertices, 1, 2);
  }
  if (vertices[0].y > vertices[1].y) {
    swap(vertices, 0, 1);
  }
}

void swap(Vertex[] arr, int i, int j) {
  Vertex temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}
