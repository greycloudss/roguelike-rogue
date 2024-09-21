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
      
    case ' ':
      player.isDoubleJumping = isMoving;
      break;

  }
  

  player.moving = player.movingLeft || player.movingRight;
}



/*
|********************|
|***   redudant   ***|
|********************|

void parsePlayer() {
  int segmentWidth = pimg.width / 10;
  int segmentHeight = pimg.height / 5;

  for (int y = 0; y < 5; ++y) {
    for (int x = 0; x < 10; ++x) {
      ptxt[y][x] = pimg.get(x * segmentWidth, y * segmentHeight, segmentWidth, segmentHeight);
      ptxt[y][x].resize(int(ptxt[y][x].width * 2), int(ptxt[y][x].height * 2));
    }
  }
}*/
