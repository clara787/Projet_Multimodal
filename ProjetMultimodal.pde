import fr.dgac.ivy.*;
import java.awt.*;
import processing.core.PApplet;

IvyClick ivyClick;
MoteurMultiModal multi;
ArrayList<Button> buttonForme;
ArrayList<Button> buttonCouleur;
ArrayList<Forme> formes;

void setup(){
  ivyClick = new IvyClick();
  multi = new MoteurMultiModal();
  
  buttonForme = new ArrayList<>();
  buttonCouleur = new ArrayList<>();
  formes = new ArrayList<>();
  
  buttonForme.add(new Button(0,0,100,50,0,"Rectangle"));
  buttonForme.add(new Button(100,0,100,50,0,"Triangle"));
  buttonForme.add(new Button(200,0,100,50,0,"Cercle"));
  buttonForme.add(new Button(300,0,100,50,0,"Carré"));
  
  buttonCouleur.add(new Button(500,0,100,50,1,"Rouge"));
  buttonCouleur.add(new Button(600,0,100,50,1,"Bleu"));
  buttonCouleur.add(new Button(700,0,100,50,1,"Vert"));
  
  //formes.add(new Forme(500,300,0,200,0,0,""));
  draw_shape(500,300,0,0,200,0,"Carré");
  size(800,600);
}

void draw(){
  background(100);
  
  for(Button b : buttonForme){
     b.display(); 
  }
  
  for(Button b : buttonCouleur){
     b.display(); 
  }
  
  for(Forme f : formes){
     f.display(); 
  }
}

void mousePressed(){
  for(Button b : buttonForme){
     if(b.isMouseOver(mouseX,mouseY)){
       ivyClick.appuiButtonForme(b);
       return;
     }
  }
  
  for(Button b : buttonCouleur){
     if(b.isMouseOver(mouseX,mouseY)){
       ivyClick.appuiButtonCouleur(b);
       return;
     }
  }
  
  for(Forme f : formes){
     if(f.isMouseOver(mouseX,mouseY)){
        ivyClick.appuiForme(f);
        return;
     }
  }
  
  ivyClick.traitementSouris(mouseX,mouseY); 
}

void mouseMoved(){
   ivyClick.positionSouris(mouseX,mouseY); 
}

ArrayList<Forme> getForme(){
  return formes;
}

ArrayList<Button> getButton(int type){
  if (type == 0){
    return buttonForme;
  }
  return buttonCouleur;
}

void draw_shape(int x, int y, int r, int g, int b, int index,String label){
  Forme forme = new Forme(x, y, r, g, b, index, label);
  formes.add(forme);
  forme.display();
}

void delete_shape(int index){
  formes.remove(index);
}

void modify_color(int r, int g, int b, int index){
  Forme forme_tmp = formes.get(index);
  forme_tmp.setR(r);
  forme_tmp.setG(g);
  forme_tmp.setB(b);  
}

void replace_shape(int x, int y,int index){
  Forme forme_tmp = formes.get(index);
  forme_tmp.setX(x);
  forme_tmp.setY(y); 
}
