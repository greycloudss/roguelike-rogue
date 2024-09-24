import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

/**
 * Represents a tile in the game world, which can have a texture and collision properties.
 */
class Tile {
    int size; // The size of the tile (width and height)
    boolean collision; // Indicates whether the tile has collision properties
    PImage texture; // The texture image associated with the tile

    /**
     * Default constructor that initializes the tile with no collision and no texture.
     */
    Tile() {
        collision = false; // No collision by default
        texture = null; // No texture by default
    }

    /**
     * Constructs a Tile with specified texture, collision status, and size.
     *
     * @param texture The texture image for the tile.
     * @param collision Indicates if the tile has collision properties.
     * @param size The size of the tile (width and height).
     */
    Tile(PImage texture, boolean collision, int size) {
        this.collision = collision; // Set collision property
        this.texture = texture; // Set the tile texture
        this.size = size; // Set tile size
    }
}

/**
 * Represents a platform in the game world where players can stand or collide.
 */
class Platform {
    PVector pos; // The position of the platform
    int width; // The width of the platform
    int height; // The height of the platform

    /**
     * Constructs a Platform with specified position, width, and height.
     *
     * @param pos The position of the platform as a PVector.
     * @param width The width of the platform.
     * @param height The height of the platform.
     */
    Platform(PVector pos, int width, int height) {
        this.pos = pos; // Set platform position
        this.width = width; // Set platform width
        this.height = height; // Set platform height
    }

    /**
     * Placeholder method for drawing the platform (currently does nothing).
     */
    void draw() {
        // Placeholder for drawing logic
    }

    /**
     * Displays the platform on the screen with a specified color.
     * It uses the platform's position, width, and height for drawing.
     */
    void display() {
        noStroke(); // Disable stroke for the rectangle
        fill(100, 100, 255); // Set fill color
        rect(pos.x, pos.y, width, height); // Draw the rectangle representing the platform
    }

    /**
     * Checks for a collision between the platform and a localPlayer instance.
     *
     * @param player The localPlayer instance to check for collisions with.
     * @return True if a collision occurs; false otherwise.
     */
    boolean checkCollision(localPlayer player) {
        return player.pos.x < pos.x + width &&
               player.pos.x + player.getHurtboxWidth() > pos.x &&
               player.pos.y < pos.y + height &&
               player.pos.y + player.getHurtboxHeight() > pos.y;
    }
}

/**
 * Represents the game world, containing tiles and platforms.
 */
class World {
    Tile[][] tiles; // 2D array of tiles in the world
    Tile background; // The background tile for the world
    ArrayList<Platform> platforms; // List of platforms in the world
    int wWidth, wHeight; // Width and height of the world

    /**
     * Default constructor initializes the world with no dimensions and a default background tile.
     */
    World() {
        wWidth = wHeight = 0; // Set width and height to zero
        background = new Tile(textures[430], false, wh); // Initialize background tile
        platforms = new ArrayList<>(); // Initialize empty list of platforms
    }

    /**
     * Constructs a World with specified width, height, and background tile.
     *
     * @param wWidth The width of the world.
     * @param wHeight The height of the world.
     * @param background The background tile for the world.
     */
    World(int wWidth, int wHeight, Tile background) {
        this.wWidth = wWidth; // Set world width
        this.wHeight = wHeight; // Set world height
        this.background = background; // Set background tile
        this.platforms = new ArrayList<>(); // Initialize empty list of platforms
        tiles = new Tile[wWidth / wh][wHeight / wh]; // Create the tile grid

        loadPlatforms("maps/map1.csv"); // Load platforms from a CSV file
    }

    /**
     * Displays the background and tiles of the world.
     * It draws the background and each tile in the grid.
     */
    void display() {
        fill(34, 139, 34); // Set fill color for ground
        rect(0, wHeight - 50, wWidth, 50); // Draw the ground rectangle

        background(14, 12, 18); // Set the background color

        for (int y = 0; y < wHeight / background.size; ++y) { // Loop through rows
            for (int x = 0; x < wWidth / background.size; ++x) { // Loop through columns
                if (y != wHeight / background.size - 5) { // Avoid drawing in the last row
                    image(background.texture, x * background.size, y * background.size); // Draw background
                } 

                if (tiles[x][y] != null) { // Check if tile exists
                    image(tiles[x][y].texture, x * tiles[x][y].size, y * tiles[x][y].size); // Draw tile
                }
            }
        }

        drawPlatforms(); // Draw all platforms in the world
    }

    /**
     * Draws all platforms in the world by calling their display methods.
     */
    void drawPlatforms() {
        for (Platform platform : platforms) {
            platform.display(); // Call display on each platform
        }
    }

    /**
     * Checks for collisions between an enemy and tiles in the world.
     *
     * @param enemy The enemy to check for collisions against.
     * @return True if a collision occurs; false otherwise.
     */
    boolean checkCollision(Enemy enemy) {
        for (int y = 0; y < tiles[0].length; y++) { // Iterate over rows
            for (int x = 0; x < tiles.length; x++) { // Iterate over columns
                Tile tile = tiles[x][y]; // Get the current tile
                if (tile != null && tile.collision) { // Check if tile exists and has collision
                    if (enemy.pos.x < x * tile.size + tile.size &&
                        enemy.pos.x + enemy.hurtboxWidth > x * tile.size &&
                        enemy.pos.y < y * tile.size + tile.size &&
                        enemy.pos.y + enemy.hurtboxHeight > y * tile.size) {

                        if (enemy.pos.y + enemy.hurtboxHeight > y * tile.size) {
                            enemy.pos.y = y * tile.size - enemy.hurtboxHeight; // Adjust enemy position
                        }
                        return true; // Collision detected
                    }
                }
            }
        }
        return false; // No collision detected
    }

    /**
     * Checks for collisions between a player and platforms or tiles in the world.
     *
     * @param player The localPlayer instance to check for collisions with.
     * @return True if a collision occurs; false otherwise.
     */
    boolean checkCollision(localPlayer player) {
        for (Platform platform : platforms) { // Check collision with platforms
            if (platform.checkCollision(player)) {
                if (player.pos.y + player.getHurtboxHeight() <= platform.pos.y) {
                    player.pos.y = platform.pos.y - player.getHurtboxHeight(); // Adjust player position
                    return true; // Collision detected
                }
            }
        }

        for (int y = 0; y < tiles[0].length; y++) { // Check collision with tiles
            for (int x = 0; x < tiles.length; x++) {
                Tile tile = tiles[x][y];
                if (tile != null && tile.collision) {
                    if (player.pos.x < x * tile.size + tile.size &&
                        player.pos.x + player.getHurtboxWidth() > x * tile.size &&
                        player.pos.y < y * tile.size + tile.size &&
                        player.pos.y + player.getHurtboxHeight() > y * tile.size) {

                        player.pos.y = y * tile.size - player.getHurtboxHeight(); // Adjust player position
                        return true; // Collision detected
                    }
                }
            }
        }
        return false; // No collision detected
    }

    /**
     * Loads platforms from a specified CSV file.
     * Each line in the file is expected to contain the platform's position and size.
     *
     * @param filename The name of the CSV file to load.
     */
    private void loadPlatforms(String filename) {
        String relativePath = filename; // Relative path to the CSV file
        String absolutePath = dataPath(relativePath); // Convert to absolute path

        try (BufferedReader br = new BufferedReader(new FileReader(absolutePath))) { // BufferedReader for file reading
            String line;
            br.readLine(); // Skip the header line
            while ((line = br.readLine()) != null) { // Read each line
                String[] values = line.split(","); // Split by commas
                if (values.length == 4) { // Check for the correct number of values
                    float x = Float.parseFloat(values[0]); // Parse x position
                    float y = Float.parseFloat(values[1]); // Parse y position
                    float width = Float.parseFloat(values[2]); // Parse width
                    float height = Float.parseFloat(values[3]); // Parse height
                    platforms.add(new Platform(new PVector(x, y), (int) width, (int) height)); // Add platform
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Print stack trace if an exception occurs
        }
    }
}
