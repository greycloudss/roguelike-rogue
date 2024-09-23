void parser() {
  int tilesPerRow = 1024 / wh;
  if (img == null) {
    img = loadImage("textures/texturePack.png"); 
  }
  for (int y = 0; y < tilesPerRow; y++) {
    for (int x = 0; x < tilesPerRow; x++) {
      int index = y * tilesPerRow + x;
      textures[index] = img.get(x * wh, y * wh, wh, wh);
    }
  }
}

void showTexturesIds() {
  var index = 0;
  fill(240);
  int tilesPerRow = 1024 / wh;
  for (int y = 0; y < tilesPerRow; y++) {
     for (int x = 0; x < tilesPerRow; y++) {
        index = y * tilesPerRow + x; // how we get the textures
        textures[index] = img.get(x * wh, y * wh, wh, wh);
        image(textures[index], x * wh, y * wh);
        text(index, x*wh, y*wh);
     }
  }
  
  for(int i = 0; i < width/wh; i++ ) {
   line(i*wh, 0, i*wh, height);
   line(0, i*wh, width, i*wh);
  }
}

void collisions(World world, localPlayer player) {
    boolean wasOnGround = player.onGround;
    player.onGround = false;
    
    //fill(255);
    //rect(player.pos.x, player.pos.y, player.pWidth, player.pHeight);
    
    //player.drawHurtbox();
    
    float offsetY = (player.pHeight - player.htbHeight) * 0.5 - 30; //self explanatory why i did 30;//////////////////////////////////////////////////////////////////////////////////////////////////////
    float offsetX = (player.pWidth - player.htbWidth) * 0.5;//////////////////////////////////////////////////////////////////////////////////////////////////////
    
    float tileSize = wh;
    float playerTop = player.pos.y;
    float playerBottom = player.pos.y + player.pHeight;
    float playerLeft = player.pos.x + offsetX;//////////////////////////////////////////////////////////////////////////////////////////////////////
    float playerRight = player.pos.x + player.pWidth - offsetX;//////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // Vertical collision
    int tileYTop = (int) (playerTop / tileSize);
    int tileYBottom = (int) (playerBottom / tileSize);
    int tileXStart = (int) (playerLeft / tileSize);
    int tileXEnd = (int) (playerRight / tileSize);

    for (int y = tileYTop; y <= tileYBottom; y++) {
        for (int x = tileXStart; x <= tileXEnd; x++) {
            if (x >= 0 && x < world.wWidth / tileSize && y >= 0 && y < world.wHeight / tileSize) {
                Tile currentTile = world.tiles[x][y];
                if (currentTile != null && currentTile.collision) {
                    if (player.velocity.y > 0 && playerBottom > y * tileSize ) {
                        player.pos.y = y * tileSize - player.pHeight + offsetY;//////////////////////////////////////////////////////////////////////////////////////////////////////
                        player.velocity.y = 0;
                        player.onGround = true;
                    } else if (player.velocity.y < 0 && playerTop < (y + 1) * tileSize) {
                        player.pos.y = (y + 1) * tileSize - offsetY * 2;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        player.velocity.y = 0;
                    }
                }
            }
        }
    }
    
    // Horizontal collision
    tileYTop = (int) (player.pos.y / tileSize);
    tileYBottom = (int) ((player.pos.y + player.pHeight) / tileSize);
    tileXStart = (int) (playerLeft / tileSize);
    tileXEnd = (int) (playerRight / tileSize);
    
    for (int x = tileXStart; x <= tileXEnd; x++) {
        for (int y = tileYTop; y <= tileYBottom; y++) {
            if (x >= 0 && x < world.wWidth / tileSize && y >= 0 && y < world.wHeight / tileSize) {
                Tile currentTile = world.tiles[x][y];
                if (currentTile != null && currentTile.collision) {
                    if (player.velocity.x > 0 && playerRight > x * tileSize) {
                        player.pos.x = x * tileSize - player.pWidth - offsetX;//////////////////////////////////////////////////////////////////////////////////////////////////////
                        player.velocity.x = 0;
                    } else if (player.velocity.x < 0 && playerLeft < (x + 1) * tileSize) {
                        player.pos.x = (x + 1) * tileSize + offsetX; //////////////////////////////////////////////////////////////////////////////////////////////////////
                        player.velocity.x = 0;
                    }
                }
            }
        }
    }
    
    // Update player states based on collision results
    if (!wasOnGround && player.onGround) {
        player.isJumping = false;
        player.isDoubleJumping = false;
    }
    player.isFalling = !player.onGround && player.velocity.y > 0;
}
