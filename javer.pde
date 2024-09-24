import java.util.ArrayList; // Importing the ArrayList class for dynamic arrays

PImage img; // Image for the texture pack

World world; // The game world
int wh = 32; // Width and height of tiles in the world
int yZero = displayHeight - 180; // Y-coordinate for positioning

PImage[] textures = new PImage[(1024 / wh) * (1024 / wh) + 1]; // Array for holding tile textures

localPlayer player; // The player character
ArrayList<Enemy> enemies; // List of enemies in the game

/**
 * Setup the game environment.
 * Initializes the window, sets the frame rate, loads textures, and creates the game world and player.
 * Parses platforms and spawns enemies based on the map configuration.
 */
void setup() {
    frameRate(240); // Set the frame rate to 240 FPS
    windowTitle("RogueLike Rogue"); // Set the window title
    fullScreen(); // Start the game in full screen

    // Load texture pack image if not already loaded
    if (img == null)
        img = loadImage("textures/texturePack.png");

    size(displayWidth, displayHeight);

    parser();
    world = new World(4096 * 2, 4096, new Tile(textures[430], false, wh));

    player = new localPlayer(new PVector(32, 0), displayHeight + 2000);

    enemies = new ArrayList<Enemy>();

    
    String[] lines = loadStrings("maps/map1.csv");

    
    for (int i = 1; i < lines.length; i++) {
        String[] cols = lines[i].split(","); // Split the line into columns
        if (cols.length == 4) { // Ensure there are enough columns
            float x = float(cols[0]);
            float y = float(cols[1]);
            float width = float(cols[2]); // Parse width
            float height = float(cols[3]); // Parse height

            
            if (i == 3) {
                enemies.add(new Enemy(new PVector(x + width / 2 - 22.5, y - 65), x, x + width));
            } else if (i == 4) {
                enemies.add(new Enemy(new PVector(x + width / 2 - 22.5, y - 70), x, x + width));
            }
        }
    }

    smooth(0);
}


void draw() {
    System.gc();

    float offsetX = constrain(-player.pos.x + width / 2, width - world.wWidth, 0);
    float offsetY = constrain(-player.pos.y + height / 2, height - world.wHeight, 0);
    translate(offsetX, offsetY);

    world.display();
    world.drawPlatforms();
    
    if (player.isAlive) {
      noCursor();
      player.update(enemies, world.platforms);
      player.drawPlayer();
    }
    
    for (Enemy enemy : enemies) {
        enemy.update(world, player);
        enemy.draw();
    }
}
