class Enemy {
    PVector pos;
    int hp = 50;
    boolean isAlive = true;

    int hitboxWidth = 45;  
    int hitboxHeight = 70; 

    int damageDealt = 0;
    int damageDisplayTimer = 0;
    int hitCooldown = 0;  

    EnemyTextures textures; 

    int currentFrame = 0;
    float frameDuration = 0.1; 
    float animationTimer = 0;

    int spriteWidth = 180;  
    int spriteHeight = 160; 

    float speed = 2; 
    float jumpStrength = -10; 
    boolean facingRight = true; 
    boolean isJumping = false; 
    boolean onGround = true;
    float gravity = 0.5; 
    float verticalSpeed = 0; 

    int state = 0; 
    int stateTimer = 0; 
    int maxStateTimer = 60; 

    Enemy(PVector pos) {
        this.pos = pos;
        this.textures = new EnemyTextures(); 
        state = 0; 
        stateTimer = maxStateTimer; 
    }

    boolean checkHit(PVector attackBoxPos, int attackBoxWidth, int attackBoxHeight) {
        return attackBoxPos.x < pos.x + hitboxWidth &&
               attackBoxPos.x + attackBoxWidth > pos.x &&
               attackBoxPos.y < pos.y + hitboxHeight &&
               attackBoxPos.y + attackBoxHeight > pos.y;
    }

    void hit(int damage) {
        if (isAlive && hitCooldown == 0) {
            hp -= damage;
            damageDealt = damage;
            damageDisplayTimer = 60;
            hitCooldown = 30;

            println("Enemy HP: " + hp);

            if (hp <= 0) {
                isAlive = false;
                die();
            }
        }
    }

    void die() {
        println("Enemy died!");
    }
    
    void jump() {
        if (!onGround) {
            verticalSpeed = -jumpStrength;
            onGround = false;
        }
    }
    
    void land() {
      onGround = true;
    }

  void update(World world) {
    float groundLevel = world.wHeight - hitboxHeight; 

    stateTimer--;
    if (stateTimer <= 0) {
        changeState();
    }

    switch (state) {
        case 0: 
            pos.x += speed;
            if (pos.x < 0 || pos.x > world.wWidth - hitboxWidth) {
                speed *= -1; 
            }
            facingRight = speed > 0;
            break;

        case 1: 

            break;

        case 2: 
            if (!isJumping && pos.y >= groundLevel) {
                verticalSpeed = jumpStrength;
                isJumping = true;
            }

            if (isJumping) {
                verticalSpeed += gravity; 
                pos.y += verticalSpeed; 

                if (world.checkCollision(this)) {
                    pos.y = groundLevel; 
                    verticalSpeed = 0; 
                    isJumping = false; 
                    state = 1; 
                    stateTimer = maxStateTimer; 
                }
            }
            break;
    }

        if (world.checkCollision(this)) {

            if (facingRight) {
                pos.x = pos.x - hitboxWidth; 
            } else {
                pos.x = pos.x + hitboxWidth; 
            }
        }

        animationTimer += 1 / 60.0;
        if (animationTimer >= frameDuration) {
            animationTimer = 0;
            currentFrame++;
            if (isMoving() || isJumping) {
                if (currentFrame >= textures.run.length) {
                    currentFrame = 0; 
                }
            } else {
                if (currentFrame >= textures.idle.length) {
                    currentFrame = 0; 
                }
            }
        }
    }

    void changeState() {
        stateTimer = maxStateTimer;
        if (state == 0) {
            state = 1;  
        } else if (state == 1) {
            state = 2;  
        } else if (state == 2) {
            state = 0;  
        }
    }

    boolean isMoving() {
        return state == 0;
    }

    void draw() {
        if (isAlive) {
            stroke(0, 0, 255);
            fill(155, 125, 20, 155);
            rect(pos.x, pos.y, hitboxWidth, hitboxHeight); 

            PImage currentSprite;
            if (isMoving() || isJumping) {
                currentSprite = textures.run[currentFrame % textures.run.length];
            } else {
                currentSprite = textures.idle[currentFrame % textures.idle.length];
            }

            pushMatrix();
            translate(pos.x + hitboxWidth / 2, pos.y + hitboxHeight - spriteHeight + 35); 

            if (facingRight) {
                image(currentSprite, -spriteWidth / 2, 0, spriteWidth, spriteHeight);
            } else {
                scale(-1, 1); 
                image(currentSprite, -spriteWidth / 2, 0, spriteWidth, spriteHeight);
            }

            popMatrix();

            fill(255, 0, 0);
            rect(pos.x, pos.y - 30, hitboxWidth * (hp / 50.0), 5); 

            if (damageDisplayTimer > 0) {
                fill(255, 255, 0);
                textAlign(CENTER);
                text("-" + damageDealt, pos.x + hitboxWidth / 2, pos.y - 25);
                damageDisplayTimer--;
            }

            if (hitCooldown > 0) {
                hitCooldown--;
            }
        }
    }
}
