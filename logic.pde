void parser() {
  int tilesPerRow = 1024 / wh;
  if (img == null) {
    img = loadImage("textures/texturePack.png"); 
  }
  for (int y = 0; y < tilesPerRow; y++) {
    for (int x = 0; x < tilesPerRow; x++) {
      int index = y * tilesPerRow + x;
      textures[index] = img.get(x * wh, y * wh, wh, wh);
    }
  }
}

void showTexturesIds() {
  var index = 0;
  fill(240);
  int tilesPerRow = 1024 / wh;
  for (int y = 0; y < tilesPerRow; y++) {
     for (int x = 0; x < tilesPerRow; y++) {
        index = y * tilesPerRow + x; 
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
