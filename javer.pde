import java.io.File;
// 523 - 526
PImage img;
PImage pimg;
int wh = 32;
int yZero = displayHeight - 180;
PImage[] textures = new PImage[(1024 / wh)  * (1024 / wh) + 1];
PImage[][] ptxt = new PImage[5][10];
PGraphics backgroundGraphics;
String userCFG = "innerworkings/usercfg.cfg";
//when an outright number is used while working with the texture picture remember that the pictures size is 1024x1024 and it divided by 32 is 32


localPlayer player;

void setup() {
  frameRate(60);
  windowTitle("Dinky ahhh game");
  fullScreen();
  img = loadImage("textures/texturePack.png");
  pimg = loadImage("textures/Assassin.png");
  pimg.resize(int(pimg.width * 2), int(pimg.height * 2));
  size(displayWidth, displayHeight);
  parser();
  parsePlayer();
  player = new localPlayer();
  
  
  backgroundGraphics = createGraphics(width, height);

  backgroundGraphics.beginDraw();
  for (int x = 0; x < width; x += textures[430].width) {
    for (int y = 0; y < height; y += textures[430].height) {
      backgroundGraphics.image(textures[430], x, y);
    }
  }
  backgroundGraphics.endDraw();
  smooth(16);
}


void draw() {
  background(14, 12, 18);
  image(backgroundGraphics, 0 , 0);
  worldPad();
  player.move();
}
//---------------------------------------------------> menu handling <---------------------------------------------------\\


void drawMenu() {
  
}


//---------------------------------------------------> player handling <---------------------------------------------------\\


void keyPressed() {
  switch(key) {
    case 'a':
        player.moving = true;
        player.movingLeft = true;
      break;
    case 'd':
        player.moving = true;
        player.movingRight = true;
      break;
    case 'w':
        player.moving = true;
        player.isJumping = true;
      break;
  }
}

void keyReleased() {
  switch(key) {
    case 'a':
        player.moving = false;
        player.movingLeft = false;
      break;
    case 'd':
        player.moving = false;
        player.movingRight = false;
      break;
  }
}

void parsePlayer() {
  int segmentWidth = pimg.width / 10;
  int segmentHeight = pimg.height / 5;

  for (int y = 0; y < 5; ++y) {
    for (int x = 0; x < 10; ++x) {
      ptxt[y][x] = pimg.get(x * segmentWidth, y * segmentHeight, segmentWidth, segmentHeight);
      ptxt[y][x].resize(int(ptxt[y][x].width * 2), int(ptxt[y][x].height * 2));
    }
  }
}


//---------------------------------------------------> world generation <---------------------------------------------------\\


void worldPad() {
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
  //rect(x, y, recW, recH);
  
  
  
  PFont fonter = createFont("innerworkings/timesbd.ttf", 70);
  fill(80, 0, 250, 255);
  textAlign(CENTER);
  textFont(fonter);
  text(msg, displayWidth-140, height - 15);
}



//---------------------------------------------------> behind the scenes logic <---------------------------------------------------\\


void parser() {
  int tilesPerRow = 1024 / wh;
  int index = 0;
  for (int y = 0; y < tilesPerRow; ++y) {
    for (int x = 0; x < tilesPerRow; ++x) {
      index = y * tilesPerRow + x;
      textures[index] = img.get(x * wh, y * wh, wh, wh);
    }
  }
}

boolean hasConfig() {
  File file = new File(userCFG);
  return file.exists() ? true : false;
}

void showTexturesIds() {
  var index = 0;
  fill(0, 0, 0);
  for (int y = 0; y < 1024 /wh; ++y) {
     for (int x = 0; x < 1024 / wh; ++x) {
        index = y * wh + x; // how we get the textures
        textures[index] = img.get(x * wh, y * wh, wh, wh);
        image(textures[index], x * wh, y * wh);
        text(index, x*wh, y*wh);
     }
  }
  
  for(int i = 0; i < width/wh; i++ ) {
   line(i*wh, 0, i*wh, height);
   line(0, i*wh, width, i*wh);
   
  }
  
}
