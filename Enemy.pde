/**
 * Represents an enemy character in the game.
 * The enemy has properties such as position, health points, and states for animations.
 * It can move, attack the player, and respond to damage.
 */
class Enemy {
    PVector pos;                // Position of the enemy
    int hp = 50;                // Health points of the enemy
    boolean isAlive = true;     // Indicates if the enemy is alive

    int hurtboxWidth = 45;      // Width of the enemy's hurtbox
    int hurtboxHeight = 70;     // Height of the enemy's hurtbox

    int damageDealt = 10;       // Amount of damage the enemy can deal
    int damageDisplayTimer = 0; // Timer for displaying damage dealt to the player
    int hitCooldown = 0;        // Cooldown timer for taking damage
    int attackCooldown = 0;     // Cooldown timer for attacking

    EnemyTextures textures;      // Textures associated with the enemy

    int currentFrame = 0;       // Current frame for animation
    float frameDuration = 0.1;   // Duration of each frame in the animation
    float animationTimer = 0;    // Timer for managing animation frames

    int spriteWidth = 180;      // Width of the enemy sprite
    int spriteHeight = 160;     // Height of the enemy sprite

    float speed = 2;            // Movement speed of the enemy
    boolean facingRight = true;  // Direction the enemy is facing

    int state = 0;              // Current state of the enemy (0 = idle/patrolling, 1 = attacking)
    int stateTimer = 0;         // Timer for managing state changes
    int maxStateTimer = 60;     // Maximum duration for each state

    float platformStartX;       // Starting X position for patrolling
    float platformEndX;         // Ending X position for patrolling

    /**
     * Constructor for the Enemy class.
     * Initializes the enemy's position, platform boundaries, and loads the associated textures.
     *
     * @param pos The initial position of the enemy.
     * @param platformStartX The starting X position for the enemy's patrol.
     * @param platformEndX The ending X position for the enemy's patrol.
     */
    Enemy(PVector pos, float platformStartX, float platformEndX) {
        this.pos = pos;
        this.textures = new EnemyTextures();
        this.platformStartX = platformStartX;
        this.platformEndX = platformEndX;
        state = 0;  // Set initial state to idle/patrolling
        stateTimer = maxStateTimer; // Set initial state timer
    }

    /**
     * Checks if the enemy has been hit by an attack.
     *
     * @param attackBoxPos The position of the attack box.
     * @param attackBoxWidth The width of the attack box.
     * @param attackBoxHeight The height of the attack box.
     * @return True if the enemy was hit, false otherwise.
     */
    boolean checkHit(PVector attackBoxPos, int attackBoxWidth, int attackBoxHeight) {
        return attackBoxPos.x < pos.x + hurtboxWidth &&
               attackBoxPos.x + attackBoxWidth > pos.x &&
               attackBoxPos.y < pos.y + hurtboxHeight &&
               attackBoxPos.y + attackBoxHeight > pos.y;
    }

    /**
     * Inflicts damage to the enemy and updates its health.
     * If health drops to zero or below, the enemy is marked as dead.
     *
     * @param damage The amount of damage to inflict.
     */
    void hit(int damage) {
        if (isAlive && hitCooldown == 0) {
            hp -= damage;
            damageDisplayTimer = 60;
            hitCooldown = 30; // Start cooldown after taking damage

            println("Enemy HP: " + hp);

            if (hp <= 0) {
                isAlive = false; // Mark enemy as dead
                die(); // Call the die method
            }
        }
    }

    /**
     * Handles the enemy's death, performing any necessary cleanup or effects.
     */
    void die() {
        println("Enemy died!"); // Print death message
    }

    /**
     * Updates the enemy's position, state, and animations based on the player's actions and proximity.
     *
     * @param world The world in which the enemy resides.
     * @param player The player character to check for interactions.
     */
    void update(World world, localPlayer player) {
        if (!isAlive) return; // Don't update if the enemy is dead

        // Check distance to player
        float distanceToPlayer = PVector.dist(pos, player.pos);
        boolean isInAttackRange = distanceToPlayer < 200; // Attack range

        // Movement logic
        if (isInAttackRange) {
            // Determine the direction towards the player
            if (pos.x < player.pos.x && pos.x + hurtboxWidth < player.pos.x) {
                pos.x += speed; // Move towards the player
                facingRight = true; // Update facing direction
            } else if (pos.x > player.pos.x && pos.x > player.pos.x + player.hurtboxWidth) {
                pos.x -= speed; // Move away from the player
                facingRight = false; // Update facing direction
            }

            // Check for attacking if within hitbox
            if (distanceToPlayer < player.hurtboxWidth && attackCooldown <= 0) {
                attack(player);
            }
        } else {
            // Patrol logic
            if (facingRight) {
                pos.x += speed;
                if (pos.x > platformEndX - hurtboxWidth) {
                    facingRight = false; // Change direction
                }
            } else {
                pos.x -= speed;
                if (pos.x < platformStartX) {
                    facingRight = true; // Change direction
                }
            }
        }

        // Update attack cooldown
        if (attackCooldown > 0) {
            attackCooldown--;
        }

        // Update animations
        animationTimer += 1 / 60.0; // Increment animation timer
        if (animationTimer >= frameDuration) {
            animationTimer = 0;
            currentFrame++;
            if (state == 1) {
                // Attack state
                if (currentFrame >= textures.attack1.length) {
                    currentFrame = 0; // Reset to first frame of attack animation
                    state = 0; // Return to idle/patrolling state after attack
                }
            } else {
                // Idle/Run state
                if (isMoving()) {
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
    }

    /**
     * Performs an attack on the player if the enemy is in the correct state.
     * The attack deals damage to the player.
     *
     * @param player The player character to attack.
     */
    void attack(localPlayer player) {
        if (state == 0) { // Only attack if in idle/patrolling state
            state = 1; // Switch to attack state
            player.takeDamage(damageDealt); // Inflict damage to the player
            println("Enemy attacked player! Damage dealt: " + damageDealt);
            attackCooldown = 60; // Set cooldown for the next attack
        }
    }

    /**
     * Checks if the enemy is currently moving.
     *
     * @return True if the enemy is moving, false otherwise.
     */
    boolean isMoving() {
        return state == 0; // Moving state corresponds to idle/patrolling
    }

    /**
     * Draws the enemy on the screen.
     * Displays the enemy's hurtbox, current animation frame, and health bar.
     */
    void draw() {
        if (isAlive) {
            stroke(0, 0, 255);
            fill(155, 125, 20, 155);
            rect(pos.x, pos.y, hurtboxWidth, hurtboxHeight); // Draw the hurtbox

            PImage currentSprite;
            if (state == 1) {
                // Use attack animation
                currentSprite = textures.attack1[currentFrame % textures.attack1.length];
            } else {
                // Use idle or run animation
                currentSprite = isMoving() ? textures.run[currentFrame % textures.run.length] : textures.idle[currentFrame % textures.idle.length];
            }

            // Push matrix to isolate transformations
            pushMatrix();
            translate(pos.x + hurtboxWidth / 2, pos.y + hurtboxHeight - spriteHeight + 35); 

            // Flip texture if not facing right
            if (facingRight) {
                image(currentSprite, -spriteWidth / 2, 0, spriteWidth, spriteHeight);
            } else {
                // Flip only the texture, keeping the position intact
                scale(-1, 1); 
                image(currentSprite, -spriteWidth / 2, 0, spriteWidth, spriteHeight);
            }

            popMatrix();

            // Draw health bar
            fill(255, 0, 0);
            rect(pos.x, pos.y - 30, hurtboxWidth * (hp / 50.0), 5); 

            // Display damage taken
            if (damageDisplayTimer > 0) {
                fill(255, 255, 0);
                textAlign(CENTER);
                text("-" + damageDealt, pos.x + hurtboxWidth / 2, pos.y - 25); // Hardcoded dmg thing
                damageDisplayTimer--;
            }

            // Update hit cooldown timer
            if (hitCooldown > 0) {
                hitCooldown--;
            }
        }
    }
}
