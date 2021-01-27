Grid grid = new Grid(9, 9);
PImage background;
void setup() {
  size(700, 700);
  grid.generatePuzzle();
  background = loadImage("data/Grid.png");
  background.resize(700, 700);
  if (grid.solve(0, 0, 0, 0, 0)) {
    println("Success");
  } else {
    println("No Solution exists");
  }
  grid.makePuzzle(0);
}


void draw() {
  image(background, 0, 0);
  grid.render();
}

void keyPressed() {
  /*grid = new Grid(9,9);
   grid.generatePuzzle();
   if (grid.solve(0, 0)) {
   println("Success");
   }  else {
   System.out.println("No Solution exists");
   }*/
  if (tryParse(key)) {
    for (Cell[] cs : grid.cells) {
      for (Cell c : cs) {
        if (c.selected) {
          c.assignedValue = Integer.parseInt(str(key)); //if user presses a number, update cell
          grid.filled = true;
          for (Cell[] row : grid.cells) {
            for (Cell cell : row) {
              if (cell.assignedValue == 0) {
                grid.filled = false;
              }
            }
          }
          if (grid.filled) {
            if (grid.checkSolution()) {
              println("Solved correctly");
            } else {
              println("Wrong solution");
            }
          }
        }
      }
    }
  }
}

void mousePressed() {
  for (Cell[] cs : grid.cells) {
    for (Cell c : cs) {
      c.selected = false;
      if (mouseX > c.pos.x && mouseX < c.pos.x + c.size && mouseY > c.pos.y && mouseY < c.pos.y + c.size) {
        c.selected = true;
      }
    }
  }
}
boolean tryParse(char c) { //return true if c is a number
  try {
    Integer.parseInt(str(c));
    return true;
  }
  catch(Exception E) {
    return false;
  }
}
