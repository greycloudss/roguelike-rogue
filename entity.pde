//---------------------------------------------------> Where we wrangle with the entity class <---------------------------------------------------\\


private class EntityTextures {
  protected int sHeight;
  protected int sWidth;
  
    PImage[] idle;
    PImage[] run;
    PImage[] attack;
    PImage[] hurt;
    PImage[] death;


  EntityTextures(String path, int sWidth, int sHeight) {
    this.sHeight = sHeight;
    this.sWidth = sWidth;
    PImage tmp = loadImage(path);
    if (tmp == null) return;
    for (int i = 0; i < tmp.height / sHeight; ++i) {
      switch (i) {
        case 0:
          idle = setupPlayerSprites(tmp, sHeight, sWidth, i, idle.length);
          break;
        case 1:
          run = setupPlayerSprites(tmp, sHeight, sWidth, i, run.length);
          break;
        case 2:
          attack = setupPlayerSprites(tmp, sHeight, sWidth, i, attack.length);
          break;
        case 3:
          hurt = setupPlayerSprites(tmp, sHeight, sWidth, i, hurt.length);
          break;
        case 4:
          death = setupPlayerSprites(tmp, sHeight, sWidth, i,  death.length);
          break;
        default:
          ++i; // iterate to make sure it stops immediately or stops faster;
          break;
      }
    }
  }
}

class Entity {
  EntityTextures textures;
  int yZero = 300;
  PVector spritePos;
  int spriteWidth, spriteHeight;
  PVector spriteBox;
  float hitboxWidth, hitboxHeight;
  
  private PImage spriteSheet;
  
  PImage[] curState;
  
  boolean isMoving;
  boolean isFalling;
  boolean isStanding;
  boolean isStriking;
  
  boolean isAlive;
  int health;
  
  float speed = 7;
  
  int curFrame;
  int frameCounter;
  int totalFrames;
  

  
  Entity(String path, int spriteWidth, int spriteHeight) {
    this.spriteWidth = spriteWidth;
    this.spriteHeight = spriteHeight;
    
    isMoving = isFalling = isStriking = false;
    isStanding = true;
    isAlive = true;
    health = 100;
    
    textures = new EntityTextures(path, spriteWidth, spriteHeight);
    
    curFrame = 0;
    frameCounter = 0;
    curState = this.textures.idle;
    totalFrames = this.textures.idle.length;
    
    return;
  }
  
  
  void display() {
    totalFrames = curState.length;

    if (frameCounter % speed == 0) 
      curFrame = (curFrame + 1) % totalFrames;
    

    frameCounter++;

    if (curFrame >= totalFrames)
      curFrame = 0;


    if (curState != null && curState[curFrame] != null) 
        image(curState[curFrame], spritePos.x, spritePos.y, spriteWidth, spriteHeight);
  }
}
