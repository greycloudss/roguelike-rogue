//---------------------------------------------------> enemyTextures <---------------------------------------------------\\



class EnemyTextures { 
  PImage spriteSheet = loadImage("textures/sickle_sheet.png");  
  
    PImage[] idle = new PImage[6];
    PImage[] run = new PImage[5];
    PImage[] jump = new PImage[5];
    PImage[] attack1 = new PImage[7];
    PImage[] attack2 = new PImage[4];
    
  EnemyTextures () {
  for (int i = 0; i < 5; ++i) {
     switch(i) {
       case 0:
          idle = setupPlayerSprites(spriteSheet, 128, 64, i, idle.length);
          break;
        
       case 1:
          run = setupPlayerSprites(spriteSheet, 128, 64, i, run.length);
          break;
        
       case 2:
          jump = setupPlayerSprites(spriteSheet, 128, 64, i, jump.length);
          break;
        
       case 3:
          attack1 = setupPlayerSprites(spriteSheet, 128, 64, i, attack1.length);
          break;
        
       case 4:
          attack2 = setupPlayerSprites(spriteSheet, 128, 64, i, attack2.length);
          break;
        
       default:
          return;
       }
     }
   }
} 
