PlayerTextures ptextures;

class localPlayer {
  int animSpeed = 7;
  int yZero = displayHeight + 500;
  int pHeight = 80;
  int pWidth = 80;
  float speed = 8;
  PVector pos;

  int curFrame, totalFrames, frameCounter;

  float jumpForce = 10; 
  float gravity = 0.4; 
  boolean onGround;

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
  boolean isAttacking;

  PImage[] curState;

  float htbWidth, htbHeight;
  PVector htbVec = new PVector();
  PVector velocity = new PVector(); // To manage vertical movement

  localPlayer() {
    ptextures = new PlayerTextures();
    pos = new PVector(0, 300);
    pWidth *= 5;
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
    
   
    
    if (isAttacking) {
      curState = ptextures.attack;
      if (curFrame >= 9 && curFrame < 13) {
        attackActive = true;
      } else {
        attackActive = false;
      }
    } else if (isFalling) {
      curState = ptextures.idle;
    } else if (moving) {
      curState = ptextures.run;
    } else {
      curState = ptextures.idle;
    }

    totalFrames = curState.length;

    if (frameCounter % animSpeed == 0) {
      curFrame = (curFrame + 1) % totalFrames;
    }

    frameCounter++;

    if (curFrame >= totalFrames) {
      curFrame = 0;
      isAttacking = false;
      attackActive = false;
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

    if (attackActive) drawAttackHitbox();
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
      if (mousePressed && mouseButton == LEFT) {
        if (!isAttacking) {
          isAttacking = true;
          strike = true;
        }
      } else if (isAttacking) {
        isAttacking = false;
        strike = false;
      }

      jump();
      displayChar();

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
        moving = false;
      }

      // Constrain position
      pos.x = constrain(pos.x, -90, world.wWidth);
      pos.y = constrain(pos.y, 0, world.wHeight);
      collisions(world, player);
    }
  }

  void jump() {
    if (onGround) {
      if (isJumping) {
        onGround = false;
        velocity.y = -jumpForce; // Apply jump force
        isJumping = false; // Reset jump state after applying
      } 
    }

    // Apply gravity
    if (!onGround) {
      velocity.y += gravity;
      pos.y += velocity.y; // Update position based on velocity

      if (pos.y >= yZero) { // Check if player hits the ground
        pos.y = yZero; // Reset position to ground
        velocity.y = 0; // Reset vertical velocity
        onGround = true; // Player is back on the ground
      }
    }
  }
}
