import java.util.ArrayList;

PImage img;

World world;
int wh = 32;
int yZero = displayHeight - 180;

PImage[] textures = new PImage[(1024 / wh) * (1024 / wh) + 1];

localPlayer player;
ArrayList<Enemy> enemies;

void setup() {
    frameRate(240);
    windowTitle("RogueLike Rogue");
    fullScreen();

    if (img == null)
        img = loadImage("textures/texturePack.png");

    size(displayWidth, displayHeight);

    parser();
    world = new World(4096 * 2, 4096, new Tile(textures[430], false, wh));

    player = new localPlayer(new PVector(32, 300), displayHeight - 50);

    enemies = new ArrayList<Enemy>();
    enemies.add(new Enemy(new PVector(300, 900))); 
    enemies.add(new Enemy(new PVector(400, 900)));
    enemies.add(new Enemy(new PVector(500, 900)));

    smooth(16);
}

void draw() {
    System.gc();
    float offsetX = constrain(-player.pos.x + width / 2, width - world.wWidth, 0);
    float offsetY = constrain(-player.pos.y + height / 2, height - world.wHeight, 0);
    translate(offsetX, offsetY);

    world.display();

    for (Enemy enemy : enemies) {
        enemy.update(world); 
        enemy.draw();
    }

    player.update(enemies); 
    player.drawPlayer();

    if (player.isAlive) {
        noCursor();
    }
}
