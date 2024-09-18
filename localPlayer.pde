class localPlayer {
  int yZero = displayHeight - 180;
  int pHeight = wh * 2;
  int pWidth = wh;
  float speed = 8;
  float xpos, ypos;
  
  int skybox = displayHeight - 380; //skybox limit for player
  int oneJump = displayHeight - 350;
  //flags
  boolean movingLeft;
  boolean movingRight;
  boolean moving;
  boolean isJumping;
  boolean isFalling;
  boolean strike;
  boolean alive;
  
  localPlayer() {
    xpos = 50;
    ypos = yZero;
    movingRight = false;
    movingLeft = false;
    moving = false;
    isJumping = false;
    isFalling = false;
    strike = false;
    alive = true;
  }
  
  
  void move() {
    if (alive) {
      jump();
      worldPad();
      if (moving) {
        //moving l or r
        if (movingRight) {
          xpos += speed;
        }
        if (movingLeft) {
          xpos -= speed;
        }
      }
      image(ptxt[0][0], xpos, ypos);
    }
  }
  
  void jump() {
   if (isJumping && !isFalling) {
      ypos -= speed * 4;

      if (movingRight) {
        xpos += speed * 4;
      } 
      if (movingLeft) {
        xpos -= speed * 4;
      }
      
      if (ypos <= oneJump || ypos <= skybox) {
         isJumping = false;
         isFalling = true;
      }
   }
   if (isFalling) {
     ypos += speed * 2;
      

     if (ypos >= yZero) {
        ypos = yZero;
        isFalling = false;
     }
   }
}
}
