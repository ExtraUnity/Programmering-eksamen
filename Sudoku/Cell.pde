class Cell {
  PVector pos;
  int ans;
  int assignedValue;
  int size;
  boolean selected;

  Cell(PVector _pos, int _size) {
    pos = _pos;
    size = _size;
  }

  void render() {
    //fill(255);
    //rect(pos.x,pos.y,size,size);
    if (selected) {
      fill(150, 100);
      rect(pos.x, pos.y, size-2, size-2);
    }
    if (assignedValue != 0) { //only display text if value is not 0
      fill(0);
      textSize(size/2);
      textAlign(CENTER, CENTER);
      text(assignedValue, pos.x+size/2, pos.y+size/2);
    }
  }
}
