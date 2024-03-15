// Scene Example

float time = 0;  // keep track of the "time"

void setup() {
  size (600, 600, P3D);  // use 3D here!
  noStroke();   
}

// Draw a scene with a box, cylinder and sphere
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(255, 255, 255);  // clear the screen to white

  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // place the camera in the scene
  camera (0.0, 0.0, 85.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  // create an ambient light source
  ambientLight (102, 102, 102);

  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);

  //Body
  pushMatrix();
  rotate (time/2, 0.0, 1.0, 0.0);
  body();
  popMatrix();


  // step forward the time
  time += 0.03;
}






void body() {
  pushMatrix();
  fill(255, 192, 203);  
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);

  translate(1, 0, 0);
  scale(1.3, 0.8, 1.0);  
  sphereDetail(50);
  sphere(14);

  popMatrix();
  
  // Legs
  legs(-8.5, 5, 4.5); 
  legs(-8.5, 5, -4.5);
  legs(8.5, 5, 4.5);
  legs(8.5, 5, -4.5);
  
  //Tail
  tail();
  
  //Head
  head();
}

void legs(float x, float y, float z) {
  pushMatrix();


  fill (255, 192, 203);       
  ambient (50, 50, 50);     
  specular (0, 0, 0);   
  shininess (5.0);           

  translate (x,y,z);
  cylinder (3.0, 9.0, 30);
  
  toe(-2, 8.5, 0.8);  // Toe 1
  toe(-2, 8.5, -0.8); // Toe 2


  popMatrix();
}
void toe(float x, float y, float z) {
  pushMatrix();

  fill(255, 192, 203); 
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);

  translate(x, y, z);
  scale(0.8, 0.4, 0.5);  
  sphereDetail(40);
  sphere(2);

  popMatrix();
}

void head() {
  pushMatrix();

  fill(255, 192, 203); 
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(-17, -4, 0);
  scale(0.9, 1, 1.2);  
  sphereDetail(40);
  sphere(6);

  popMatrix(); 
  
  // Mouse
  mouth(); 

  
  // Nose
  nose();
  
  // Ears
  ear(-19, -7.5, 4);
  ear(-19, -7.5, -4);
  
  // Eyes
  eye(-21, -6.5, 2.5);
  eye(-21, -6.5, -2.5);
  eyeHole(-21.6, -6.7, 2.5);
  eyeHole(-21.6, -6.7, -2.5);
}

void ear(float x, float y, float z) {
  pushMatrix();

  fill(255, 182, 193);
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(x, y, z);

  scale(0.3, 1.3, 0.7);
  sphereDetail(40);
  sphere(3);

  popMatrix();
}

void mouth() {
  pushMatrix();

  fill(255, 105, 180); 
  translate(-21.5, -1, 0);
  rotateY(PI/2);
  
  scale(0.7, 0.4, 0.2);
  sphere(3);
  
  popMatrix();
  tooth(-22, -0.85, 0.55);
  tooth(-22, -0.85, -0.55); 
}
void tooth(float x, float y, float z) {
  pushMatrix();
  
  fill(255);  // White color for the teeth
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(x, y, z);

  box(0.3, 1.3, 0.9); 
  
  popMatrix();
}


void nose() {
  pushMatrix();

  fill(255, 105, 180);
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(-22, -4, 0);
  scale(0.4, 0.6, 1.0);
  rotateZ(PI/2);
  cylinder (3.0, 3.0, 32);

  popMatrix();

  // Nose holes
  noseHole(-23, -4, 0.8);
  noseHole(-23, -4, -0.8);
}

void noseHole(float x, float y, float z) {
  pushMatrix();

  fill(0);
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(x, y, z);
  scale(0.4, 0.6, 0.3);
  sphereDetail(40);
  sphere(1);

  popMatrix();
}



void eye(float x, float y, float z) {
  pushMatrix();

  fill(0);  // White color for the eyeball
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(x, y, z); 
  sphereDetail(40);
  scale(0.8,1,1);
  sphere(0.9);    
  fill(0); 
  

  popMatrix();
}

void eyeHole(float x, float y, float z) {
  pushMatrix();

  fill(255);  // White color for the eye hole
  ambient(50, 50, 50);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(x, y, z);  // Position the eye hole in the 3D space
  sphereDetail(40);
  scale(0.4,1,1);
  sphere(0.3);  // Make it slightly bigger than the eyeball for a visible hollow effect

  popMatrix();
}

void tail() {
  pushMatrix();

  fill(255, 192, 203);
  ambient(100, 50, 50);
  specular(50, 50, 50);
  shininess(1.0);

  translate(19, 3, 0);
  rotateZ(-PI / 8);
  //rotateY(time);  // Adding a slight animation to the tail
  
  for (int i = 0; i < 5; i++) {
    pushMatrix();
    translate(i * 1.5, sin(i + time) * 1.5, 0);
    scale(1.2, 1,0.8);
    sphere(1.5);
    
    popMatrix();
  }

  popMatrix();
}

// Process key press events
void keyPressed()
{
  if (key == 's' || key =='S') {
    save ("image_file.jpg");
    println ("Screen shot was saved in JPG file.");
  }
}



// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}
