PlayerTextures ptextures;

class localPlayer {
  int animSpeed = 7;
  int yZero = displayHeight + 500;
  int pHeight = 80;
  int pWidth = 80;
  float speed = 8;
  PVector pos;

  int curFrame, totalFrames, frameCounter;

  int oneJump = yZero - 250;
  int doubleJump = yZero - 310;

  int health;
  boolean movingLeft;
  boolean movingRight;
  boolean moving;
  boolean isJumping;
  boolean isDoubleJumping;
  boolean isFalling;
  boolean strike;
  boolean alive;
  boolean facingLeft;
  boolean attackActive;
  boolean isAttacking; // Track attack state

  PImage[] curState;
 
  float htbWidth, htbHeight;
  PVector htbVec = new PVector();
 

  localPlayer() {
    ptextures = new PlayerTextures();
    pos = new PVector(0, 300);
    pWidth *= 5; // multiplied by 5 to make it not as small as previously, less opps
    pHeight *= 5;
    
    
    movingRight = false;
    movingLeft = false;
    moving = false;
    isJumping = false;
    isDoubleJumping = false;
    isFalling = false;
    strike = false;
    alive = true;
    health = 100;

    curFrame = 0;
    frameCounter = 0;
    curState = ptextures.idle;
    totalFrames = ptextures.idle.length;

    facingLeft = false;
    attackActive = false;
    isAttacking = false;
    
    htbWidth = pWidth * 0.25;
    htbHeight = pHeight * 0.3;
  }

  void drawHurtbox() {
      fill(10, 10, 10, 150);
      noStroke();

      rect(htbVec.x, htbVec.y, htbWidth, htbHeight);
  }
  
  
  void displayChar() {
    htbVec.x = pos.x + (pWidth - htbWidth) / 2;
    htbVec.y = pos.y + (pHeight - htbHeight) / 1.5;
    
    
    
    // Update the current state based on player movement or action
    if (isAttacking) {
      curState = ptextures.attack;

      if (curFrame >= 9 && curFrame < 13) {
        attackActive = true; // Activate attack hitbox during attack frames
      } else {
        attackActive = false; // Deactivate hitbox otherwise
      }
    } else if (!isFalling && isJumping || isDoubleJumping) {
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
      curFrame = (curFrame + 1) % totalFrames; // Loop through frames
    }

    frameCounter++;

    // Reset frame and attack state if animation finishes
    if (curFrame >= totalFrames) {
      curFrame = 0;
      isAttacking = false; // Reset attacking state when animation finishes
      attackActive = false; // Ensure hitbox is deactivated
    }

    if (curState != null && curState[curFrame] != null) {
      if (facingLeft) {
        pushMatrix();
        translate(pos.x + pWidth, pos.y);
        scale(-1, 1);
        image(curState[curFrame], 0, 0, pWidth, pHeight);
        popMatrix();
      } else {
        image(curState[curFrame], pos.x, pos.y, pWidth, pHeight);
      }
    }

    //drawHurtbox();
    if (attackActive) drawAttackHitbox(); // Draw attack hitbox if active
  }

  void drawAttackHitbox() {
    noFill();
    noStroke();
    float attackWidth = pWidth * 0.5;
    float attackHeight = pHeight * 0.7;
    float attackX = facingLeft ? pos.x - pWidth * 0.5 + attackWidth : pos.x + pWidth * 0.5;
    float attackY = pos.y + (pHeight - attackHeight) / 2;
    rect(attackX, attackY, attackWidth, attackHeight);
  }

  void move() {
    if (alive) {
      // Check if the mouse is pressed
      if (mousePressed && mouseButton == LEFT) {
        if (!isAttacking) {
          isAttacking = true; // Start attacking
          strike = true; // Set strike to true to enter attack mode
        }
      } else if (isAttacking) {
        // If mouse is released while attacking, stop the attack
        isAttacking = false;
        strike = false; // Stop striking
      }
      

      jump();
      displayChar();

      // Handle movement
      if (moving) {
        if (movingRight) {
          pos.x += speed;
          facingLeft = false;
        }
        if (movingLeft) {
          pos.x -= speed;
          facingLeft = true;
        }
      }

      if (strike) {
        moving = false; // Stop moving if striking
      }

      // Constrain position
      pos.x = constrain(pos.x, -90, world.wWidth);
      pos.y = constrain(pos.y, 0, world.wHeight);
    }
  }

  void jump() {
    if (isJumping && isDoubleJumping) {
        pos.y -= speed * 4; // Double jump speed

        if (movingRight) {
            pos.x += speed * 4; // Apply horizontal movement in double jump
        }
        if (movingLeft) {
            pos.x -= speed * 4;
        }

        if (pos.y <= doubleJump) {
            isDoubleJumping = false;
            isFalling = true; 
        }
    } else if (isJumping && !isFalling) { // Regular jump
        curState = ptextures.run;
        pos.y -= speed * 4; // Jumping speed

        if (movingRight) {
            pos.x += speed * 4;
        }
        if (movingLeft) {
            pos.x -= speed * 4;
        }

        if (pos.y <= oneJump) {
            isJumping = false;
            isFalling = true;
        }
    }

    if (isFalling) {
        pos.y += speed;
        curState = ptextures.idle;

        if (pos.y >= yZero) { // Player hits the ground
            pos.y = yZero;
            curState = ptextures.idle;
            isFalling = false;
            isJumping = false;
            isDoubleJumping = false; // Reset double jump when hitting the ground
        }
    }
    curState = ptextures.idle;
  }
}
