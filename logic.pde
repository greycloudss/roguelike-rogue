//---------------------------------------------------> behind the scenes logic <---------------------------------------------------\\


void parser() {
  int tilesPerRow = 1024 / wh;
  int index = 0;
  if (img == null) {
    img = loadImage("textures/texturePack.png"); 
  }
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


class bone {
  PVector headPos;
  PVector atkWidth;
  
  
}


void drawCenterMsg(int recW, int recH, String msg, int a) {
  //rect drawing
  rectMode(CORNER);
  fill(10, 10, 10, 255);
  float x = (displayWidth - recW) / 2;
  float y = (displayHeight - recH) / 2;
  //rect(x, y, recW, recH);
  
  
  
  PFont fonter = createFont("innerworkings/timesbd.ttf", 30);
  textAlign(CENTER);
  textFont(fonter);
  //rect(player.pos.x + 190, player.pos.y - 95 + 260, 30, 50);
  
  fill(255, 255, 255, 100);
  
  /*  striking hitbox
  beginShape();
  vertex(player.pos.x + 230- 50, player.pos.y + 195 - 50);
  vertex(player.pos.x + 220 - 50, player.pos.y + 215 - 50);
  vertex(player.pos.x + 220 + 40, player.pos.y + 215);
  vertex(player.pos.x + 230 + 40, player.pos.y + 195);
  endShape(CLOSE);
  */
  /*
  beginShape();
  vertex(player.pos.x + 130, player.pos.y + 315); // left bottom
  vertex(player.pos.x + 155, player.pos.y + 205); // left top
  
  vertex(player.pos.x + 270, player.pos.y + 185); //right top
  vertex(player.pos.x + 255, player.pos.y + 315); //right bottom
  endShape(CLOSE);
  
  //rect(player.pos.x + 230, player.pos.y + 195, 30, 50);
  fill(80, 0, 250, 255);
  text(msg, player.pos.x + 230, player.pos.y + 190);*/
}
