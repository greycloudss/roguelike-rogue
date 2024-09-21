//---------------------------------------------------> world generation <---------------------------------------------------\\




class Tile {
  int size;
  boolean collision;
  PImage texture;
  
  Tile() {
  collision = false;
  texture = null;
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
    background = new Tile(textures[430], false, wh);

  }
  
  World(int wWidth, int wHeight, Tile background) {
    background(14, 12, 18);
    this.wWidth = wWidth;
    this.wHeight = wHeight;
    
    tiles = new Tile[wWidth / wh][wHeight / wh];
    this.background = background;
    
    //colTiles = new boolean[wWidth / wh][wHeight / wh];
    
    tiles[9][30] = new Tile(textures[28], true, 32);
    tiles[9][31] = new Tile(textures[29], false, 32);
    tiles[10][30] = new Tile(textures[60], false, 32);
    tiles[10][31] = new Tile(textures[61], false, 32);
    
    
    }
  
  void display() {
    fill(34, 139, 34);
    rect(0, wHeight - 50, wWidth, 50);

    background(14, 12, 18);
    
    for (int y = 0; y < wHeight / background.size; ++y) {
      for(int x = 0; x < wWidth / background.size; ++x) {
        if (y != wHeight / background.size - 5)
          image(background.texture, x * background.size, y * background.size);
        else
          tiles[x][32] = new Tile(textures[500], true, wh);
          
        if (tiles[x][y] != null) {
            image(tiles[x][y].texture, x * tiles[x][y].size, y * tiles[x][y].size);
        }
        
        
      }
    } // death sentence for this amount of indentation :fire:
  }
}
