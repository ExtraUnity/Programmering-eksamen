Grid grid = new Grid(9,17);
void setup() {
  size(700,700);
  grid.generatePuzzle();
}

void draw() {
  grid.render();
}
