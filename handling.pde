void keyPressed() {
  handleMovement(true);
}

void keyReleased() {
  handleMovement(false);
}

void handleMovement(boolean isPressed) {
  switch (key) {
    case 'a':
    case 'A':
      player.movingLeft = isPressed;
      break;
    
    case 'd':
    case 'D':
      player.movingRight = isPressed;
      break;
        
    case 'w':
    case 'W':
      if (isPressed) {
        player.jump();  // Call jump method when 'W' is pressed
      }
      break;
  }
  
  // Update the player's moving state
  player.moving = player.movingLeft || player.movingRight;
}
