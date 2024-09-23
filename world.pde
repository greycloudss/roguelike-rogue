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

class World {
    Tile[][] tiles;
    Tile background;
    int wWidth, wHeight;

    World() {
        wWidth = wHeight = 0;
        background = new Tile(textures[430], false, wh);
    }

    World(int wWidth, int wHeight, Tile background) {
        this.wWidth = wWidth;
        this.wHeight = wHeight;
        this.background = background;

        tiles = new Tile[wWidth / wh][wHeight / wh];

        tiles[9][29] = new Tile(textures[28], true, wh);
        tiles[9][28] = new Tile(textures[28], true, wh);
        tiles[9][27] = new Tile(textures[29], false, wh);
    }

    void display() {
        fill(34, 139, 34);
        rect(0, wHeight - 50, wWidth, 50);

        background(14, 12, 18);

        for (int y = 0; y < wHeight / background.size; ++y) {
            for (int x = 0; x < wWidth / background.size; ++x) {
                if (y != wHeight / background.size - 5) {
                    image(background.texture, x * background.size, y * background.size);
                } else {
                    tiles[x][32] = new Tile(textures[242], true, wh);
                }

                if (tiles[x][y] != null) {
                    image(tiles[x][y].texture, x * tiles[x][y].size, y * tiles[x][y].size);
                }
            }
        }
    }

    boolean checkCollision(Enemy enemy) {
        for (int y = 0; y < tiles[0].length; y++) {
            for (int x = 0; x < tiles.length; x++) {
                Tile tile = tiles[x][y];
                if (tile != null && tile.collision) {
                  if (enemy.pos.x < x * tile.size + tile.size &&
                        enemy.pos.x + enemy.hitboxWidth > x * tile.size &&
                        enemy.pos.y < y * tile.size + tile.size &&
                        enemy.pos.y + enemy.hitboxHeight > y * tile.size) {

                        if (enemy.pos.y + enemy.hitboxHeight > y * tile.size) {
                            enemy.pos.y = y * tile.size - enemy.hitboxHeight; 
                            enemy.verticalSpeed = 0; 
                        }
                        println(true);
                        return true;
                    }
                }
            }
        }
        return false; 
    }

    boolean checkCollision(localPlayer player) {
        for (int y = 0; y < tiles[0].length; y++) {
            for (int x = 0; x < tiles.length; x++) {
                Tile tile = tiles[x][y];
                if (tile != null && tile.collision) {
                    if (player.pos.x < x * tile.size + tile.size &&
                        player.pos.x + player.getHurtboxWidth() > x * tile.size &&
                        player.pos.y < y * tile.size + tile.size &&
                        player.pos.y + player.getHurtboxHeight() > y * tile.size) {
                        return true; 
                    }
                }
            }
        }
        return false; 
    }
}
