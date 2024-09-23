//---------------------------------------------------> world generation <---------------------------------------------------\\



class Tile {
  int size;
  boolean collision;
  PImage texture;
  
  Tile() {
    collision = false;
    texture = null;
  }
  
  Tile(PImage texture, boolean collision, int size) {
    this.collision = collision;
    this.texture = texture;
    this.size = size;
  }
}

class World extends Tile {
  Tile[][] tiles;
  Tile background;
  int wWidth, wHeight;

  World() {
    wWidth = wHeight = 0;
    background = new Tile(textures[430], false, wh); // Background texture initialization
  }

  World(int wWidth, int wHeight, Tile background) {
    this.wWidth = wWidth;
    this.wHeight = wHeight;
    this.background = background;
    
    tiles = new Tile[wWidth / wh][wHeight / wh]; // Initialize the tile array

    // Example of initial tiles setup
    tiles[9][29] = new Tile(textures[28], true, 32);
    tiles[9][28] = new Tile(textures[28], true, 32);
    tiles[9][27] = new Tile(textures[29], false, 32);
    tiles[10][26] = new Tile(textures[28], true, 32);
    tiles[10][34] = new Tile(textures[28], true, 32);
  }
  
  void display() {
    fill(34, 139, 34); // Ground fill color
    rect(0, wHeight - 50, wWidth, 50); // Ground rectangle

    background(14, 12, 18); // Background fill color

    // Iterate over the tiles array to draw the background and any tiles
    for (int y = 0; y < wHeight / background.size; ++y) {
      for (int x = 0; x < wWidth / background.size; ++x) {
        // Draw the background texture
        if (y != wHeight / background.size - 5) {
          image(background.texture, x * background.size, y * background.size);
        } else
          tiles[x][32] = new Tile(textures[242], true, wh); // Ground tiles at a specific height
        

        // Draw any existing tiles
        if (tiles[x][y] != null) {
          image(tiles[x][y].texture, x * tiles[x][y].size, y * tiles[x][y].size);
        }
      }
    }
  }
}
