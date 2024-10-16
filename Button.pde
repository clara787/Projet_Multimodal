public class Button{
  int x,y,w,h,r,g,b,type;
  String label;
  
  Button(int x, int y, int w, int h,int type, String label){
     this.x = x;
     this.y = y;
     this.w = w;
     this.h = h;
     this.label = label;
     this.r = 116;
     this.b = 105;
     this.g = 103;
     this.type = type;
  }
  
  void display(){
    fill(r,g,b);
    rect(x,y,w,h);
    fill(255);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2);
  }
  
  boolean isMouseOver(int mX, int mY){
   if(mX > x && mX < x + w && mY > y && mY < y + h){
     for(Button b : getButton(type)){
         b.reinit();
     }
     this.r = 255;
     this.b = 255;
     this.g = 255;
     return true;
   }
   return false; 
  }
  
  String getLabel(){
     return label; 
  }
  
  void reinit(){
     this.r = 116;
     this.b = 105;
     this.g = 103;
  }
}
