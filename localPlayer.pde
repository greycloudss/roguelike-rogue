/**
 * Represents the local player in the game.
 * This class handles the player's position, movement, collision detection,
 * damage handling, and animation.
 */
class localPlayer {

    PVector pos;
    int hurtboxWidth = 55;
    int hurtboxHeight = 75;
    PlayerTextures textures;

    int attackBoxWidth = 70;
    int attackBoxHeight = 110;
    PVector attackBoxPos;

    // State variables
    boolean inAir, onGround, isMoving, isJumping, isLeft, isRight, isAlive, isAttacking;

    PVector velocity;

    float speed = 5;
    float jumpForce = 10;
    float gravity = 0.4;
    float groundHeight;
    float maxFallSpeed = 10;

    int spriteWidth = 240;
    int spriteHeight = 240;
    boolean lastDirectionLeft = false;

    int currentFrame = 0;  // Current animation frame
    float frameDuration = 0.1;  // Duration of each frame in the animation
    float animationTimer = 0;  // Timer for frame transitions

    
    int hp = 100;
    int damageDisplayTimer = 0;  // timer for displaying damage taken
    int damageDealt = 0;  // amount of damage to player
    


    int damageCooldown = 60;  // Cooldown period in frames before taking damage again
    int damageCooldownTimer = 0;  // Timer for damage cooldown


    localPlayer(PVector pos, float initialGroundHeight) {
        this.pos = pos;
        this.groundHeight = initialGroundHeight;
        this.textures = new PlayerTextures("textures/NightBorne.png");
        isAlive = true;
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

    void update(ArrayList<Enemy> enemies, ArrayList<Platform> platforms) {
        // Apply gravity when not on the ground
        
        float lowestPlatformY = Float.MAX_VALUE; 
        
        if (!onGround) {
            velocity.y += gravity;
            if (velocity.y > maxFallSpeed) {
                velocity.y = maxFallSpeed; 
            }
        }

        // Handle horizontal movement
        if (isLeft && !isRight) {
            moveLeft();
        } else if (isRight && !isLeft) {
            moveRight();
        } else {
            velocity.x = 0; 
        }

        if (isAlive && hp <= 0) {
          velocity.x = 0;
          velocity.y = 0;
          
        }


        pos.x += velocity.x;
        pos.y += velocity.y;

        // Reset onGround status for new collision checks
        onGround = false; 
        

        // Check for collisions with platforms
        for (Platform platform : platforms) {
            if (checkCollision(platform)) {
                if (velocity.y > 0) { 
                    pos.y = platform.pos.y - hurtboxHeight; 
                    velocity.y = 0; 
                    onGround = true; 
                    break; 
                }
            }
        }

        // Adjust position if falling below ground
        if (!onGround && pos.y + hurtboxHeight >= groundHeight) {
            pos.y = groundHeight - hurtboxHeight; 
            onGround = true; 
            velocity.y = 0;
        }

        // Handle collisions with enemies
        for (Enemy enemy : enemies) {
            if (enemy.checkHit(pos, hurtboxWidth, hurtboxHeight) && enemy.isAlive) {
                takeDamage(enemy.damageDealt); 
            }
        }

        // Update damage cooldown timer
        if (damageCooldownTimer > 0) {
            damageCooldownTimer--; 
        }

        // Update animation frame
        animationTimer += 1 / 60.0; 
        if (animationTimer >= frameDuration) {
            animationTimer = 0;
            updateAnimationFrame();
        }

        // Handle attacking logic
        if (isAttacking && currentFrame == 10) { 
            for (Enemy enemy : enemies) {
                if (enemy.checkHit(attackBoxPos, attackBoxWidth, attackBoxHeight)) {
                    enemy.hit(50); 
                    println("Hit the enemy!");
                }
            }
        }

        drawPlayer();
    }

    /**
     * Reduces the player's health by the specified damage amount.
     * Handles the cooldown before the player can take damage again.
     *
     * @param damage The amount of damage to be taken.
     */
    void takeDamage(int damage) {
        if (hp > 0 && damageCooldownTimer <= 0) { 
            hp -= damage; 
            damageDealt = damage; 
            damageDisplayTimer = 60; 
            damageCooldownTimer = damageCooldown; 
            println("Player HP: " + hp);
        }

        if (hp <= 0) {
            isAlive = false; 
            println("Player died!");
        }
    }

    /**
     * Checks for collision with a given platform.
     *
     * @param platform The platform to check for collision with.
     * @return True if a collision occurs, otherwise false.
     */
    boolean checkCollision(Platform platform) {
        return pos.x < platform.pos.x + platform.width && 
               pos.x + hurtboxWidth > platform.pos.x &&
               pos.y + hurtboxHeight > platform.pos.y &&
               pos.y < platform.pos.y + platform.height;
    }

    /**
     * Updates the current animation frame based on the player's state.
     */
    void updateAnimationFrame() {
        if (hp <= 0) {
          currentFrame++;
          if (textures.death != null && currentFrame >= textures.death.length) {
                isAlive = false;
                currentFrame = 0; 
          }
        } else if (isAttacking) {
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

    /**
     * Moves the player to the left.
     */
    void moveLeft() {
        velocity.x = -speed;
        isLeft = true; 
        isRight = false; 
        isMoving = true; 
        lastDirectionLeft = true; 
    }

    /**
     * Moves the player to the right.
     */
    void moveRight() {
        velocity.x = speed;
        isRight = true; 
        isLeft = false; 
        isMoving = true; 
        lastDirectionLeft = false; 
    }

    /**
     * Initiates a jump if the player is on the ground.
     */
    void jump() {
        if (onGround) { 
            velocity.y = -jumpForce;
            onGround = false;
        }
    }

    /**
     * Marks the player as being on the ground.
     */
    void land() {
        onGround = true;
    }

    /**
     * Draws the player on the screen, including their current animation and health bar.
     */
    void drawPlayer() {
        PImage currentSprite;

        if (hp <= 0 && isAlive) {
          currentSprite = textures.death[currentFrame % textures.death.length];
          velocity = new PVector(0, 0);
        } else if (isAttacking && textures.attack != null) {
            currentSprite = textures.attack[currentFrame % textures.attack.length]; 
        } else if (isMoving && textures.run != null) {
            currentSprite = textures.run[currentFrame % textures.run.length]; 
        } else {
            currentSprite = textures.idle[currentFrame % textures.idle.length]; 
        }

        // Draw hurtbox
        stroke(255, 0, 0); 
        noFill();
        rect(pos.x, pos.y, hurtboxWidth, hurtboxHeight); 

        // Draw attack box if attacking
        if (isAttacking) {
            attackBoxPos = new PVector(lastDirectionLeft ? pos.x - attackBoxWidth : pos.x + hurtboxWidth, 
                                        pos.y + (hurtboxHeight - attackBoxHeight)); 

            if (currentFrame >= textures.attack.length - 3) {
                stroke(0, 255, 0); 
                rect(attackBoxPos.x, attackBoxPos.y, attackBoxWidth, attackBoxHeight);
            }
        }

        // Draw player sprite
        pushMatrix(); 
        translate(pos.x + (hurtboxWidth / 2), pos.y + (hurtboxHeight - spriteHeight) + 50); 

        if (lastDirectionLeft) {
            scale(-1, 1); 
        }

        image(currentSprite, -spriteWidth / 2, 0, spriteWidth, spriteHeight); 
        popMatrix(); 

        // Draw health bar
        fill(255, 0, 0);
        rect(pos.x, pos.y - 30, hurtboxWidth, 5);
        fill(0, 255, 0);
        rect(pos.x, pos.y - 30, hurtboxWidth * (hp / 100.0), 5); 

        // Display damage dealt
        if (damageDisplayTimer > 0) {
            fill(255, 255, 0);
            textAlign(CENTER);
            text("-" + damageDealt, pos.x + hurtboxWidth / 2, pos.y - 25);
            damageDisplayTimer--;
        }
    }

    /**
     * Resets the animation state to the initial frame.
     */
    void resetAnimationState() {
        currentFrame = 0; 
        animationTimer = 0; 
    }

    /**
     * Changes the player's movement and attack state.
     *
     * @param moving True if the player is moving, false otherwise.
     * @param attacking True if the player is attacking, false otherwise.
     */
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
