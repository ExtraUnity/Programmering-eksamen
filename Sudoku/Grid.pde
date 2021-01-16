class Grid {
  Cell[][] cells;
  int diff;

  Grid(int size, int _diff) {
    cells = new Cell[size][size];
    diff = _diff;
  }

  void render() {
    for(Cell[] row : cells) {
      for(Cell c : row) {
        c.render();
      }
    }
  }
  
  void generatePuzzle() {//initialize cells
    for (int i = 0; i<cells.length; i++) {
      for (int j = 0; j<cells.length; j++) {
        cells[i][j] = new Cell(new PVector(i*width/cells.length,j*height/cells.length),width/cells.length);
      }
    }
    
    for(int i = 0; i<diff; i++) { //gives values to each of the starthints
      int x = (int)random(0,9);
      int y = (int)random(0,9);
      assignCell(x,y);
      cells[x][y].assignedValue = cells[x][y].ans;
    }
    
  }
  
  void assignCell(int x, int y) { //assigns a random number to the given cell. Checks if the cell is available recursively
    if(cells[x][y].ans==0) { //if position is available
      int num = (int)random(1,10);
      if(isNumberLegal(num, new PVector(x,y))) { //if number is legal according to sudoku rules
        cells[x][y].ans = num;
      } else {
        assignCell(x, y); //if number not legal then try again with a new number
      }
    } else {
      assignCell((int)random(0,9), (int)random(0,9)); //if space not available then try with new number
    }
  }
  
  boolean isNumberLegal(int num, PVector pos) { //checks if number breaks the rules //<>//
    for(int i = 0; i<cells.length; i++) { //check row
      if(i!=pos.x) {
          if(cells[i][(int)pos.y].assignedValue == num) {
            return false;
          }
        }
    }
    
    for(int i = 0; i<cells.length; i++) { //check column
      if(i!=pos.y) {
          if(cells[(int)pos.x][i].assignedValue == num) {
            return false;
          }
        }
    }
    
    int startX = (int)pos.x/3 * 3;
    int startY = (int)pos.y/3 * 3;
    for(int i = startX; i<startX + 3; i++) { //check 3x3 grid
      for(int j = startY; j<startY + 3; j++) {
        if(!(i == pos.x && j==pos.y)) {
          if(cells[i][j].assignedValue == num) {
            return false;
          }
        }
      }
    }
     
    
    return true; //number is legal
  }
}
