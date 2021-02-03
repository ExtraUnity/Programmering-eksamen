class Info {
  int time, completionTime, x, y, sizeX, sizeY;
  
  Info() {
    x = (int) (width-width*0.29);
    y = (int)(width*0.01);
    sizeX = (int) (width*0.28);
    sizeY = (int) (height-width*0.02);
  }

  void render() {
    fill(255);
    strokeWeight(5);
    rect(x, y, sizeX, sizeY);
    fill(0);
    textSize(40);
    text("Time: " + (int)((millis()-time)/1000), 850, 50);
    String highscore = loadStrings("/data/highscore.txt")[0];
    if(!highscore.equals("")){
      text("Highscore:" + highscore, 850,100);
    }
  }
}
