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
    
    
    
    
/*
Hours spent debugging the code  bellow: 12


|********************|
|***   redudant   ***|
|********************|

String[] paths = new String[]{
  "textures/knightier/knight1.png",
  "textures/knightier/knight2.png",
  "textures/knightier/knight3.png",
  "textures/knightier/knight4.png",
  "textures/knightier/knight5.png",
  "textures/knightier/knight6.png"
};

class PlayerTextures {
  private int pHeight = 64;
  private int pWidth = 80;
  

  PImage[] jumpATK;
  PImage[] attack;
  PImage[] death;
  PImage[] stand;
  PImage[] pray;
  PImage[] run;
  
  PlayerTextures() {
    for (int i = 0; i < paths.length; ++i) {
      PImage tmp = loadImage(paths[i]);
      switch (i) {
        case 0:
          jumpATK = setupPlayerSprites(tmp, pHeight, pWidth);
          break;
        case 1:
          attack = setupPlayerSprites(tmp, pHeight, pWidth);
          break;
        case 2:
          death = setupPlayerSprites(tmp, pHeight, pWidth);
          break;
        case 3:
          stand = setupPlayerSprites(tmp, pHeight, pWidth);
          break;
        case 4:
          pray = setupPlayerSprites(tmp, pHeight, pWidth);
          break;
        case 5:
          run = setupPlayerSprites(tmp, pHeight, pWidth);
          break;
      }
    }
  }
}




PImage[] setupPlayerSprites(PImage image, int pHeight, int pWidth) {
  // Calculate how many blocks (sprites) exist in the image.
  int xBlocks = image.width / pWidth;  // Number of sprites horizontally
  int yBlocks = image.height / pHeight;  // Number of sprites vertically

  PImage[] temp = new PImage[xBlocks * yBlocks + 1];  // Adjust the size based on the number of sprites

  for (int y = 0; y < yBlocks; ++y) {
    for (int x = 0; x < xBlocks; ++x) {
      // Get the sprite at (x, y) position on the grid
      temp[y * xBlocks + x] = image.get(x * xBlocks, y * yBlocks, pWidth, pHeight);
      
      // Resize the sprite if needed (optional, adjust as necessary)
      //temp[y * xBlocks + x].resize(int(pWidth * 2.5), int(pHeight * 2.5));  // Scale each sprite by 4x
    }
  }

  return temp;  // Return the array of sprites
}*/
