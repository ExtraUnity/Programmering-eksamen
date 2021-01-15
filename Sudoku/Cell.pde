class Cell {
  PVector pos;
  int ans;
  int assignedValue;
  int size;
  
  Cell(PVector _pos, int _ans, int _size) {
    pos = _pos;
    ans = _ans;
    size = _size;
  }
  
  void render() {
    rect(pos.x,pos.y,size,size);
  }
}
