//---------------------------------------------------> world generation <---------------------------------------------------\\


int worldWidth = 8192;
int worldHeight = 4096;

void drawWorld() {
  fill(34, 139, 34);  // Green ground
  rect(0, worldHeight - 50, worldWidth, 50);

  // Example objects (trees, rocks, etc.)
  fill(139, 69, 19);  // Brown trees
  for (int i = 100; i < worldWidth; i += 400) {
    rect(i, worldHeight - 150, 50, 100);  // Tree trunks
  }
}


void worldPad() {
  for (int y = 0; y < displayWidth; ++y) {
   image(textures[516 +32],  wh * y, displayHeight + 368);
   image(textures[516 - 32],  wh * y, displayHeight + 400);
   image(textures[516],  wh * y, displayHeight + 432);
   image(textures[516 +32],  wh * y, displayHeight + 464);
  }
}

void worldPadFlat() {
  for (int y = 0; y < displayWidth; ++y) {
    //image(textures[671],  wh * y, displayHeight - 128);
    image(textures[516 +32],  wh * y, displayHeight - 96);
    image(textures[516 - 32],  wh * y, displayHeight - 64);
    image(textures[516],  wh * y, displayHeight - 32);
  }
}

void worldBackgroundMoving() {
  int[] bricks = {430, 462, 494, 526};
  
  for (int y = 0; y < displayHeight; ++y) {
     for (int x = 0; x < displayWidth; ++x) {
       int randomNumber = int(random(0, 3));
       image(textures[bricks[randomNumber]], x * wh , y * wh);
     }
  }
}

void worldBackgroundStatic() {
  alpha(200);
  for (int y = 0; y < displayHeight; ++y) {
     for (int x = 0; x < displayWidth; ++x) {
       image(textures[430], x * wh , y * wh);
     }
  }
}


void loadingScreen() { //happy little accident
  int tlsH = displayHeight / wh;
  int tlsW = displayWidth / wh;

  for (int y = 0; y < tlsH; ++y) {
     for (int x = 0; x < tlsW; ++x) {
       int randomNumber = int(random(1, 15));
       image(textures[randomNumber], x * wh, y * wh);
       
     }
  }
  drawCenterMsg(700, 250, "Loading");
}

void drawCenterMsg(int recW, int recH, String msg) {
  //rect drawing
  rectMode(CORNER);
  fill(10, 10, 10, 255);
  float x = (displayWidth - recW) / 2;
  float y = (displayHeight - recH) / 2;
  rect(x, y, recW, recH);
  
  
  
  PFont fonter = createFont("innerworkings/timesbd.ttf", 70);
  fill(80, 0, 250, 255);
  textAlign(CENTER);
  textFont(fonter);
  text(msg, displayWidth-140, height - 15);
}
