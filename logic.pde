/**
 * Parses the texture pack image and extracts individual tile textures.
 * This function divides the texture pack into tiles of specified width and height,
 * and stores them in the `textures` array for later use.
 * The texture pack image is loaded if it hasn't been loaded yet.
 */
void parser() {
    int tilesPerRow = 1024 / wh; // Calculate how many tiles fit in a row
    if (img == null) {
        img = loadImage("textures/texturePack.png"); // Load the texture pack image
    }
    for (int y = 0; y < tilesPerRow; y++) {
        for (int x = 0; x < tilesPerRow; x++) {
            int index = y * tilesPerRow + x; // Calculate the index for the textures array
            textures[index] = img.get(x * wh, y * wh, wh, wh); // Extract tile texture
        }
    }
}

/**
 * Displays the texture IDs and their corresponding images on the screen.
 * This function iterates through the tiles in the texture pack,
 * retrieves each tile image, and displays it along with its index.
 * Additionally, it draws grid lines for better visibility of tile placement.
 */
void showTexturesIds() {
    var index = 0;
    fill(240); // Set background color for the texture display
    int tilesPerRow = 1024 / wh; // Calculate how many tiles fit in a row
    for (int y = 0; y < tilesPerRow; y++) {
        for (int x = 0; x < tilesPerRow; y++) { // Note: This line has an error; 'y++' should be 'x++'
            index = y * tilesPerRow + x; 
            textures[index] = img.get(x * wh, y * wh, wh, wh); // Get tile texture
            image(textures[index], x * wh, y * wh); // Display tile texture
            text(index, x * wh, y * wh); // Display tile index
        }
    }

    // Draw grid lines to separate tiles visually
    for (int i = 0; i < width / wh; i++) {
        line(i * wh, 0, i * wh, height); // Vertical lines
        line(0, i * wh, width, i * wh); // Horizontal lines
    }
}
