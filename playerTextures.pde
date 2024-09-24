// Paths for texture images
String pPath = "textures/NightBorne.png"; // Path to the player's main texture image
String sPath = "textures/spawn.png"; // Path to the spawn texture image

/**
 * A class to manage and store the textures for player animations.
 * This class holds different sets of textures for various player actions,
 * including idle, running, attacking, getting hurt, and death animations.
 */
class PlayerTextures {
    private int pHeight = 80; // Height of each sprite
    private int pWidth = 80; // Width of each sprite

    PImage[] idle = new PImage[9]; // Array to store idle animation frames
    PImage[] run = new PImage[6]; // Array to store running animation frames
    PImage[] attack = new PImage[12]; // Array to store attacking animation frames
    PImage[] hurt = new PImage[5]; // Array to store hurt animation frames
    PImage[] death = new PImage[23]; // Array to store death animation frames

    /**
     * Constructs a PlayerTextures object and loads the player texture image from the specified path.
     * The constructor initializes the animation arrays by slicing the loaded image into individual frames
     * for different actions based on the predefined rows.
     *
     * @param path The path to the texture image from which player sprites will be extracted.
     */
    PlayerTextures(String path) {
        PImage tmp = loadImage(path); // Load the texture image
        if (tmp == null) return; // Exit if the image fails to load

        for (int i = 0; i < 5; ++i) { // Iterate over the predefined actions
            switch (i) {
                case 0:
                    idle = setupPlayerSprites(tmp, pHeight, pWidth, i, idle.length); // Setup idle sprites
                    break;
                case 1:
                    run = setupPlayerSprites(tmp, pHeight, pWidth, i, run.length); // Setup run sprites
                    break;
                case 2:
                    attack = setupPlayerSprites(tmp, pHeight, pWidth, i, attack.length); // Setup attack sprites
                    break;
                case 3:
                    hurt = setupPlayerSprites(tmp, pHeight, pWidth, i, hurt.length); // Setup hurt sprites
                    break;
                case 4:
                    death = setupPlayerSprites(tmp, pHeight, pWidth, i, death.length); // Setup death sprites
                    break;
            }
        }
    }
}

/**
 * Extracts a specified number of sprite frames from a given image.
 * This function slices the image into smaller PImage objects based on the specified width, height, 
 * row, and size parameters, which represent the total number of frames in that row.
 *
 * @param image The source PImage from which to extract the sprite frames.
 * @param pWidth The width of each individual sprite frame.
 * @param pHeight The height of each individual sprite frame.
 * @param row The row index from which to extract the sprite frames.
 * @param size The total number of frames to extract from the specified row.
 * @return An array of PImage objects containing the extracted sprite frames.
 */
PImage[] setupPlayerSprites(PImage image, int pWidth, int pHeight, int row, int size) {
    PImage[] temp = new PImage[size]; // Array to hold extracted sprites

    for (int i = 0; i < size; ++i) { // Iterate over the number of frames to extract
        if (i * pWidth < image.width) { // Ensure the extraction is within image bounds
            temp[i] = image.get(i * pWidth, row * pHeight, pWidth, pHeight); // Extract the sprite frame
        } else {
            temp[i] = null; // Set to null if out of bounds
        }
    }

    return temp; // Return the array of extracted sprite frames
}
