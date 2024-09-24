/**
 * Called when a key is pressed.
 * It triggers the movement handling for the player based on the key pressed.
 */
void keyPressed() {
    handleMovement(true); // Handle movement when a key is pressed
}

/**
 * Called when a key is released.
 * It stops the movement handling for the player.
 */
void keyReleased() {
    handleMovement(false); // Handle movement when a key is released
}

/**
 * Handles player movement based on key input.
 *
 * @param isPressed A boolean indicating if a key is currently pressed.
 *                  If true, it updates the player's movement state;
 *                  if false, it stops the movement.
 */
void handleMovement(boolean isPressed) {
    switch (key) {
        case 'a': // Check for left movement key
        case 'A':
            player.isLeft = isPressed; // Set the left movement state
            break;

        case 'd': // Check for right movement key
        case 'D':
            player.isRight = isPressed; // Set the right movement state
            break;

        case 'w': // Check for jump key
        case 'W':
            if (isPressed) {
                player.jump(); // Initiate jump if the key is pressed
            }
            break;
            
            // Player respawn on ]
      case ']':
            player = new localPlayer(new PVector(32, 0), displayHeight);
            break;
    }
    player.isMoving = player.isLeft || player.isRight;
}

/**
 * Called when the mouse is pressed.
 * It sets the player's attack state to true, indicating that the player is attacking.
 */
void mousePressed() {
    player.isAttacking = true; // Set the attack state to true
}

/**
 * Called when the mouse is released.
 * It sets the player's attack state to false, indicating that the player has stopped attacking.
 */
void mouseReleased() {
    player.isAttacking = false; // Set the attack state to false
}
