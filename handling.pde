//---------------------------------------------------> player handling <---------------------------------------------------\\


void keyPressed() {
  switch(key) {
    case 'a':
        player.moving = true;
        player.movingLeft = true;
      break;
    case 'd':
        player.moving = true;
        player.movingRight = true;
      break;
    case 'w':
        player.moving = true;
        player.isJumping = true;
      break;
  }
  
  
  // temp fix
  switch(key) {
    case 'A':
        player.moving = true;
        player.movingLeft = true;
      break;
    case 'D':
        player.moving = true;
        player.movingRight = true;
      break;
    case 'W':
        player.moving = true;
        player.isJumping = true;
      break;
  }
}

void keyReleased() {
  switch(key) {
    case 'a':
        player.moving = false;
        player.movingLeft = false;
      break;
    case 'd':
        player.moving = false;
        player.movingRight = false;
      break;
  }
    // temp fix
    switch(key) {
    case 'A':
        player.moving = false;
        player.movingLeft = false;
      break;
    case 'D':
        player.moving = false;
        player.movingRight = false;
      break;
  }
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
