class localPlayer {
    PVector pos;
    int hurtboxWidth = 55;  
    int hurtboxHeight = 75;  
    PlayerTextures textures;

    int attackBoxWidth = 70; 
    int attackBoxHeight = 110; 
    PVector attackBoxPos; 

    boolean inAir, onGround, isMoving, isJumping, isLeft, isRight, isAlive, isAttacking;

    PVector velocity;

    float speed = 5; 
    float jumpForce = 10;
    float gravity = 0.4; 
    float groundHeight;

    int spriteWidth = 240; 
    int spriteHeight = 240; 
    boolean lastDirectionLeft = false;

    int currentFrame = 0;
    float frameDuration = 0.1; 
    float animationTimer = 0;

    localPlayer(PVector pos, float groundHeight) {
        this.pos = pos;
        this.groundHeight = groundHeight;
        this.textures = new PlayerTextures("textures/NightBorne.png");
        inAir = isJumping = false;
        onGround = true;
        isLeft = isRight = false;
        isMoving = false;
        isAttacking = false;
        velocity = new PVector(0, 0);
    }
    int getHurtboxWidth() {
        return hurtboxWidth;
    }

    int getHurtboxHeight() {
        return hurtboxHeight;
    }
void update(ArrayList<Enemy> enemies) {
    if (!onGround) {
        velocity.y += gravity;
    }

    if (isLeft && !isRight) {
        moveLeft();
    } else if (isRight && !isLeft) {
        moveRight();
    } else {
        velocity.x = 0; 
    }

    pos.x += velocity.x;
    pos.y += velocity.y;

    if (pos.y + hurtboxHeight > groundHeight) {
        pos.y = groundHeight - hurtboxHeight; 
        onGround = true;
        velocity.y = 0;
    } else {
        onGround = false; 
    }

    animationTimer += 1 / 60.0; 
    if (animationTimer >= frameDuration) {
        animationTimer = 0;
        updateAnimationFrame();
    }

    if (isAttacking && currentFrame == 10) { 
        for (Enemy enemy : enemies) {
            if (enemy.checkHit(attackBoxPos, attackBoxWidth, attackBoxHeight)) {
                enemy.hit(10); 
                println("Hit the enemy!");
            }
        }
    }

    drawPlayer();
}

    void updateAnimationFrame() {
        if (isAttacking) {
            currentFrame++;
            if (textures.attack != null && currentFrame >= textures.attack.length) {
                isAttacking = false; 
                currentFrame = 0; 
            }
        } else if (isMoving) {
            currentFrame++;
            if (textures.run != null && currentFrame >= textures.run.length) {
                currentFrame = 0; 
            }
        } else {
            currentFrame++;
            if (textures.idle != null && currentFrame >= textures.idle.length) {
                currentFrame = 0; 
            }
        }
    }

    void moveLeft() {
        velocity.x = -speed;
        isLeft = true; 
        isRight = false; 
        isMoving = true; 
        lastDirectionLeft = true; 
    }

    void moveRight() {
        velocity.x = speed;
        isRight = true; 
        isLeft = false; 
        isMoving = true; 
        lastDirectionLeft = false; 
    }

    void jump() {
        if (onGround) {
            velocity.y = -jumpForce;
            onGround = false;
        }
    }

    void land() {
        onGround = true;
    }

    void drawPlayer() {
        PImage currentSprite;

        if (isAttacking && textures.attack != null) {
            currentSprite = textures.attack[currentFrame % textures.attack.length]; 
        } else if (isMoving && textures.run != null) {
            currentSprite = textures.run[currentFrame % textures.run.length]; 
        } else {
            currentSprite = textures.idle[currentFrame % textures.idle.length]; 
        }

        stroke(255, 0, 0); 
        noFill();
        rect(pos.x, pos.y, hurtboxWidth, hurtboxHeight); 

        if (isAttacking) {
            attackBoxPos = new PVector(lastDirectionLeft ? pos.x - attackBoxWidth : pos.x + hurtboxWidth, 
                                        pos.y + (hurtboxHeight - attackBoxHeight)); 

            if (currentFrame >= textures.attack.length - 3) {
                stroke(0, 255, 0); 
                rect(attackBoxPos.x, attackBoxPos.y, attackBoxWidth, attackBoxHeight);
            }
        }

        pushMatrix(); 
        translate(pos.x + (hurtboxWidth / 2), pos.y + (hurtboxHeight - spriteHeight) + 50); 

        if (lastDirectionLeft) {
            scale(-1, 1); 
        }

        image(currentSprite, -spriteWidth / 2, 0, spriteWidth, spriteHeight); 
        popMatrix(); 
    }

    void resetAnimationState() {
        currentFrame = 0; 
        animationTimer = 0; 
    }

    void changeState(boolean moving, boolean attacking) {
        if (moving) {
            if (!isMoving) {
                isMoving = true;
                resetAnimationState();
            }
        } else {
            isMoving = false;
        }

        if (attacking) {
            if (!isAttacking) {
                isAttacking = true;
                resetAnimationState();
            }
        } else {
            isAttacking = false;
        }
    }
}
