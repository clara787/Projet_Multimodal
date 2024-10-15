public class Forme{
   int x;
   int y; 
   int h = 100;
   int w = 100;
   int index;
   int r;
   int g;
   int b;
  
   Forme(int x, int y, int r, int g, int b,int index){
     this.x = x;
     this.y = y;
     this.r = r;
     this.g = g;
     this.b = b;
     this.index = index;
   }
   
   //à changer aussi pour que ça fit avec toutes les formes
   void display(){
     fill(r,g,b);
     rect(x,y,w,h);
   }
   
   //à changer pour que ça fit avec toutes les formes
   boolean isMouseOver(int mX, int mY){
      return mX >= x && mX <= x + w && mY >= y && mY <= y + h; 
   }
   
   int getIndex(){
      return index; 
   }
}
