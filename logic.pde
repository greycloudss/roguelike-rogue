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
  int playerTileX = floor(player.htbVec.x / wh);
  int playerTileY = floor(player.htbVec.y / wh);
  
  // Adjusted range for bigger player hitbox, you can adjust this if needed
  int range = 100; // Increase from 2 to 3 to check a slightly larger area

  for (int y = max(0, playerTileY - range); y < min(world.wHeight / wh, playerTileY + range); ++y) {
    for (int x = max(0, playerTileX - range); x < min(world.wWidth / wh, playerTileX + range); ++x) {
      if (world.tiles[x][y] != null && world.tiles[x][y].collision == true) {
        /*
        |*  once in a lifetime opportunity to see me document this extenswively
        |*  so basically we take the middle of the player model and the object to collide with model
        |*  we get the dist between those and then we see if the distance is less than the length from middle to middle
        |*  pretty much what little optimisation ive done so far has been negated by this one function
        |*  it is 3 am while writting so if there are logical errors in my explanation watch the original youtube video explanation of how collisions work
        */
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
}


/*
void collisions(World world, localPlayer player) { 
  //forbidden rectangle of testing
  
  // First, calculate the player's current tile position
  int playerTileX = floor(player.htbVec.x / wh);
  int playerTileY = floor(player.htbVec.y / wh);
  
  // Define a small range around the player to check tiles (instead of checking the entire world)
  int range = 2; // You can adjust this based on the player's size and movement speed

  for (int y = max(0, playerTileY - range); y < min(world.wHeight / wh, playerTileY + range); ++y) { // Loop through a small range of columns
    for (int x = max(0, playerTileX - range); x < min(world.wWidth / wh, playerTileX + range); ++x) { // Loop through a small range of rows
      if (world.tiles[x][y] != null && world.tiles[x][y].collision == true) { // check if tile collides
        
        |*  once in a lifetime opportunity to see me document this extensively
        |*  so basically we take the middle of the player model and the object to collide with model
        |*  we get the dist between those and then we see if the distance is less than the length from middle to middle
        |*  pretty much what little optimisation ive done so far has been negated by this one function
        |*  it is 3 am while writting so if there are logical errors in my explanation watch the original youtube video explanation of how collisions work
        
      
        println("Checking collision at tile: (" + x + ", " + y + ")");
        //x axis dist
        //i sincerelly hope i do not have to explain this because im following a youtube tutorial
        int distx = floor((player.htbVec.x + player.htbWidth / 2) - (x * world.tiles[x][y].size + world.tiles[x][y].size / 2));
        //y axis dist
        //reason why i use size instead of just the global var wh is because i can modify the size without modifying the global var
        int disty = floor((player.htbVec.y + player.htbHeight / 2) - (y * world.tiles[x][y].size + world.tiles[x][y].size / 2));
        
        int combinedHalvesW = floor(player.htbWidth / 2 + world.tiles[x][y].size / 2);
        int combinedHalvesH = floor(player.htbHeight / 2 + world.tiles[x][y].size / 2);
        
        //check for overlap
        if (abs(distx) < combinedHalvesW && abs(disty) < combinedHalvesH) {
          //calculate how much overlap there is
          //the youtube video mentioned this to be simple math so if its not im going to be sad
          int overlapX = combinedHalvesW - abs(distx);
          int overlapY = combinedHalvesH - abs(disty);

          //look for smallest overlap and resolve the collision
          if (overlapX < overlapY) {
            // Resolve X-axis overlap
            if (distx > 0)
              player.pos.x += overlapX; // overlap Left
            else
              player.pos.x -= overlapX; // overlap Right
          } else {
            // Resolve Y-axis overlap
            if (disty > 0)
              player.pos.y += overlapY; // overlap Top
            else
              player.pos.y -= overlapY; // overlap Bot
          }
        }
      } 
    }
  } 
}*/
