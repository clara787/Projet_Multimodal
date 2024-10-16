public class Forme{
   int x;
   int y; 
   int h = 100;
   int w = 100;
   int index;
   int r;
   int g;
   int b;
   String label;
  
   Forme(int x, int y, int r, int g, int b,int index, String label){
     this.x = x;
     this.y = y;
     this.r = r;
     this.g = g;
     this.b = b;
     this.index = index;
     this.label = label;
   }
   
   //à changer aussi pour que ça fit avec toutes les formes
   void display(){
     fill(r,g,b);  
    if (label == "Rectangle" || label == "Carré") {
      rect(x, y, w, h);
    }
    else if (label == "Cercle"){
      ellipse(x, y, w, h);
    }
    else if (label == "Triangle") {
      triangle(x+w/2, y, x+w, y+h, x, y+h);
    }
   }
   
   //à changer pour que ça fit avec toutes les formes
   boolean isMouseOver(int mX, int mY){
      return mX >= x && mX <= x + w && mY >= y && mY <= y + h; 
   }
   
   int getIndex(){
      return index; 
   }

 String getLabel(){
     return label; 
  }
  
  ArrayList getCouleur(){
    ArrayList<Integer> couleur = new ArrayList<Integer> ();
    couleur.add(r);
    couleur.add(g);
    couleur.add(b);
    return couleur;
  }
}
