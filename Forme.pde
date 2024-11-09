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
    if (label.equals("Rectangle")) {
      rect(x, y, w, 200);
    }
    else if (label.equals("Carré")){
      rect(x, y, w, h);
    }
    else if (label.equals("Cercle")){
      ellipse(x, y, w, h);
    }
    else if (label.equals("Triangle")) {
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
  
  int getR(){
    return r;
  }
  
  int getG(){
    return g;
  }
  
  int getB(){
    return b;
  }
  
  int getX(){
     return x; 
  }
  
  int getY(){
     return y; 
  }
  
  void setR(int new_r){
    this.r = new_r;
  }
  
  void setG(int new_g){
    this.g = new_g;
  }
  
  void setB(int new_b){
    this.b = new_b;
  }
  
  void setX(int new_x){
    this.x = new_x;
  }
  
  void setY(int new_y){
    this.y = new_y;
  }
}
