class localPlayer {
  PlayerTextures ptextures;
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
  boolean isJumping;
  boolean isDoubleJumping;
  boolean isFalling;  // Added here

  int health;
  boolean movingLeft;
  boolean movingRight;
  boolean moving;
  boolean strike;
  boolean alive;
  boolean facingLeft;
  boolean attackActive;
  boolean isAttacking;

  PImage[] curState;

  float htbWidth, htbHeight;
  PVector htbVec = new PVector();
  PVector velocity = new PVector();

  localPlayer() {
    ptextures = new PlayerTextures(pPath);
    pos = new PVector(0, 300);
    pWidth *= 5;
    pHeight *= 5;

    // Initialize states
    movingRight = false;
    movingLeft = false;
    moving = false;
    isJumping = false;
    isDoubleJumping = false;
    isFalling = false;  // Initialize to false
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

    // Set the current state based on actions
    if (isAttacking) {
      curState = ptextures.attack;
      attackActive = (curFrame >= 9 && curFrame < 13);
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
      // Handle attack state
      if (mousePressed && mouseButton == LEFT) {
        if (!isAttacking) {
          isAttacking = true;
          strike = true;
        }
      } else if (isAttacking) {
        isAttacking = false;
        strike = false;
      }

      // Handle horizontal movement
      float horizontalMovement = 0;
      if (moving && !strike) {
        if (movingRight) {
          horizontalMovement = speed;
          facingLeft = false;
        }
        if (movingLeft) {
          horizontalMovement = -speed;
          facingLeft = true;
        }
      }

      // Apply horizontal movement
      pos.x += horizontalMovement;

      // Apply vertical movement
      applyVerticalMovement();

      // Check collisions
      collisions(world, this);

      // Constrain position to world boundaries
      pos.x = constrain(pos.x, -90, world.wWidth);
      pos.y = constrain(pos.y, 0, world.wHeight);

      // Update character display
      displayChar();
    }
  }

  void applyVerticalMovement() {
    // Apply gravity if not on the ground
    if (!onGround) {
      velocity.y += gravity;
    } else {
      velocity.y = 0; // Reset vertical velocity when on ground
    }

    // Jumping logic
    if (isJumping) {
      velocity.y = -jumpForce;  // Set upward velocity
      onGround = false; // Reset onGround flag
      isJumping = false; // Reset jump state
    }

    // Update vertical position
    pos.y += velocity.y;

    // Update falling state
    isFalling = !onGround && velocity.y > 0;  // Correctly set isFalling
  }

  void jump() {
    if (onGround) {
      isJumping = true;
    } else if (!isDoubleJumping) {
      // Enable double jump
      isJumping = true;
      isDoubleJumping = true;
    }
  }

  void land() {
    onGround = true; // Called when the player collides with the ground
    isDoubleJumping = false; // Reset double jump when landing
  }
}
