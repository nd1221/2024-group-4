Pacman myPacman;
GameMap gameMap;
Ghost ghost;

void setup() {
  size(400, 240);
  gameMap = new GameMap(40); // Assuming each cell is 40 pixels
  myPacman = new Pacman(1, 1, gameMap); // Pacman starts at grid position (1, 1) and knows about the game map
  ghost = new Ghost(8, 4, myPacman, gameMap);
}

void draw() {
  background(0);
  gameMap.drawMap();
  myPacman.drawPacman();
  ghost.drawGhost();
}

void keyPressed() {
  // Update Pacman's direction and attempt to move
  if (keyCode == UP) {
    myPacman.move(0, -1);
  } else if (keyCode == DOWN) {
    myPacman.move(0, 1);
  } else if (keyCode == LEFT) {
    myPacman.move(-1, 0);
  } else if (keyCode == RIGHT) {
    myPacman.move(1, 0);
  }
}
