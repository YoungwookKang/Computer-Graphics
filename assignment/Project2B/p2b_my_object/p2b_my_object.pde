// Scene Example
//Youngwook Kang

float time = 0;  // keep track of the "time"
float legAngle = 0;
float runStart = 0;
float runStop = 10;
float twist = 10;
float twistStop = 14;
float rise = 16;
float sink = 19;
float flutter = 23;



void setup() {
  size (600, 600, P3D);  // use 3D here!
  noStroke();   
}

// Draw a scene with a box, cylinder and sphere
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(135, 206, 235);  // sky blue
  pushMatrix();
  fill(0, 255, 0);  // Green color
  translate(0, 20, 0);  
  rotateX(PI/2);
  rect(-300, -300, 600, 600);  
  popMatrix();
  pointLight(255, 255, 204, -200, -300, -500);  
  sun();
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // place the camera in the scene

  if (time <= twistStop) {
    camera (0.0 - (time*4), 0.0, 65, 0.0 - (time*4), 0.0, 1.0, 0.0, 1.0, 0.0);
  } else {
    camera (0.0 - (twistStop*4), 0.0, 65, 0.0 - (twistStop*4), 0.0, 1.0, 0.0, 1.0, 0.0);
  }
  
  // create an ambient light source
  ambientLight (102, 102, 102);

  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);
  
  
  pushMatrix();
  translate(0,-5,0);
  trees(); //1
  popMatrix();
  
  pushMatrix();
  translate(40,-5,30);
  trees(); //1
  popMatrix();
  
  pushMatrix();
  translate(79,-5,-30);
  trees(); //1
  popMatrix();
  
  pushMatrix();
  translate(-110,-5,30);
  trees(); //1
  popMatrix();
  
  pushMatrix();
  translate(-140,-5,-30);
  trees(); //1
  popMatrix();
  
  
  legAngle = sin(time*14) * 0.3;  
  
  //Body
  pushMatrix();

  
  if (time <= runStop) {
    scale(0.5,0.5,0.5);
    translate(-time*9, 0);
  } else if (time > twist &&  time <= twistStop) {
    scale(0.5,0.5,0.5);
    translate(-runStop*9 + ((time-twist) * -7.0), 0); 
    rotateZ((-twist+time) * PI);
  } else if (time > twistStop && time <= rise) {
    scale(0.5,0.5,0.5);
    translate(-runStop*9 + ((twistStop-twist) * -7.0), -5 * (time- twistStop));
  } else if (time > rise && time <= sink) {
    scale(0.5,0.5,0.5);
    translate(-runStop*9 + ((twistStop-twist) * -7.0), -5 * (rise- twistStop) + 5 * (time- rise));
    rotateZ(PI * (time - rise) / 3);
  } else if (time > sink && time <= flutter) {
    scale(0.5,0.5,0.5);
    translate(-runStop*9 + ((twistStop-twist) * -7.0), -5 * (rise- twistStop) + 5 * (sink- rise));
    rotateZ(PI);
  } else {
    if ((time - flutter) < 0.5) {
      scale(0.5 -0.3 * (time - flutter),0.5 -0.3 * (time - flutter),0.5 -0.3 * (time - flutter));
    } else {
      scale(0,0,0);
    }
    translate(-runStop*9 + ((twistStop-twist) * -7.0), -5 * (rise- twistStop) + 5 * (sink- rise));
    rotateZ(PI);
    background((time - flutter) *100, 0, 0);
  }
  
  body();
  popMatrix();
  
  pushMatrix();
  if (time <= twist) {
    translate(-52, 6, 0);
  } else {
    translate(-52 + 10 * (twist - time), 6, 0);
  }
    
  rock();
  popMatrix();


  // step forward the time
  time += 0.03;
}






void body() {
  pushMatrix();
  fill(255, 192, 203);  
  ambient(140, 70, 60);  
  specular(100, 60, 50); 
  shininess(5.0); 

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
  ambient(140, 70, 60);  
  specular(100, 60, 50); 
  shininess(5.0);           

  translate (x,y,z);
  if (time > runStart && time < runStop) {
    if(x < 0) {
      rotateZ(legAngle);  // Back legs
    } else {
      rotateZ(-legAngle);  // Front legs
    }
  } else if (time > sink && time <= flutter) {
    if ((x < 0 && z < 0) || (x > 0 && z > 0)) {
      rotateZ(legAngle);  
    } else if ((x > 0 && z < 0) || (x < 0 && z > 0)){
      rotateZ(-legAngle); 
    }
  }
  
  cylinder (3.0, 9.0, 30);
  
  toe(-2, 8.5, 0.8);  // Toe 1
  toe(-2, 8.5, -0.8); // Toe 2


  popMatrix();
}
void toe(float x, float y, float z) {
  pushMatrix();

  fill(255, 192, 203); 
  ambient(140, 70, 60);  
  specular(100, 60, 50); 
  shininess(5.0); 

  translate(x, y, z);
  scale(0.8, 0.4, 0.5);  
  sphereDetail(40);
  sphere(2);

  popMatrix();
}

void head() {
  pushMatrix();

  fill(255, 192, 203); 
  ambient(140, 70, 60);  
  specular(100, 60, 50); 
  shininess(5.0);  
  
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
  ambient(140, 80, 90);  
  specular(100, 50, 70);  
  shininess(4.0);
  
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
  ambient(140, 80, 90);  
  specular(100, 50, 70);  
  shininess(4.0);
  
  translate(x, y, z);
  scale(0.4, 0.6, 0.3);
  sphereDetail(40);
  sphere(1);

  popMatrix();
}



void eye(float x, float y, float z) {
  pushMatrix();

  fill(0);  
  ambient(10, 10, 10); 
  specular(100, 100, 100); 
  shininess(2.0); 
  
  translate(x, y, z); 
  sphereDetail(40);
  scale(0.8,1,1);
  sphere(0.9);    
  fill(0); 
  

  popMatrix();
}

void eyeHole(float x, float y, float z) {
  pushMatrix();

  fill(255);  
  ambient(10, 10, 10); 
  specular(100, 100, 100); 
  shininess(2.0); 
  
  translate(x, y, z);  
  sphereDetail(40);
  scale(0.4,1,1);
  sphere(0.3);  

  popMatrix();
}

void tail() {
  pushMatrix();

  fill(255, 192, 203);
  ambient(140, 70, 60);  
  specular(100, 60, 50); 
  shininess(5.0);   

  translate(19, 3, 0);
  rotateZ(-PI / 8);

  
  for (int i = 0; i < 5; i++) {
    pushMatrix();
    translate(i * 1.5, sin(i + time) * 1.5, 0);
    scale(1.2, 1,0.8);
    sphere(1.5);
    
    popMatrix();
  }

  popMatrix();
}

void tree() {
  float x = -20;
  float y = 10;
  float z = -20;
  float height = 40;

  float trunkHeight = height * 0.5;  
  float foliageHeight = height - trunkHeight;
  
  // Trunk
  pushMatrix();
  fill(139, 69, 19);  // Brown color for trunk
  translate(x, y - (trunkHeight*6/7), z);
  cylinder(2, trunkHeight, 20);  
  specular(100, 60, 0);  
  shininess(5);  
  popMatrix();

  // Foliage
  pushMatrix();
  fill(34, 139, 34);  
  specular(0, 100, 0);  
  shininess(10);  
  // Topmost sphere
  translate(x, y - height + trunkHeight, z);  
  sphere(foliageHeight / 6);
  
  // Middle sphere
  translate(0, foliageHeight / 4, 0);
  sphere(foliageHeight / 4);
  
  // Bottom sphere
  translate(0, foliageHeight / 3, 0);
  sphere(foliageHeight / 3);
  
  popMatrix();
}

void trees() {
  pushMatrix();
  translate(-30,0,-40);
  tree();
  popMatrix();
  
  pushMatrix();
  translate(40,0,30);
  tree();
  popMatrix();
  
  pushMatrix();
  translate(30,0,-40);
  tree();
  popMatrix();
  
  pushMatrix();
  translate(-20,0,30);
  tree();
  popMatrix();
  

}

void rock() {
    fill(128, 128, 128);  // Grey color for rock
    specular(60, 60, 60);
    shininess(10);
    sphere(1); 
}

void sun() {
  pushMatrix();
  fill(255, 150, 0);  
  translate(-100, -400, -900);  
  sphere(50);  // Radius of the sun
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
