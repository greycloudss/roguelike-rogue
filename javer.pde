//---------------------------------------------------> Main file <---------------------------------------------------\\



import java.io.File;

PImage img;

World world;
int wh = 32;
int yZero = displayHeight - 180;

PImage[] textures = new PImage[(1024 / wh) * (1024 / wh) + 1];

localPlayer player;



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
  
  smooth(16);
}

void draw() {
  System.gc();
  // Draw the world with camera offset
  float offsetX = constrain(-player.pos.x + width / 2, width - world.wWidth, 0);
  float offsetY = constrain(-player.pos.y + height / 2, height - world.wHeight, 0);
  translate(offsetX, offsetY);
  
  world.display();
  player.move();
  collisions(world, player);
  //println(player.pos.x + " " + player.pos.y);
  player.drawHurtbox();
  // Collisions
  if (player.alive)
    noCursor();
    
}
