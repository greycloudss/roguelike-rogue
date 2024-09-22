//---------------------------------------------------> behind the scenes logic <---------------------------------------------------\\



void parser() {
  int tilesPerRow = 1024 / wh;
  int index = 0;
  if (img == null) {
    img = loadImage("textures/texturePack.png"); 
  }
  for (int y = 0; y < tilesPerRow; ++y) {
    for (int x = 0; x < tilesPerRow; ++x) {
      index = y * tilesPerRow + x;
      textures[index] = img.get(x * wh, y * wh, wh, wh);
    }
  }
}

//boolean hasConfig() {
  //File file = new File(userCFG);
  //return file.exists() ? true : false;
//}

void showTexturesIds() {
  var index = 0;
  fill(0, 0, 0);
  for (int y = 0; y < 1024 /wh; ++y) {
     for (int x = 0; x < 1024 / wh; ++x) {
        index = y * wh + x; // how we get the textures
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
    // initialize grounded flag
    boolean grounded = false;
    
    //everywhere you see this: (player.pHeight - player.htbHeight) * 0.5
    //thats the difference between the sprites 
    
    // tile size and player bounding box
    float tileSize = wh;
    float playerBottom = player.pos.y + player.pHeight - (player.pHeight - player.htbHeight) * 0.5;
    float playerLeft = player.pos.x;
    float playerRight = player.pos.x + player.pWidth;

    //calculate tile range for checking around the player
    int tileXStart = (int) (playerLeft / tileSize);
    int tileXEnd = (int) (playerRight / tileSize);
    int tileYBelow = (int) ((playerBottom + 1) / tileSize); // check the tile directly below player's feet

    for (int x = tileXStart; x <= tileXEnd; x++) {
        if (x >= 0 && x < world.wWidth / tileSize && tileYBelow >= 0 && tileYBelow < world.wHeight / tileSize) {
            Tile currentTile = world.tiles[x][tileYBelow];
            
            // Check if this tile is collidable
            if (currentTile != null && currentTile.collision) {
                // Calculate the top of the tile
                float tileTop = tileYBelow * tileSize;

                // check if players feet are at or below the top of this tile
                if (playerBottom >= tileTop - (player.pHeight - player.htbHeight) * 0.5) {
                    grounded = true;
                    player.pos.y = tileTop - player.pHeight + (player.pHeight - player.htbHeight) * 0.5; // snap the player to the top of the tile
                    player.velocity.y = 0; // reset vertical velocity

                    break;  // stop checking other tiles once grounded
                }
            }
        }
    }

    ///if the player is not grounded apply gravity
    if (!grounded) {
        player.velocity.y += player.gravity;
        player.pos.y += player.velocity.y;
    }


    // dynamic y offset calculation for rendering purposes
    float yOffset = player.htbVec.y + player.pos.y - (player.pHeight - player.htbHeight) * 0.5;
}
/*
void collisions(World world, localPlayer player) {
  int playerTileX = floor(player.htbVec.x / wh);
  int playerTileY = floor(player.htbVec.y / wh);
  int range = 15;
  
  float pxMid = player.htbVec.x + player.htbWidth * 0.5; //since computers suck at division we do multiplication
  float pyMid = player.htbVec.y + player.htbHeight * 0.5;
  
  
  float tolerance = 0.1f;
  
  for (int y = max(0, playerTileY - range); y < min(world.wHeight / wh, playerTileY + range); ++y) {
    for (int x = max(0, playerTileX - range); x < min(world.wWidth / wh, playerTileX + range); ++x) {
      if (world.tiles[x][y] != null && world.tiles[x][y].collision == true) {
      
        float tilexMid = x * world.tiles[x][y].size + world.tiles[x][y].size * 0.5;
        float tileyMid = y * world.tiles[x][y].size + world.tiles[x][y].size * 0.5;
      
        float combinedHalvesX = (player.htbWidth + world.tiles[x][y].size) * 0.5;
        float combinedHalvesY = (player.htbHeight + world.tiles[x][y].size) * 0.5;
      
      
        float distX = abs(pxMid - tilexMid);
        float distY = abs(pyMid - tileyMid) ;
      
      if (distX <= combinedHalvesX && distY <= combinedHalvesY) {
          float overlapX = combinedHalvesX - distX;
          float overlapY = combinedHalvesY - distY;
          if (overlapY > overlapX) {
            if (pyMid > tileyMid) {

              player.pos.y -= overlapY + tolerance;

            } else {
              player.pos.y += overlapY + tolerance;
            }
          } else {
            if (pxMid > tilexMid)
              player.pos.x += overlapX + tolerance;
            else {
              player.pos.x -= overlapY + tolerance;
            }
          }

        //if (abs(player.pos.y - player.pHeight  - tolerance) < world.tiles[x][y].size * y)
          //player.pos.y = world.tiles[x][y].size * y + player.htbHeight * 10;
        }
        
      }
    }
  }
}



*/

/*
void collisions(World world, localPlayer player) { 
  int playerTileX = floor(player.htbVec.x / wh);
  int playerTileY = floor(player.htbVec.y / wh);
  
  // Adjusted range, you can adjust this if needed
  int range = 100; // Increase from 2 to 3 to check a slightly larger area

  for (int y = max(0, playerTileY - range); y < min(world.wHeight / wh, playerTileY + range); ++y) {
    for (int x = max(0, playerTileX - range); x < min(world.wWidth / wh, playerTileX + range); ++x) {
      if (world.tiles[x][y] != null && world.tiles[x][y].collision == true) {
        
        |*  once in a lifetime opportunity to see me document this extensively
        |*  so basically we take the middle of the player model and the object to collide with model
        |*  we get the dist between those and then we see if the distance is less than the length from middle to middle
        |*  pretty much what little optimisation ive done so far has been negated by this one function
        |*  it is 3 am while writting so if there are logical errors in my explanation watch the original youtube video explanation of how collisions work
        
        int distx = floor((player.htbVec.x + player.htbWidth / 2) - (x * world.tiles[x][y].size + world.tiles[x][y].size / 2));
        int disty = floor((player.htbVec.y + player.htbHeight / 2) - (y * world.tiles[x][y].size + world.tiles[x][y].size / 2));

        int combinedHalvesW = floor(player.htbWidth / 2 + world.tiles[x][y].size / 2);
        int combinedHalvesH = floor(player.htbHeight / 2 + world.tiles[x][y].size / 2);

        // Check for overlap
        if (abs(distx) < combinedHalvesW && abs(disty) < combinedHalvesH) {
          int overlapX = combinedHalvesW - abs(distx);
          int overlapY = combinedHalvesH - abs(disty);

          if (overlapX < overlapY) {
            if (distx > 0)
              player.pos.x += overlapX;
            else
              player.pos.x -= overlapX;
          } else {
            if (disty > 0) {
              player.pos.y += overlapY; // Move up to prevent falling
              player.isFalling = false; // Stop falling when colliding with the ground
            } else {
              player.pos.y -= overlapY; // Stop falling below ground
              player.isFalling = false; // Ensure falling stops
            }
          }
        }
      } 
    }
  }
}*/
