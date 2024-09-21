 import java.io.File;


PImage img;

World world;
int wh = 32;
int yZero = displayHeight - 180;

PImage[] textures = new PImage[(1024 / wh)  * (1024 / wh) + 1];

PGraphics backgroundGraphics;
//String userCFG = "innerworkings/usercfg.cfg";
//when an outright number is used while working with the texture picture remember that the pictures size is 1024x1024 and it divided by 32 is 32

localPlayer player;


//---------------------------------------------------> Main file <---------------------------------------------------\\


void setup() {
  frameRate(240);
  windowTitle("RogueLike Rogue");
  fullScreen();
  
  if (img == null)
    img = loadImage("textures/texturePack.png");
  
  
  size(displayWidth, displayHeight);
  
  
  parser();
  world = new World(4096 * 2, 4096, new Tile(textures[430], false, wh));
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
  //image(backgroundGraphics, 0 , 0);
  world.display();
  player.move();
  collisions(world, player);
  println(player.pos.x + ' ' + player.pos.y);
  // the -player.pos.y * 0.8 should be something that indicates the terrains height
  float offsetX = constrain(-player.pos.x  + width / 2, width - world.wWidth, 0);
  float offsetY = constrain(-player.pos.y + height / 2, height - world.wHeight, 0);
  translate(offsetX, offsetY);
  
  
  //collisions()
  if (player.alive)
    noCursor();

}
