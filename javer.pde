import java.io.File;


PImage img;


int wh = 32;
int yZero = displayHeight - 180;

PImage[] textures = new PImage[(1024 / wh)  * (1024 / wh) + 1];
PImage[][] ptxt = new PImage[5][10];

PGraphics backgroundGraphics;
//String userCFG = "innerworkings/usercfg.cfg";
//when an outright number is used while working with the texture picture remember that the pictures size is 1024x1024 and it divided by 32 is 32

localPlayer player;


//---------------------------------------------------> Main file <---------------------------------------------------\\


void setup() {
  background(14, 12, 18);
  frameRate(240);
  windowTitle("RogueLike Rogue");
  fullScreen();
  
  if (img == null) 
    img = loadImage("textures/texturePack.png");
  
  
  size(displayWidth, displayHeight);
  
  
  parser();

  player = new localPlayer();
  
  
  if (backgroundGraphics == null) {
    backgroundGraphics = createGraphics(width, height);
    backgroundGraphics.beginDraw();
    for (int x = 0; x < width; x += textures[430].width) {
      for (int y = 0; y < height; y += textures[430].height) {
        backgroundGraphics.image(textures[430], x, y);
      }
    }
    backgroundGraphics.endDraw();
  }

  smooth(16);
}



void draw() {
  System.gc();
  image(backgroundGraphics, 0 , 0);
  float offsetX = constrain(-player.pos.x + width / 2, width - worldWidth, 0);
  float offsetY = constrain(-player.pos.y + height / 2, height - worldHeight, 0);
  translate(offsetX, offsetY);
  
  drawWorld();

  player.move();
  if (player.alive)
    noCursor();
    
    

  drawCenterMsg(700, 250, str(floor(offsetX - player.pos.x)), floor(offsetX - player.pos.x));
}
