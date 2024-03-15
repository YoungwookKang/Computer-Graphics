// Youngwook Kang
// Matrix Stack Library - You will write this!

// initialize matrix stack
ArrayList<float[][]> matrixStack = new ArrayList<float[][]>();
// You should modify the routines below to complete the assignment.
// Feel free to define any classes, global variables, and helper routines that you need.

void Init_Matrix() {
  // check stack is empty. if it is not empty, clear the stack
  if (!matrixStack.isEmpty()) {
    matrixStack.clear();
  }
  
  // initialize identity matrix and add to stack
  float[][] identityMatrix = new float[4][4];
  for (int i = 0; i < identityMatrix.length; i++) {
    for (int j = 0; j < identityMatrix[i].length; j++) {
      if (i == j) {
        identityMatrix[i][j] = 1;
      }
    }
  }
  matrixStack.add(identityMatrix);
}

void Push_Matrix() {
  // copy the current top matrix, and add copy to stack
  float[][] copyTop = matrixStack.get(matrixStack.size() - 1);
  matrixStack.add(copyTop);
}

void Pop_Matrix() {
  // if matrix stack size is more than 1, we can pop. else send error message
  if (matrixStack.size() > 1) {
    matrixStack.remove(matrixStack.size() - 1);
  } else {
    println("Error: cannot pop the matrix stack");
  }
}

void Print_CTM() {
  // print current top matrix
  float[][] topMatrix = matrixStack.get(matrixStack.size() - 1);
  for (int i = 0; i < topMatrix.length; i++) {
    for (int j = 0; j < topMatrix[i].length; j++) {
      if (j < topMatrix[i].length - 1) {
        print(topMatrix[i][j] + " ");
      } else {
        print(topMatrix[i][j]);
      }
    }
    println();
  }
  println();
}

void Translate(float x, float y, float z) {
  // create a translat matrix and replace ctm with  the product of ctm and translat matrix
  float[][] translateMatrix = {{1,0,0,x}, {0,1,0,y}, {0,0,1,z}, {0,0,0,1}};
  DotProduct(translateMatrix);
}

void Scale(float x, float y, float z) {
  // create a scale matrix and replace ctm with  the product of ctm and scale matrix
  float[][] scaleMatrix = {{x,0,0,0}, {0,y,0,0}, {0,0,z,0}, {0,0,0,1}};
  DotProduct(scaleMatrix);
}

void RotateX(float theta) {
  // create a matrix rotated about the X-axis and replace ctm with  the product of ctm and matrix rotated about the X-axis matrix
  theta = radians(theta);
  float[][] rotateXMatrix = {{1,0,0,0}, {0,cos(theta),-sin(theta),0}, {0,sin(theta),cos(theta),0}, {0,0,0,1}};
  DotProduct(rotateXMatrix);
}

void RotateY(float theta) {
  // create a matrix rotated about the Y-axis and replace ctm with  the product of ctm and matrix rotated about the Y-axis matrix
  theta = radians(theta);
  float[][] rotateYMatrix = {{cos(theta),0,sin(theta),0}, {0,1,0,0}, {-sin(theta),0,cos(theta),0}, {0,0,0,1}};
  DotProduct(rotateYMatrix);
}

void RotateZ(float theta) {
  // create a matrix rotated about the Z-axis and replace ctm with  the product of ctm and matrix rotated about the Z-axis matrix
  theta = radians(theta);
  float[][] rotateZMatrix = {{cos(theta),-sin(theta),0,0}, {sin(theta),cos(theta),0,0}, {0,0,1,0}, {0,0,0,1}};
  DotProduct(rotateZMatrix);
}

void DotProduct(float[][] transformationMatrix) {
  //it is the product of a matrix
  float[][] oldCtm = matrixStack.get(matrixStack.size() - 1);
  float[][] newCtm = new float[4][4];
  for (int i = 0; i < newCtm.length; i++) {
    for (int j = 0; j < newCtm[i].length; j++) {
      for (int k = 0; k < newCtm.length; k++) {
        newCtm[i][j] += oldCtm[i][k] * transformationMatrix[k][j];
      }
    }
  }
  // add the result of porduct to the stack
  matrixStack.set(matrixStack.size() - 1, newCtm);
}
