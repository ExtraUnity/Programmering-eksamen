Grid grid;
PImage background;
boolean cellSelected = false;
boolean solved;
ArrayList<Button> buttons;
int scene = -1;
boolean loading = false;
Info infoTable;
void setup() {
  size(1000, 700);
  buttons = new ArrayList<Button>();
  initializeScene();
}


void draw() {

  renderScene();
}

void keyPressed() {
  if (tryParse(key)) {//if key is a number
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
        if (c.selected==2) { //if user right clicks to take notes
          if (c.notes.hasValue(Integer.parseInt(str(key)))) {
            c.notes.removeValue(Integer.parseInt(str(key)));
          } else {
            c.notes.append(Integer.parseInt(str(key)));
          }
        }
      }
    }
    if (grid.filled) {
      if (grid.checkSolution()) { //verify the solution
        infoTable.completionTime = (int)((millis()-infoTable.time)/1000);
        println("Solved correctly");
        solved = true;
        try {
          if (int(loadStrings("/data/highscore.txt")[0])>infoTable.completionTime || int(loadStrings("/data/highscore.txt")[0]) == 0) {
            String[] highscore = {str(infoTable.completionTime)};
            saveStrings("/data/highscore.txt", highscore);
          }
        }
        catch(Exception e) {
          println(e);
        }
      } else {
        println("Wrong solution");
      }
    }
  }
}

void mousePressed() {
  if (scene%3 == 1) {
    if (mouseButton == LEFT) {
      if (buttons.get(0).pressed()) {
        if (cellSelected) {
          for (int y = 0; y<grid.cells.length; y++) {
            for (int x = 0; x<grid.cells.length; x++) {
              if (grid.cells[y][x].selected==1) {
                grid.giveHint(y, x);
              }
            }
          }
        } else {
          grid.giveHint((int)random(0, 9), (int)random(0, 9));
        }
      }
      cellSelected = false;
      for (Cell[] cs : grid.cells) {
        for (Cell c : cs) {
          c.selected = 0;

          if (mouseX > c.pos.x && mouseX < c.pos.x + c.size && mouseY > c.pos.y && mouseY < c.pos.y + c.size) {
            c.selected = 1;
            cellSelected = true;
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

void initializeScene() {
  int num = scene+1;
  switch(num%3) {
  case 0:
    buttons.add(new Button(width/2-50, height/3*2, 100, 50, "Start"));

    break;

  case 1:
    background = loadImage("data/Grid.png");
    background.resize((int) (width-width*0.3), height);
    grid = new Grid(9, 9);
    infoTable = new Info();
    grid.generatePuzzle();
    if (grid.solve(0, 0, 0, 0, 0)) {
      println("Success");
    } else {
      println("No Solution exists");
    }
    grid.makePuzzle(0);

    infoTable.time = millis();
    buttons.add(new Button(800, 250, 100, 50, "Hint"));
    break;

  case 2:
    buttons.add(new Button(width/2-60, height/3*2+51, 120, 45, "Main page"));
    break;
  }
  scene = num;
  loading = false;
}

void removeScene() {
  switch(scene%3) {
  case 0:
    buttons.clear();
    break;

  case 1:
    buttons.clear();
    grid = new Grid(9, 9);
    break;

  case 2:
    buttons.clear();
    break;
  }
}

void renderScene() {
  switch(scene%3) {
  case 0:
    background(255);
    textSize(40);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Welcome to Sudoku!", width/2, height/4);
    if (loading) {
      fill(0);
      textSize(25);
      text("Loading...", width/2, height/2);
    }
    for (int i = 0; i<buttons.size(); i++) {
      buttons.get(i).render();

      if (buttons.get(i).pressed()) {

        removeScene();
        println("Loading puzzle...");
        loading = true;
        thread("initializeScene");
      }
    }
    break;

  case 1:

    background(188);
    image(background, 0, 0);
    grid.render();
    infoTable.render();
    for (Button b : buttons) {
      b.render();
    }
    if (solved) {
      removeScene();
      loading = true;
      initializeScene();
      solved = false;
    }
    break;

  case 2:
    background(255);
    fill(255);
    strokeWeight(5);
    rect(width/2-150, height/2-200, 300, 500);

    textAlign(CENTER, CENTER);
    fill(0);
    textSize(35);
    text("YOU DID IT!", width/2, height/2-100);
    textSize(20);
    text("Time: " + infoTable.completionTime, width/2, height/2);
    text("Highscore: " + int(loadStrings("/data/highscore.txt")[0]), width/2, height/2+30);
    for (int i = 0; i<buttons.size(); i++) {
      buttons.get(i).render(); 

      if (buttons.get(i).pressed()) {
        removeScene();
        initializeScene();
      }
    }
    break;
  }
}
