class Cell {
  PVector pos;
  int ans;
  int assignedValue;
  int size;
  
  Cell(PVector _pos, int _size) {
    pos = _pos;
    size = _size;
  }
  
  void render() {
    fill(255);
    rect(pos.x,pos.y,size,size);
    fill(0);
    text(assignedValue,pos.x+size/2,pos.y+size/2);
  }
}
