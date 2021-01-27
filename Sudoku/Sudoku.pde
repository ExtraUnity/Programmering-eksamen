Grid grid = new Grid(9, 9);
PImage background;
Info infoTable;
void setup() {
  size(1000, 700);
  background = loadImage("data/Grid.png");
  background.resize((int) (width-width*0.3), height);
  grid.generatePuzzle();

  if (grid.solve(0, 0, 0, 0, 0)) {
    println("Success");
  } else {
    println("No Solution exists");
  }
  grid.makePuzzle(0);
  infoTable = new Info();
  infoTable.time = millis();
}


void draw() {
  background(188);
  image(background, 0, 0);
  grid.render();
  infoTable.render();
}

void keyPressed() {
  if (tryParse(key)) {
    for (Cell[] cs : grid.cells) {
      for (Cell c : cs) {
        if (c.selected==1) {
          c.assignedValue = Integer.parseInt(str(key)); //if user presses a number, update cell

          grid.filled = true;
          for (Cell[] row : grid.cells) { //check if grid is filled with numbers
            for (Cell cell : row) {
              if (cell.assignedValue == 0) {
                grid.filled = false;
              }
            }
          }
        }
        if (c.selected==2) {
          if (c.notes.hasValue(Integer.parseInt(str(key)))) {
            c.notes.removeValue(Integer.parseInt(str(key)));
          } else {
            c.notes.append(Integer.parseInt(str(key)));
          }
        }
      }
    }
    if (grid.filled) {
      if (grid.checkSolution()) {//verify the solution
        println("Solved correctly");
      } else {
        println("Wrong solution");
      }
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    for (Cell[] cs : grid.cells) {
      for (Cell c : cs) {
        c.selected = 0;
        if (mouseX > c.pos.x && mouseX < c.pos.x + c.size && mouseY > c.pos.y && mouseY < c.pos.y + c.size) {
          c.selected = 1;
        }
      }
    }
  }
  if (mouseButton == RIGHT) {
    for (Cell[] cs : grid.cells) {
      for (Cell c : cs) {
        c.selected = 0;
        if (mouseX > c.pos.x && mouseX < c.pos.x + c.size && mouseY > c.pos.y && mouseY < c.pos.y + c.size) {
          c.selected = 2;
        }
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
