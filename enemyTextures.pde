

/**
 * Represents the textures for different enemy animations.
 * This class loads a sprite sheet and initializes arrays for various enemy actions
 * including idle, run, jump, and attack animations.
 */
class EnemyTextures { 
    // The sprite sheet containing all enemy textures
    PImage spriteSheet = loadImage("textures/sickle_sheet.png");  
  
    // Arrays to hold textures for different enemy states
    PImage[] idle = new PImage[6];      // Idle animation frames
    PImage[] run = new PImage[5];       // Running animation frames
    PImage[] jump = new PImage[5];      // Jumping animation frames
    PImage[] attack1 = new PImage[7];   // First attack animation frames
    PImage[] attack2 = new PImage[4];   // Second attack animation frames
    
    /**
     * Constructor for the EnemyTextures class.
     * Loads the enemy textures from the sprite sheet and populates the animation arrays
     * based on the predefined number of frames for each action.
     */
    EnemyTextures() {
        for (int i = 0; i < 5; ++i) {
            switch(i) {
                case 0: // Setup idle animations
                    idle = setupPlayerSprites(spriteSheet, 128, 64, i, idle.length);
                    break;
                
                case 1: // Setup run animations
                    run = setupPlayerSprites(spriteSheet, 128, 64, i, run.length);
                    break;
                
                case 2: // Setup jump animations
                    jump = setupPlayerSprites(spriteSheet, 128, 64, i, jump.length);
                    break;
                
                case 3: // Setup first attack animations
                    attack1 = setupPlayerSprites(spriteSheet, 128, 64, i, attack1.length);
                    break;
                
                case 4: // Setup second attack animations
                    attack2 = setupPlayerSprites(spriteSheet, 128, 64, i, attack2.length);
                    break;
                
                default:
                    return; // Exit if index is out of range
            }
        }
    }
}
