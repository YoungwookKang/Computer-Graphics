/******************************************************************************
Draw your initials below in perspective.
******************************************************************************/
// Youngwook Kang

void persp_initials()
{
  Init_Matrix();
  Perspective(70.0, 1.0, 100.0);

  Push_Matrix();
  RotateX(-25.0);
  Translate(-0.1, 0.5, -2.0);
  YK();
  Pop_Matrix();
}

void YK()
{
  // 'Y'
  Begin_Shape();
  
  Vertex(-0.1, 0.2, 1.0);
  Vertex(0.0, 0.0, 1.0);
  
  Vertex(0.1, 0.2, 1.0);
  Vertex(0.0, 0.0, 1.0);
  
  Vertex(0.0, 0.0, 1.0);
  Vertex(0.0, -0.2, 1.0);
  
  End_Shape();
  
  // 'K'
  Begin_Shape();
  
  Vertex(0.15, 0.2, 1.0);
  Vertex(0.15, -0.2, 1.0);

  Vertex(0.15, 0.0, 1.0);
  Vertex(0.25, 0.2, 1.0);

  Vertex(0.15, 0.0, 1.0);
  Vertex(0.25, -0.2, 1.0);
  
  End_Shape();
}
