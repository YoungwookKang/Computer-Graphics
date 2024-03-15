//Youngwook Kang
// Routines for graphics commands (especially for shading and z-buffer).
// Most of these are for you to write.

ArrayList<PVector> vertices = new ArrayList<PVector>();
ArrayList<PVector> normals = new ArrayList<PVector>();
PVector lightDirection;
int vertexCount = 0;


PVector lightPos;
color lightColor;

color ambientColor;
color specularColor;


public enum Shading { WIREFRAME, CONSTANT, FLAT, GOURAUD, PHONG }
Shading shade = Shading.WIREFRAME;  

float[][] zBuffer;

PMatrix3D cmat;
PMatrix3D adj;
float materialR, materialG, materialB;

float field_of_view = 0.0;  


void Init_Scene() {
  
  cmat = new PMatrix3D();
  cmat.reset();           
    
  PMatrix3D imat = cmat.get(); 
  boolean okay = imat.invert();
  if (!okay) {
    println ("matrix singular, cannot invert");
    exit();
  }
  adj = imat.get();
  adj.transpose();
  
  // initialize your z-buffer here
  zBuffer = new float[width][height];
  for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
          zBuffer[i][j] = -Float.MAX_VALUE; // Use a large negative value
      }
  }
  // Default material color (diffuse)
  materialR = 1.0;
  materialG = 1.0;
  materialB = 1.0;
  
  // Default normal direction
  normal_x = 0;
  normal_y = 0;
  normal_z = -1;
  
  lightDirection = new PVector(0, 0, -1);

  ambientR = ambientG = ambientB = 0;

  specularR = specularG = specularB = shininess = 0;
}

void Set_Field_Of_View (float fov)
{
  field_of_view = fov;
}

void Set_Color(float r, float g, float b) {
  materialR = r;
  materialG = g;
  materialB = b;
}

float ambientR, ambientG, ambientB;
float specularR, specularG, specularB;
float shininess;

void Ambient_Specular(float ar, float ag, float ab, float sr, float sg, float sb, float pow) {
  ambientR = ar;
  ambientG = ag;
  ambientB = ab;

  specularR = sr;
  specularG = sg;
  specularB = sb;

  shininess = pow;
}

float normal_x =0;
float normal_y = 0;
float normal_z = 1;

void Normal(float nx, float ny, float nz) {
  normal_x = nx;
  normal_y = ny;
  normal_z = nz;
}

float light_x, light_y, light_z;
float light_r, light_g, light_b;

void Set_Light (float x, float y, float z, float r, float g, float b)
{

  PVector light = new PVector(x, y, z);
  light.normalize();
  light_x = light.x;
  light_y = light.y;
  light_z = light.z;
  light_r = r;
  light_g = g;
  light_b = b;
}

void Begin_Shape() {
  vertices.clear();
  normals.clear();

}

void Vertex(float vx, float vy, float vz) {
  
  float x,y,z;

  x = vx * cmat.m00 + vy * cmat.m01 + vz * cmat.m02 + cmat.m03;
  y = vx * cmat.m10 + vy * cmat.m11 + vz * cmat.m12 + cmat.m13;
  z = vx * cmat.m20 + vy * cmat.m21 + vz * cmat.m22 + cmat.m23;

  float nx,ny,nz;
  nx = normal_x * adj.m00 + normal_y * adj.m01 + normal_z * adj.m02 + adj.m03;
  ny = normal_x * adj.m10 + normal_y * adj.m11 + normal_z * adj.m12 + adj.m13;
  nz = normal_x * adj.m20 + normal_y * adj.m21 + normal_z * adj.m22 + adj.m23;

  PVector normal = new PVector(nx, ny, nz);
  normal.normalize();
  
  float xx = x;
  float yy = y;
  float zz = z;

  if (field_of_view > 0) {
    float theta = field_of_view * PI / 180.0;  // convert to radians
    float k = tan (theta / 2);
    xx = x / abs(z);
    yy = y / abs(z);
    xx = (xx + k) * width  / (2 * k);
    yy = (yy + k) * height / (2 * k);
    zz = z;
  }
  
  PVector vertex = new PVector(xx, yy, zz);
  vertices.add(vertex);
  normals.add(normal); // Also store the normalized normals
}


void End_Shape() {
  noFill();
  stroke(0);

  if (shade == Shading.WIREFRAME) {
   stroke (0, 0, 0);
    strokeWeight (2.0);

    for (int i = 0; i < vertices.size(); i += 3) {
      PVector v0 = vertices.get(i);
      PVector v1 = vertices.get((i + 1) % vertices.size());
      PVector v2 = vertices.get((i + 2) % vertices.size());
      line(v0.x, height - v0.y, v1.x, height - v1.y);
      line(v0.x, height - v0.y, v2.x, height - v2.y);
      line(v1.x, height - v1.y, v2.x, height - v2.y);
    }
  } else if(shade == Shading.CONSTANT) {
    noStroke();
    for (int i = 0; i < vertices.size(); i += 3) {
      PVector v0 = vertices.get(i);
      PVector v1 = vertices.get(i + 1);
      PVector v2 = vertices.get(i + 2);
      fillConstant(v0, v1, v2, materialR, materialG, materialB);
    }
  } else if(shade == Shading.FLAT) {
    noStroke();
    for (int i = 0; i < vertices.size(); i += 3) {
      PVector v0 = vertices.get(i);
      PVector v1 = vertices.get(i + 1);
      PVector v2 = vertices.get(i + 2);
      fillFlat(v0, v1, v2, materialR, materialG, materialB);
    }
  } else if (shade == Shading.GOURAUD) {
    noStroke();
    for (int i = 0; i < vertices.size(); i += 3) {
      PVector v0 = vertices.get(i);
      PVector v1 = vertices.get(i + 1);
      PVector v2 = vertices.get(i + 2);
      fillGouraud(v0, v1, v2, materialR, materialG, materialB);
    }
  } else if (shade == Shading.PHONG) {
    noStroke();
    for (int i = 0; i < vertices.size(); i += 3) {
      PVector v0 = vertices.get(i);
      PVector v1 = vertices.get(i + 1);
      PVector v2 = vertices.get(i + 2);
      fillPhong(v0, v1, v2, materialR, materialG, materialB);
    }
  }

  vertices.clear();
  normals.clear();
}


void fillConstant(PVector v0, PVector v1, PVector v2, float r, float g, float b) {
  v0.y = height - v0.y;
  v1.y = height - v1.y;
  v2.y = height - v2.y;
  int minX = floor(min(v0.x, min(v1.x, v2.x)));
  int maxX = ceil(max(v0.x, max(v1.x, v2.x)));
  int minY = floor(min(v0.y, min(v1.y, v2.y)));
  int maxY = ceil(max(v0.y, max(v1.y, v2.y)));

  float area = edgeFunction(v0, v1, v2);

  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {
      float w0 = edgeFunction(v1, v2, new PVector(x, y));
      float w1 = edgeFunction(v2, v0, new PVector(x, y));
      float w2 = edgeFunction(v0, v1, new PVector(x, y));

      w0 /= area;
      w1 /= area;
      w2 /= area;

      if (w0 >= 0 && w1 >= 0 && w2 >= 0) {
        float depth = v0.z * w0 + v1.z * w1 + v2.z * w2;

        if (zBuffer[x][y] < depth) {
          zBuffer[x][y] = depth;
          set(x, y, color(r * 255, g * 255, b * 255));
        }
      }
    }
  }
}

void fillPhong(PVector v0, PVector v1, PVector v2, float r, float g, float b) {
  v0.y = height - v0.y;
  v1.y = height - v1.y;
  v2.y = height - v2.y;

  int minX = floor(min(v0.x, min(v1.x, v2.x)));
  int maxX = ceil(max(v0.x, max(v1.x, v2.x)));
  int minY = floor(min(v0.y, min(v1.y, v2.y)));
  int maxY = ceil(max(v0.y, max(v1.y, v2.y)));

  float area = edgeFunction(v0, v1, v2);

  PVector lightDir = new PVector(light_x, light_y, light_z);
  lightDir.normalize();

  PVector viewVector = new PVector(0, 0, 1);

  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {
      float w0 = edgeFunction(v1, v2, new PVector(x, y));
      float w1 = edgeFunction(v2, v0, new PVector(x, y));
      float w2 = edgeFunction(v0, v1, new PVector(x, y));

      w0 /= area;
      w1 /= area;
      w2 /= area;

      if (w0 >= 0 && w1 >= 0 && w2 >= 0) {
        float depth = v0.z * w0 + v1.z * w1 + v2.z * w2;

        if (zBuffer[x][y] < depth) {
          zBuffer[x][y] = depth;

          PVector n0 = normals.get(vertices.indexOf(v0));
          PVector n1 = normals.get(vertices.indexOf(v1));
          PVector n2 = normals.get(vertices.indexOf(v2));
          PVector pixelNormal = PVector.add(PVector.mult(n0, w0), PVector.add(PVector.mult(n1, w1), PVector.mult(n2, w2)));
          pixelNormal.normalize();

          color pixelColor = phongReflectionModel(pixelNormal, lightDir, viewVector, new PVector(r, g, b));

          set(x, y, pixelColor);
        }
      }
    }
  }
}

color phongReflectionModel(PVector normal, PVector lightDir, PVector viewVector, PVector materialColor) {

  PVector ambientColor = new PVector(ambientR, ambientG, ambientB);

  float diffuseStrength = max(normal.dot(lightDir), 0);
  PVector diffuseColor = PVector.mult(materialColor, diffuseStrength);

  float specularStrength = 0.5; // strength of the specular component
  PVector reflectDir = PVector.sub(PVector.mult(normal, 2 * normal.dot(lightDir)), lightDir);
  reflectDir.normalize();
  float spec = pow(max(viewVector.dot(reflectDir), 0), shininess);
  PVector specularColor = new PVector(specularR, specularG, specularB);
  specularColor.mult(spec * specularStrength);

  PVector combinedColor = PVector.add(ambientColor, PVector.add(diffuseColor, specularColor));

  combinedColor.x = constrain(combinedColor.x, 0, 1);
  combinedColor.y = constrain(combinedColor.y, 0, 1);
  combinedColor.z = constrain(combinedColor.z, 0, 1);

  return color(combinedColor.x * 255, combinedColor.y * 255, combinedColor.z * 255);
}


void fillFlat(PVector v0, PVector v1, PVector v2, float r, float g, float b) {
  v0.y = height - v0.y;
  v1.y = height - v1.y;
  v2.y = height - v2.y;

  PVector edge1 = PVector.sub(v1, v0);
  PVector edge2 = PVector.sub(v2, v0);
  PVector normal = edge1.cross(edge2);
  normal.normalize();

  float intensity = max(lightDirection.dot(normal), 0);
  color fillColor = color(r * intensity * 255, g * intensity * 255, b * intensity * 255);

  int minX = floor(min(v0.x, min(v1.x, v2.x)));
  int maxX = ceil(max(v0.x, max(v1.x, v2.x)));
  int minY = floor(min(v0.y, min(v1.y, v2.y)));
  int maxY = ceil(max(v0.y, max(v1.y, v2.y)));

  float area = edgeFunction(v0, v1, v2);

  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {

      float w0 = edgeFunction(v1, v2, new PVector(x, y));
      float w1 = edgeFunction(v2, v0, new PVector(x, y));
      float w2 = edgeFunction(v0, v1, new PVector(x, y));

      w0 /= area;
      w1 /= area;
      w2 /= area;

      if (w0 >= 0 && w1 >= 0 && w2 >= 0) {
        float depth = v0.z * w0 + v1.z * w1 + v2.z * w2;

        if (zBuffer[x][y] < depth) {
          zBuffer[x][y] = depth;
          set(x, y, fillColor);
        }
      }
    }
  }
}



color addColors(color c1, color c2) {
  float r = min(red(c1) + red(c2), 255);
  float g = min(green(c1) + green(c2), 255);
  float b = min(blue(c1) + blue(c2), 255);
  return color(r, g, b);
}








void fillGouraud(PVector v0, PVector v1, PVector v2, float r, float g, float b) {
    v0.y = height - v0.y;
    v1.y = height - v1.y;
    v2.y = height - v2.y;

    int minX = floor(min(v0.x, min(v1.x, v2.x)));
    int maxX = ceil(max(v0.x, max(v1.x, v2.x)));
    int minY = floor(min(v0.y, min(v1.y, v2.y)));
    int maxY = ceil(max(v0.y, max(v1.y, v2.y)));

    float area = edgeFunction(v0, v1, v2);

    PVector lightDir = new PVector(light_x, light_y, light_z);
    lightDir.normalize();

    PVector viewVector = new PVector(0, 0, 1);

    float specularIntensity0 = calculateSpecular(normals.get(vertices.indexOf(v0)), lightDir, viewVector, shininess);
    float specularIntensity1 = calculateSpecular(normals.get(vertices.indexOf(v1)), lightDir, viewVector, shininess);
    float specularIntensity2 = calculateSpecular(normals.get(vertices.indexOf(v2)), lightDir, viewVector, shininess);

    for (int x = minX; x <= maxX; x++) {
        for (int y = minY; y <= maxY; y++) {
            float w0 = edgeFunction(v1, v2, new PVector(x, y));
            float w1 = edgeFunction(v2, v0, new PVector(x, y));
            float w2 = edgeFunction(v0, v1, new PVector(x, y));

            w0 /= area;
            w1 /= area;
            w2 /= area;
            
            if (w0 >= 0 && w1 >= 0 && w2 >= 0) {
                float depth = v0.z * w0 + v1.z * w1 + v2.z * w2;

                if (zBuffer[x][y] < depth) {
                    zBuffer[x][y] = depth;

                    PVector n0 = normals.get(vertices.indexOf(v0));
                    PVector n1 = normals.get(vertices.indexOf(v1));
                    PVector n2 = normals.get(vertices.indexOf(v2));
                    PVector pixelNormal = PVector.add(PVector.mult(n0, w0), PVector.add(PVector.mult(n1, w1), PVector.mult(n2, w2)));
                    pixelNormal.normalize();

                    float intensity = max(pixelNormal.dot(lightDir), 0);

                    float specularIntensity = w0 * specularIntensity0 + w1 * specularIntensity1 + w2 * specularIntensity2;

                    float finalR = r * intensity * light_r + specularR * specularIntensity;
                    float finalG = g * intensity * light_g + specularG * specularIntensity;
                    float finalB = b * intensity * light_b + specularB * specularIntensity;

                    set(x, y, color(finalR * 255, finalG * 255, finalB * 255));
                }
            }
        }
    }
}

float calculateSpecular(PVector normal, PVector lightDir, PVector viewVector, float shininess) {
  PVector reflectDir = PVector.sub(PVector.mult(normal, 2 * normal.dot(lightDir)), lightDir);
  reflectDir.normalize();
  
  float specAngle = max(reflectDir.dot(viewVector), 0);
  
  return pow(specAngle, shininess);
}



float edgeFunction(PVector a, PVector b, PVector c) {
  return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x);
}



void Set_Matrix (
float m00, float m01, float m02, float m03,
float m10, float m11, float m12, float m13,
float m20, float m21, float m22, float m23,
float m30, float m31, float m32, float m33)
{
  cmat.set (m00, m01, m02, m03, m10, m11, m12, m13,
            m20, m21, m22, m23, m30, m31, m32, m33);

  PMatrix3D imat = cmat.get(); 
  boolean okay = imat.invert();
  if (!okay) {
    println ("matrix singular, cannot invert");
    exit();
  }
  adj = imat.get();
  adj.transpose();
}

PVector applyMatrix(PMatrix3D matrix, PVector vec) {
  float[] source = new float[3];
  float[] target = new float[3];
  
  source[0] = vec.x;
  source[1] = vec.y;
  source[2] = vec.z;
  
  matrix.mult(source, target);
  
  return new PVector(target[0], target[1], target[2]);
}
