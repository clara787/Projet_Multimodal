public class Button{
  int x,y,w,h;
  String label;
  
  Button(int x, int y, int w, int h, String label){
     this.x = x;
     this.y = y;
     this.w = w;
     this.h = h;
     this.label = label;
  }
  
  void display(){
    fill(116,105,103);
    rect(x,y,w,h);
    fill(255);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2);
  }
  
  boolean isMouseOver(int mX, int mY){
   return mX > x && mX < x + w && mY > y && mY < y + h; 
  }
  
  String getLabel(){
     return label; 
  }
}
