Grid grid = new Grid(9, 9);
PImage background;
void setup() {
  size(700, 700);
  grid.generatePuzzle();
  background = loadImage("data/Grid.png");
  background.resize(700, 700);
  if (grid.solve(0, 0,0,0, 0)) {
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
  grid = new Grid(9, 9);
  grid.generatePuzzle();
  if (grid.solve(0, 0,0,0, 0)) {
    println("Success");
  } else {
    System.out.println("No Solution exists");
  }
    grid.makePuzzle(0);
}
