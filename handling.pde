void keyPressed() {
    handleMovement(true);
}

void keyReleased() {
    handleMovement(false);
}

void handleMovement(boolean isPressed) {
    switch (key) {
        case 'a':
        case 'A':
            player.isLeft = isPressed;
            break;

        case 'd':
        case 'D':
            player.isRight = isPressed;
            break;

        case 'w':
        case 'W':
            if (isPressed) {
                player.jump();
            }
            break;
    }

    player.isMoving = player.isLeft || player.isRight;
}

void mousePressed() {
    player.isAttacking = true; 
}

void mouseReleased() {
    player.isAttacking = false; 
}
