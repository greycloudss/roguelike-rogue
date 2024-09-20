//---------------------------------------------------> local player handling <---------------------------------------------------\\
PlayerTextures ptextures;

class localPlayer {
  int animSpeed = 12;
  int yZero = displayHeight + 100;
  int pHeight = 80;
  int pWidth = 80;
  float speed = 8;
  PVector pos;
  
  int curFrame, totalFrames, frameCounter;

  int oneJump = yZero - 250;
  int doubleJump = yZero - 310; // skybox limit for player
  
  // flags
  int health;

  boolean movingLeft;
  boolean movingRight;
  boolean moving;
  boolean isJumping;
  boolean isFalling;
  boolean strike;
  boolean alive;
  boolean facingLeft; // New variable to track the facing direction
  
  PImage[] curState;

  localPlayer() {
    ptextures = new PlayerTextures();
    pos = new PVector(0, displayHeight + 100);
    
    pWidth *= 5;
    pHeight *= 5;
    
    movingRight = false;
    movingLeft = false;
    moving = false;
    isJumping = false;
    isFalling = false;
    strike = false;
    alive = true;
    health = 100;
    
    curFrame = 0;
    frameCounter = 0;
    curState = ptextures.idle;  // Initialize curState to default (standing state)
    totalFrames = ptextures.idle.length;

    facingLeft = false; // Start facing right by default
  }

  void displayChar() {
    // Update the current state based on player movement or action
    if (strike) {  
      curState = ptextures.attack;
    } else if (!isFalling && isJumping) {
      curState = ptextures.run;
    } else if (isFalling && !isJumping) {
      curState = ptextures.idle;
    } else if (moving) {
      curState = ptextures.run;
    } else if (!alive) {
      curState = ptextures.death;
    } else {
      curState = ptextures.idle;
    }

    totalFrames = curState.length;

    // FRAME HANDLING
    if (frameCounter % animSpeed == 0) {
      curFrame = (curFrame + 1) % totalFrames;  // Loop through frames based on totalFrames
    }

    frameCounter++;  // Increment the frame counter each time move() is called

    if (curFrame >= totalFrames) curFrame = 0;

    // Display the current frame of the animation
    if (curState != null && curState[curFrame] != null) {
      if (facingLeft) {
        pushMatrix();
        translate(pos.x + pWidth, pos.y); // Adjust for flipping
        scale(-1, 1); // Flip horizontally
        image(curState[curFrame], 0, 0, pWidth, pHeight);
        popMatrix();
      } else {
        image(curState[curFrame], pos.x, pos.y, pWidth, pHeight);
      }
    }
  }

  void move() {
    if (alive) {
      strike = mousePressed && mouseButton == LEFT;

      jump();
      
      displayChar();
      
      if (moving) {
        // Move left or right
        if (movingRight) {
          pos.x += speed;
          facingLeft = false; // Facing right
        }
        if (movingLeft) {
          pos.x -= speed;
          facingLeft = true; // Facing left
        }
      }
      
      if (strike) {
        moving = false;
      }
      pos.x = constrain(pos.x, -90, worldWidth);
      pos.y = constrain(pos.y, 0, worldHeight);
    }
  }
  
  void jump() {
    if (isJumping && !isFalling) {
      curState = ptextures.run;
      pos.y -= speed * 4;

      if (movingRight) {
        pos.x += speed * 4;
      } 
      if (movingLeft) {
        pos.x -= speed * 4;
      }
      
      if (pos.y <= oneJump || pos.y <= doubleJump) {
        isJumping = false;
        isFalling = true;
      }
    }

    if (isFalling) {
      pos.y += speed;
      curState = ptextures.idle;

      if (pos.y >= yZero) {
        pos.y = yZero;
        curState = ptextures.idle;
        isFalling = false;
      }
    }
    curState = ptextures.idle;
  }
}
