final int UP = 1;
final int RIGHT = 2;
final int DOWN = 3;
final int LEFT = 4;


class Ghost {
  
  int x, y; // Ghost's position
  int direction; // Ghost's movement direction
  GameMap map; // Reference to the game map
  Pacman pacman; // Reference to the player
  Pathfinder pf;
  long lastSwitchTime = 0; // Time of the last state switch
  int cellSize;
    
    
  // Constructor
  Ghost(int startX, int startY, Pacman pacman, GameMap map, Pathfinder pf) {
    this.x = startX;
    this.y = startY;
    this.pacman = pacman;
    this.map = map;
    this.pf = pf;
    this.direction = (int)random(8); // Randomly initialize movement direction
    this.lastSwitchTime = 0;
    this.cellSize = map.cellSize;
  }


  // Update the ghost's position
  void update() {
    //direction = (int)random(8); // Randomly change direction
    move();
  }
  
  
  // Method to draw the ghost
  void drawGhost() {
    toggleGhostState();
    int baseX = x * cellSize + cellSize / 2;
    int baseY = y * cellSize + cellSize / 2;
    fill(255, 0, 0); // Set to red color
    noStroke();

    // Draw the body
    beginShape();
    // Semi-circular top
    arc(baseX, baseY, cellSize, cellSize, PI, TWO_PI);
    rect(baseX-cellSize/2, baseY, cellSize, cellSize/4);
    // Wavy bottom
    int wavySectionWidth = cellSize / 4;
    for (int i = 0; i < 4; i++) {
      int startX = baseX - cellSize / 2 + i * wavySectionWidth;
      int endX = startX + wavySectionWidth;
      arc((startX + endX)/2, baseY + cellSize/4, wavySectionWidth*0.75, wavySectionWidth*1.9, 0, PI);
    }
    endShape(CLOSE);

    // Draw the eyes
    fill(255); // White eyes
    ellipse(baseX - cellSize / 4, baseY - cellSize / 4, cellSize / 4, cellSize / 4);
    ellipse(baseX + cellSize / 4, baseY - cellSize / 4, cellSize / 4, cellSize / 4);
    
    // Draw the pupils
    fill(0); // Black pupils
    ellipse(baseX - cellSize / 4, baseY - cellSize / 4, cellSize / 8, cellSize / 8);
    ellipse(baseX + cellSize / 4, baseY - cellSize / 4, cellSize / 8, cellSize / 8);
  }


  // Toggle Ghost's state based on time
  void toggleGhostState() {
    if (millis() - lastSwitchTime > 500) { // Check if X milliseconds have passed to update direction more frequently
      update();
      lastSwitchTime = millis(); // Update switch time
    }
  }
  
  
  // Move ghost
  void move() {
    
    int targetRow = getTargetNode()[1];
    int targetCol = getTargetNode()[0];

    pf.setGrid(this.x, this.y, targetCol, targetRow);

    if ( pf.traverse() ) {
      
      this.x = pf.optimalPath.get(0).x;
      this.y = pf.optimalPath.get(0).y;
    }
    else { // Ghost is completely blocked off -> move randomly until able to reach target again
      randomMove();
    }
    
  }
  
  
  // If ghost blocked and cannot find target -> move randomly
  void randomMove() {
    
    int newX = -1;
    int newY = -1;
    
    // Get valid move
    while ( !map.checkMove(newX, newY) ) {
      
      int direction = (int) random(1, 5);
    
      switch (direction) {
      
      case UP:
        newX = this.x;
        newY = this.y - 1;
        break;
      case RIGHT:
        newX = this.x + 1;
        newY = this.y;
        break;
      case DOWN:
        newX = this.x;
        newY = this.y + 1;
        break;
      case LEFT:
        newX = this.x - 1;
        newY = this.y;
        break;
      default:
        break;
      }
      
    }
    
    // Update position
    this.x = newX;
    this.y = newY;
    
  }

 
  // Get ghost's target node
  int[] getTargetNode() {
    int[] target = {pacman.x, pacman.y};
    return target;
  }
  
}
