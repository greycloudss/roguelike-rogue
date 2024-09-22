String pPath = "textures/NightBorne.png";

class PlayerTextures {
  private int pHeight = 80;
  private int pWidth = 80;
  
    PImage[] idle = new PImage[9];
    PImage[] run = new PImage[6];
    PImage[] attack = new PImage[12];
    PImage[] hurt = new PImage[5];
    PImage[] death = new PImage[23];


  PlayerTextures() {
    PImage tmp = null;
    for (int i = 0; i < 5; ++i) {
      if (tmp == null)
        tmp = loadImage(pPath);
      switch (i) {
        case 0:
          idle = setupPlayerSprites(tmp, pHeight, pWidth, i, idle.length);
          break;
        case 1:
          run = setupPlayerSprites(tmp, pHeight, pWidth, i, run.length);
          break;
        case 2:
          attack = setupPlayerSprites(tmp, pHeight, pWidth, i, attack.length);
          break;
        case 3:
          hurt = setupPlayerSprites(tmp, pHeight, pWidth, i, hurt.length);
          break;
        case 4:
          death = setupPlayerSprites(tmp, pHeight, pWidth, i,  death.length);
          break;
      }
    }
  }
}
    
    
    
    
PImage[] setupPlayerSprites(PImage image, int pWidth, int pHeight, int row, int size) {
  
  
  PImage[] temp = new PImage[size];
  
  for(int i = 0; i < size; ++i) {
    temp[i] = image.get(i * pWidth, row * pHeight, pWidth, pHeight);
  }
  
  
  return temp;
}
    
    
    
    
