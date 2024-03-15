// Sample code for starting the subdivision project
import java.util.Arrays;

// parameters used for object rotation by mouse
float mouseX_old = 0;
float mouseY_old = 0;
PMatrix3D rot_mat = new PMatrix3D();
boolean isMeshVisible, isGouraudShading;
int selectedVertex  = 0;
Mesh mesh;
// initialize stuff
void setup() {
  size (800, 800, OPENGL);
}

// Draw the scene
void draw() {
  
  background (170, 170, 255);
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
    
  // create an ambient light source
  ambientLight (52, 52, 52);
  
  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);
  
  pushMatrix();
  
  applyMatrix (rot_mat);  // rotate object using the global rotation matrix
  
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  if (!isGouraudShading) {
    stroke (0, 0, 0);
  } else {
    noStroke();
  }
  fill(200, 200, 200);

  // THIS IS WHERE YOU SHOULD DRAW THE MESH

  if (!isMeshVisible) {
    beginShape();
    normal(0.0, 0.0, 1.0);
    vertex(-1.0, -1.0, 0.0);
    vertex( 1.0, -1.0, 0.0);
    vertex( 1.0,  1.0, 0.0);
    vertex(-1.0,  1.0, 0.0);
    endShape(CLOSE);
  } else {
    // Draw each face
    for (int i = 0; i < mesh.faceIndices.size(); i += 3) {
      beginShape();
      fill(200, 200, 200);
      if (isGouraudShading) {
        for (int j = 0; j < 3; j++ ) {
          Vertex vertexNormal = mesh.normalsAtVertices[mesh.faceIndices.get(i + j)];
          normal(vertexNormal.x, vertexNormal.y, vertexNormal.z);
          Vertex vert = mesh.vertices.get(mesh.faceIndices.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      } else {
        Vertex faceNormal = mesh.normalsAtFaces.get(i / 3);
        normal(faceNormal.x, faceNormal.y, faceNormal.z);

        for (int j = 0; j < 3; j++) {
          Vertex vert = mesh.vertices.get(mesh.faceIndices.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      }
      
      endShape(CLOSE);
    }
  }
  if (isMeshVisible) {
    Vertex currentVertex = mesh.vertices.get(mesh.faceIndices.get(selectedVertex ));
    Vertex nextVertex = mesh.vertices.get(mesh.faceIndices.get(next(selectedVertex )));
    Vertex prevVertex = mesh.vertices.get(mesh.faceIndices.get(prev(selectedVertex )));
    float offsetFactor = 0.1;
    Vertex offset = new Vertex(
        currentVertex.x + (nextVertex.x - currentVertex.x) * offsetFactor + (prevVertex.x - currentVertex.x) * offsetFactor,
        currentVertex.y + (nextVertex.y - currentVertex.y) * offsetFactor + (prevVertex.y - currentVertex.y) * offsetFactor,
        currentVertex.z + (nextVertex.z - currentVertex.z) * offsetFactor + (prevVertex.z - currentVertex.z) * offsetFactor
    );
    translate(offset.x, offset.y, offset.z);
    fill(255, 0, 0);
    noStroke();
    sphere(0.03);
  }
  popMatrix();
}

class Mesh {
    ArrayList<Integer> faceIndices;
    ArrayList<Vertex> vertices;
    int[] oppositeCorners;
    Vertex[] normalsAtVertices;
    ArrayList<Vertex> normalsAtFaces;
    int totalVertices;
    int totalFaces;

    Mesh(int totalVertices, int totalFaces) {
        this.faceIndices = new ArrayList<Integer>();
        this.vertices = new ArrayList<Vertex>();
        this.oppositeCorners = new int[3 * totalFaces];
        this.normalsAtVertices = new Vertex[totalVertices];
        this.normalsAtFaces = new ArrayList<Vertex>();
        this.totalVertices = totalVertices;
        this.totalFaces = totalFaces;
    }

    int swing(int corner) {
        return next(oppositeCorners[next(corner)]);
    }

    void constructMesh() {
        for (int i = 0; i < faceIndices.size(); i++) {
            for (int j = 0; j < faceIndices.size(); j++) {
                if (faceIndices.get(next(i)).equals(faceIndices.get(prev(j))) && faceIndices.get(prev(i)).equals(faceIndices.get(next(j)))) {
                    oppositeCorners[i] = j;
                    oppositeCorners[j] = i;
                }
            }
        }

        for (int i = 0; i < faceIndices.size(); i += 3) {
            Vertex vertex1 = vertices.get(faceIndices.get(i));
            Vertex vertex2 = vertices.get(faceIndices.get(i + 1));
            Vertex vertex3 = vertices.get(faceIndices.get(i + 2));
            Vertex normal = vertex2.sub(vertex1).cross(vertex3.sub(vertex2)).norm();
            normalsAtFaces.add(normal);
        }

        boolean[] visited = new boolean[vertices.size()];
        for (int i = 0; i < faceIndices.size(); i++) {
            if (!visited[faceIndices.get(i)]) {
                Vertex normal = normalsAtFaces.get(i / 3);
                int swingCorner = swing(i);
                while (swingCorner != i) {
                    normal = normal.add(normalsAtFaces.get(swingCorner / 3));
                    swingCorner = swing(swingCorner);
                }
                normalsAtVertices[faceIndices.get(i)] = normal.norm();
                visited[faceIndices.get(i)] = true;
            }
        }
    }
}


void processEdges(Mesh originalMesh, ArrayList<Integer> newfaceIndices, ArrayList<Vertex> newvertices) {
    ArrayList<int[]> processedEdges = new ArrayList<int[]>();
    int[] intermediaryIndices = new int[3];
    int edgeVertex1 = 0;
    int edgeVertex2 = 0;
    
    for (int index = 0; index < originalMesh.faceIndices.size(); index++) {
        int currentVertex = originalMesh.faceIndices.get(index);
        int nextVertex = originalMesh.faceIndices.get(next(index));
        int previousVertex = originalMesh.faceIndices.get(prev(index));

        int[] edge1 = {currentVertex, nextVertex};
        Arrays.sort(edge1);

        int[] edge2 = {currentVertex, previousVertex};
        Arrays.sort(edge2);

        boolean foundEdge1 = false;
        boolean foundEdge2 = false;
        
        for (int[] processedEdge : processedEdges) {
            if (Arrays.equals(processedEdge, edge1)) {
                foundEdge1 = true;
            }
            if (Arrays.equals(processedEdge, edge2)) {
                foundEdge2 = true;
            }
        }

        Vertex leftNeighbor = originalMesh.vertices.get(previousVertex);
        Vertex rightNeighbor = originalMesh.vertices.get(originalMesh.faceIndices.get(originalMesh.oppositeCorners[prev(index)]));
        Vertex midpointVertex1 = calculateMidpointVertex(originalMesh, currentVertex, nextVertex, leftNeighbor, rightNeighbor);

        if (foundEdge1) {
            edgeVertex1 = findExistingVertex(newvertices, midpointVertex1);
        } else {
            processedEdges.add(edge1);
            edgeVertex1 = newvertices.size();
            newvertices.add(midpointVertex1);
        }

        leftNeighbor = originalMesh.vertices.get(nextVertex);
        rightNeighbor = originalMesh.vertices.get(originalMesh.faceIndices.get(originalMesh.oppositeCorners[next(index)]));
        Vertex midpointVertex2 = calculateMidpointVertex(originalMesh, currentVertex, previousVertex, leftNeighbor, rightNeighbor);

        if (foundEdge2){
            edgeVertex2 = findExistingVertex(newvertices, midpointVertex2);
        } else {      
            processedEdges.add(edge2);
            edgeVertex2 = newvertices.size();
            newvertices.add(midpointVertex2);
        }
        
        newfaceIndices.add(currentVertex);
        newfaceIndices.add(edgeVertex1);
        newfaceIndices.add(edgeVertex2);

        if (index % 3 == 0) {
            intermediaryIndices[0] = edgeVertex1;
        } else if (index % 3 == 1) {
            intermediaryIndices[1] = edgeVertex1;
        } else {
            newfaceIndices.add(intermediaryIndices[0]);
            newfaceIndices.add(intermediaryIndices[1]);
            newfaceIndices.add(edgeVertex1);
        }
    }
}

Vertex calculateMidpointVertex(Mesh mesh, int vertex1, int vertex2, Vertex leftNeighbor, Vertex rightNeighbor) {
    Vertex vertex1Pos = mesh.vertices.get(vertex1);
    Vertex vertex2Pos = mesh.vertices.get(vertex2);
    return vertex1Pos.add(vertex2Pos).mult(3.0 / 8.0).add(leftNeighbor.add(rightNeighbor).mult(1.0 / 8.0));
}

int findExistingVertex(ArrayList<Vertex> vertices, Vertex vertex) {
    for (int i = 0; i < vertices.size(); i++) {
        if (vertices.get(i).equals(vertex)) {
            return i;
        }
    }
    return -1;
}

Mesh subdivide(Mesh originalMesh) {
    ArrayList<Integer> updatedVertexIndices = new ArrayList<Integer>();
    ArrayList<Vertex> updatedVertices = new ArrayList<Vertex>();
    boolean[] processed = new boolean[originalMesh.vertices.size()];

    for (int i = 0; i < originalMesh.vertices.size(); i++) {
        ArrayList<Integer> adjacentVertices = new ArrayList<Integer>();

        if (!processed[i]) {
            for (int j = 0; j < originalMesh.faceIndices.size(); j++) {
                if (originalMesh.faceIndices.get(j) == i) {
                    adjacentVertices.add(originalMesh.faceIndices.get(next(j)));

                    int currentSwing = originalMesh.swing(j);
                    while (currentSwing != j) {
                        adjacentVertices.add(originalMesh.faceIndices.get(next(currentSwing)));
                        currentSwing = originalMesh.swing(currentSwing);
                    }
                }
            }
            processed[i] = true;
        }

        Vertex sumOfAdjacent = new Vertex(0.0, 0.0, 0.0);
        for (int adjacentIndex : adjacentVertices) {
            sumOfAdjacent = sumOfAdjacent.add(originalMesh.vertices.get(adjacentIndex));
        }

        float weight;
        if (adjacentVertices.size() == 3) {
            weight = 3.0 / 16.0;
        } else {
            weight = 3.0 / (8.0 * adjacentVertices.size());
        }

        updatedVertices.add(originalMesh.vertices.get(i).mult(1 - adjacentVertices.size() * weight).add(sumOfAdjacent.mult(weight)));
    }

    processEdges(originalMesh, updatedVertexIndices, updatedVertices);

    Mesh newSubdividedMesh = new Mesh(updatedVertices.size(), updatedVertexIndices.size() / 3);
    newSubdividedMesh.faceIndices = updatedVertexIndices;
    newSubdividedMesh.vertices= updatedVertices;
    newSubdividedMesh.constructMesh();

    return newSubdividedMesh;
}

class Vertex {
  float x, y, z;
  Vertex(float x, float y, float z) {
      this.x = x;
      this.y = y;
      this.z = z;
  }

  Vertex mult(float scale) {
      return new Vertex(x * scale, y * scale, z * scale);
  }

  Vertex add(Vertex other) {
      return new Vertex(this.x + other.x, this.y + other.y, this.z + other.z);
  }

  Vertex cross(Vertex other) {
      return new Vertex(
          this.y * other.z - this.z * other.y,
          this.z * other.x - this.x * other.z,
          this.x * other.y - this.y * other.x
      );
  }

  Vertex sub(Vertex other) {
      return new Vertex(this.x - other.x, this.y - other.y, this.z - other.z);
  }

  Vertex norm() {
      float mag = sqrt(x * x + y * y + z * z);
      return new Vertex(x / mag, y / mag, z / mag);
  }
  boolean equals(Vertex other) {
    return this.x == other.x && this.y == other.y && this.z == other.z;
  }
}

int next(int corner) {
  return corner / 3 * 3 + (corner + 1) % 3;
}

int prev(int corner) {
  return next(next(corner));
}


// handle keyboard input
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply", 1.5);
    isMeshVisible = true;
    selectedVertex  = 0;
  }
  else if (key == '2') {
    read_mesh ("octa.ply", 2.5);
    isMeshVisible = true;
    selectedVertex  = 0;
  }
  else if (key == '3') {
    read_mesh ("icos.ply", 2.5);
    isMeshVisible = true;
    selectedVertex  = 0;
  }
  else if (key == '4') {
    read_mesh ("star.ply", 1.0);
    isMeshVisible = true;
    selectedVertex  = 0;
  }
  else if (key == '5') {
    read_mesh ("torus.ply", 1.6);
    isMeshVisible = true;
    selectedVertex  = 0;
  }
  else if (key == 'n') {
    // next corner operation
    selectedVertex  = next(selectedVertex );
  }
  else if (key == 'p') {
    // previous corner operation
    selectedVertex  = prev(selectedVertex );
  }
  else if (key == 'o') {
    // opposite corner operation
    selectedVertex  = mesh.oppositeCorners[selectedVertex ];
  }
  else if (key == 's') {
    // swing corner operation
    selectedVertex  = mesh.swing(selectedVertex );
  }
  else if (key == 'f') {
    // flat shading, with black edges
    isGouraudShading = false;
  }
  else if (key == 'g') {
    // Gouraud shading with per-vertex normals
    isGouraudShading = true;
  }
  else if (key == 'd') {
    // subdivide mesh
    mesh = subdivide(mesh);
  }
  else if (key == 'q') {
    // quit program
    exit();
  }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename, float scale_value)
{
  String[] words;

  String lines[] = loadStrings(filename);

  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  println ("number of vertices = " + num_vertices);

  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  println ("number of faces = " + num_faces);
  mesh = new Mesh(num_vertices, num_faces);
  
  // read in the vertices
  for (int i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    float x = float(words[0]) * scale_value;
    float y = float(words[1]) * scale_value;
    float z = float(words[2]) * scale_value;
    println ("vertex = " + x + " " + y + " " + z);
    mesh.vertices.add(new Vertex(float(words[0]), float(words[1]), float(words[2])));
  }

  // read in the faces
  for (int i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }
    
    int index1 = int(words[1]);
    int index2 = int(words[2]);
    int index3 = int(words[3]);
    println ("face = " + index1 + " " + index2 + " " + index3);
    mesh.faceIndices.add(index1);
    mesh.faceIndices.add(index2);
    mesh.faceIndices.add(index3);
  }
  mesh.constructMesh();
}

// remember old mouse position
void mousePressed()
{
  mouseX_old = mouseX;
  mouseY_old = mouseY;
}

// modify rotation matrix when mouse is dragged
void mouseDragged()
{
  if (!mousePressed)
    return;
  
  float dx = mouseX - mouseX_old;
  float dy = mouseY - mouseY_old;
  dy *= -1;

  float len = sqrt (dx*dx + dy*dy);
  if (len == 0)
      len = 1;
  
  dx /= len;
  dy /= len;
  PMatrix3D rmat = new PMatrix3D();
  rmat.rotate (len * 0.005, dy, dx, 0);
  rot_mat.preApply (rmat);

  mouseX_old = mouseX;
  mouseY_old = mouseY;
}
