//---------------------------------------------------> world generation <---------------------------------------------------\\


int worldWidth = 8192;
int worldHeight = 4096;

void drawWorld() {
  fill(34, 139, 34);
  rect(0, worldHeight - 50, worldWidth, 50);

  fill(139, 69, 19);
  for (int i = 100; i < worldWidth; i += 400) {
    rect(i, worldHeight - 150, 50, 100);
  }
}
