//---------------------------------------------------> player handling <---------------------------------------------------\\

void keyPressed() {
  handleMovement(true);
}

void keyReleased() {
  handleMovement(false);
}

void handleMovement(boolean isMoving) {
  switch (key) {
    case 'a':
    case 'A':
      player.movingLeft = isMoving;
      if (isMoving) player.moving = true; 
      break;
      
    
    case 'd':
    case 'D':
      player.movingRight = isMoving;
      if (isMoving) player.moving = true;  
      break;
        
    case 'w':
    case 'W':
      player.isJumping = isMoving; 
      break;
      


  }
  

  player.moving = player.movingLeft || player.movingRight;
}
