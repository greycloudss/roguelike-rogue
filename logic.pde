//---------------------------------------------------> behind the scenes logic <---------------------------------------------------\\


void parser() {
  int tilesPerRow = 1024 / wh;
  int index = 0;
  for (int y = 0; y < tilesPerRow; ++y) {
    for (int x = 0; x < tilesPerRow; ++x) {
      index = y * tilesPerRow + x;
      textures[index] = img.get(x * wh, y * wh, wh, wh);
    }
  }
}

//boolean hasConfig() {
  //File file = new File(userCFG);
  //return file.exists() ? true : false;
//}

void showTexturesIds() {
  var index = 0;
  fill(0, 0, 0);
  for (int y = 0; y < 1024 /wh; ++y) {
     for (int x = 0; x < 1024 / wh; ++x) {
        index = y * wh + x; // how we get the textures
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
