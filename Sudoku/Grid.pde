class Grid { //<>//
  Cell[][] cells;
  int diff;
  boolean filled;
  Grid(int size, int _diff) {
    cells = new Cell[size][size];
    diff = _diff;
  }

  void render() {
    for (Cell[] row : cells) {
      for (Cell c : row) {
        c.render();
      }
    }
  }

  void generatePuzzle() {//initialize cells
    for (int i = 0; i<cells.length; i++) {
      for (int j = 0; j<cells.length; j++) {
        cells[i][j] = new Cell(new PVector(i*(background.width-20)/cells.length+10, j*(background.height-20)/cells.length+10), background.width/cells.length);
      }
    }

    for (int i = 0; i<3; i++) { //The solver needs something to solve
      for (int j = 0; j<3; j++) {
        assignCell(i, j);
      }
    }
  }

  void assignCell(int x, int y) { //assigns a random number to the given cell. Checks if the cell is available recursively
    if (cells[x][y].assignedValue==0) { //if position is available
      int num = (int)random(1, 10);
      if (isNumberLegal(num, new PVector(x, y))) { //if number is legal according to sudoku rules
        cells[x][y].ans = num;
        cells[x][y].assignedValue = cells[x][y].ans;
      } else {
        assignCell(x, y); //if number not legal then try again with a new number
      }
    } else {
      assignCell((int)random(0, 9), (int)random(0, 9)); //if space not available then try with new number
    }
  }

  boolean isNumberLegal(int num, PVector pos) { //checks if number breaks the rules
    for (int i = 0; i<cells.length; i++) { //check row
      if (i!=pos.x) {
        if (cells[i][(int)pos.y].assignedValue == num) {
          return false;
        }
      }
    }

    for (int i = 0; i<cells.length; i++) { //check column
      if (i!=pos.y) {
        if (cells[(int)pos.x][i].assignedValue == num) {
          return false;
        }
      }
    }

    int startX = (int)pos.x/3 * 3;
    int startY = (int)pos.y/3 * 3;
    for (int i = startX; i<startX + 3; i++) { //check 3x3 grid
      for (int j = startY; j<startY + 3; j++) {
        if (!(i == pos.x && j==pos.y)) {
          if (cells[i][j].assignedValue == num) {
            return false;
          }
        }
      }
    }
    return true; //number is legal
  }


  boolean solve(int row, int col, int x, int y, int num) { //solves the grid recursively using simple backtracking
    if (row == cells.length - 1 && col == cells.length) { //Last cell has been checked
      return true;
    }

    if (col == cells.length) { //last cell in row
      row++;
      col = 0;
    }

    if (cells[row][col].assignedValue != 0) { //Already solved - the cell was one of the given hints
      return solve(row, col + 1, x, y, num); //go to next cell
    }
    ArrayList<Integer> nums = new ArrayList();
    for (int i = 0; i < 10; i++) { //the guessss the computer can make for a cell
      nums.add(i);
    }

    Integer num2;
    if (row == y && col == x) { //we reached the cell that contained the number
      num2 = num; //Needs to be an object so it removes the element, not the index
      nums.remove(num2); //This is used when removing hints from the puzzle after solving
    }

    try {
      num2 = 0;
      nums.remove(num2); //try to remove 0 from the list. If it catches, then it was already removed before
    } 
    catch(Exception e) {
    }

    while (nums.size()>0) {
      int i = (int)random(0, nums.size());
      if (isNumberLegal(nums.get(i), new PVector(row, col))) { //move is legal according to rules
        cells[row][col].ans = nums.get(i);
        cells[row][col].assignedValue = nums.get(i);

        if (solve(row, col + 1, x, y, num)) { //go to next cell
          return true;
        }
      }
      cells[row][col].assignedValue = 0;
      cells[row][col].ans = 0; //Change back to zero - solution wasn't possible
      nums.remove(i); //this number did not work, so we remove it
    }
    return false; //no solutions found
  }

  void makePuzzle(int count) { //Recursively removes cells from grid
    int x = (int) random(0, 9); //select random cell
    int y = (int) random(0, 9);
    if (cells[y][x].assignedValue != 0) { //if not already removed
      int cellNumber = cells[y][x].ans; //save cell number before removing
      cells[y][x].assignedValue = 0;
      if (checkUnique(x, y, cellNumber)) {
        makePuzzle(count);//remove another cell
      } else {
        count++;
        cells[y][x].ans = cellNumber;
        cells[y][x].assignedValue = cellNumber;
        if (count!=20) { //20 non-unique guesses
          makePuzzle(count);
        }
      }
    } else {
      makePuzzle(count);
    }
  }

  boolean checkUnique(int x, int y, int num) { //check if there is only one solution to the grid
    Grid temp = new Grid(9, 9); //new temporary grid, so original grid doesn't get changed

    for (int i = 0; i<cells.length; i++) { //copy data from original grid to temp grid
      for (int j = 0; j<cells.length; j++) {
        temp.cells[i][j] = new Cell(new PVector(0, 0), 0);
        temp.cells[i][j].assignedValue = cells[i][j].assignedValue;
      }
    }

    if (temp.solve(0, 0, x, y, num)) { //if it can be solved without the number that was there before
      return false;
    }


    return true;
  }

  boolean checkSolution() { //return false if answer does not correlate with assigned value
    for (Cell[] cs : cells) {
      for (Cell c : cs) {
        if (c.ans != c.assignedValue) {
          return false;
        }
      }
    }
    return true;
  }

  void giveHint(int y, int x) {
    if (cells[y][x].assignedValue == 0) {
      cells[y][x].assignedValue = cells[y][x].ans;
      cells[y][x].locked = true;
    } else {
      giveHint((int)random(0, 9), (int)random(0, 9));
    }
  }
}
