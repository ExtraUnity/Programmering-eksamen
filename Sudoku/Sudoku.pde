Grid grid;
PImage background;
boolean cellSelected = false;
boolean solved;
ArrayList<Button> buttons;
int scene = -1;
boolean loading = false;
boolean notes = false;
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
  if (!tryParseString(String.valueOf(key))) return; //if key is not a number

  int pressedVal = Integer.parseInt(str(key));

  for (Cell[] cs : grid.cells) { //Insert number in correct cell
    for (Cell c : cs) {
      if (c.selected && !c.locked) {
        if (!notes) {
          c.assignedValue = pressedVal; //if user presses a number, update cell
          grid.filled = grid.filled();
        } else {
          if (!c.notes.hasValue(pressedVal) && pressedVal != 0) c.notes.append(pressedVal);
          else c.notes.removeValue(pressedVal);
        }
      }
    }
  }

  if (grid.filled) {
    if (grid.checkSolution()) solved(); //verify the solution
    else println("Wrong solution");
  }
}

void mousePressed() {
  if (scene%3 != 1) return; 
  if (mouseButton != LEFT) return;

  for (Button b : buttons) { //detection of clicks on numbered buttons
    if (tryParseString(b.text)&&b.pressed()) { //if the buttons purely contains numbers, the number buttons
      for (Cell[] cs : grid.cells) {
        for (Cell c : cs) {
          if (c.selected&&!c.locked) {

            if (!notes) c.assignedValue = Integer.parseInt(b.text);
            else if (!c.notes.hasValue(Integer.parseInt(b.text))) c.notes.append(Integer.parseInt(b.text));
            else c.notes.removeValue(Integer.parseInt(b.text));
          }
        }
      }
    } else if (b.text.contains("Notes")&&b.pressed()) {
      if (b.text.contains("off")) {
        b.text = "Notes on";
        b.textColor = color(0, 255, 0);
        notes = true;
      } else {
        b.text = "Notes off";
        b.textColor = color(255, 0, 0);
        notes = false;
      }
    } else if (b.text.contains("Clear")&&b.pressed()) {
      if (b.text.contains("All")) {
        for (Cell[] cs : grid.cells) {
          for (Cell c : cs) {
            c.notes.clear();
            if (!c.locked) c.assignedValue = 0;
          }
        }
      } else {
        for (Cell[] cs : grid.cells) {
          for (Cell c : cs) {
            if (c.selected&&!c.locked) {
              c.assignedValue = 0;
              c.notes.clear();
            }
          }
        }
      }
    } else if (b.text.contains("Hint")&&b.pressed()) { //when give hint pressed
      if (cellSelected) {
        for (int y = 0; y<grid.cells.length; y++) {
          for (int x = 0; x<grid.cells.length; x++) {
            if (grid.cells[y][x].selected) {
              grid.giveHint(y, x);
            }
          }
        }
      } else {
        grid.giveHint((int)random(0, 9), (int)random(0, 9));
      }
      if (grid.checkSolution()) solved();
    }
  }

  cellSelected = false;
  for (Cell[] cs : grid.cells) { //detection of clicking a cell.
    for (Cell c : cs) {
      c.selected = false;
      if (c.mouseWithin()) {
        c.selected = true;
        cellSelected = true;
      }
    }
  }
}

boolean tryParseString(String s) { //return true if s is a number
  try {
    Integer.parseInt(s);
    return true;
  }
  catch(Exception E) {
    return false;
  }
}

void initializeScene() {
  int num = scene+1;
  switch(num%3) {
  case 0: //makes starting scene
    buttons.add(new Button(width/2-50, height/3*2, 100, 50, "Start"));

    break;

  case 1: //makes main scene
    background = loadImage("Grid.png");
    background.resize((int) (width-width*0.3), height);
    grid = new Grid(9);
    infoTable = new Info();
    grid.generatePuzzle();
    if (grid.solve(0, 0, 0, 0, 0)) {
      println("Success");
    } else {
      println("No Solution exists");
    }
    grid.makePuzzle(0);
    for (Cell[] cs : grid.cells) {
      for (Cell c : cs) {
        if (c.assignedValue != 0) {
          c.locked=true;
        }
      }
    }
    infoTable.time = millis();
    buttons.add(new Button(800, 200, 100, 50, "Hint"));
    for (int i = 0; i < 9; i++) {
      buttons.add(new Button(750+70*(i%3), 300+70*(i/3), 50, 50, str(i+1)));
    }
    buttons.add(new Button(740, 510, 100, 50, "Clear cell"));
    buttons.add(new Button(850, 510, 100, 50, "Clear All"));
    buttons.add(new Button(795, 580, 100, 50, "Notes off", color(255, 0, 0)));

    break;

  case 2: //makes victory page
    buttons.add(new Button(width/2-60, height/3*2+51, 120, 45, "Main page"));
    break;
  }
  scene = num;
  loading = false;
}

void removeScene() {
  switch(scene%3) { //removes the active scene
  case 0:
    buttons.clear();
    break;

  case 1:
    buttons.clear();
    grid = new Grid(9);
    break;

  case 2:
    buttons.clear();
    break;
  }
}

void renderScene() {
  switch(scene%3) {
  case 0: //renders the initial scene 
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
        thread("initializeScene"); //creates a thread for generating the puzzle
      }
    }
    break;

  case 1: //renders the sudoku scene
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

  case 2: //renders the win scene
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
    text("Highscore: " + int(loadStrings("highscore.txt")[0]), width/2, height/2+30);
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

void solved() { //handles all the things for when the user solves the sudoku
  infoTable.completionTime = (int)((millis()-infoTable.time)/1000);
  println("Solved correctly");
  solved = true;
  try {
    if (int(loadStrings("highscore.txt")[0])>infoTable.completionTime || int(loadStrings("highscore.txt")[0]) == 0) {
      String[] highscore = {str(infoTable.completionTime)};
      saveStrings("data/highscore.txt", highscore);
    }
  }
  catch(Exception e) {
  }
}
