import fr.dgac.ivy.*;
import java.awt.*;
import processing.core.PApplet;

IvyClick ivyClick;
MoteurMultiModal multi;
ArrayList<Button> buttonForme;
ArrayList<Button> buttonCouleur;
ArrayList<Forme> forme;

void setup(){
  ivyClick = new IvyClick();
  multi = new MoteurMultiModal();
  
  buttonForme = new ArrayList<>();
  buttonCouleur = new ArrayList<>();
  forme = new ArrayList<>();
  
  buttonForme.add(new Button(0,0,100,50,"Rectangle"));
  buttonForme.add(new Button(100,0,100,50,"Triangle"));
  buttonForme.add(new Button(200,0,100,50,"Cercle"));
  buttonForme.add(new Button(300,0,100,50,"Carré"));
  
  buttonCouleur.add(new Button(500,0,100,50,"Rouge"));
  buttonCouleur.add(new Button(600,0,100,50,"Bleu"));
  buttonCouleur.add(new Button(700,0,100,50,"Vert"));
  
  forme.add(new Forme(500,300,0,200,0,0));
  
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
  
  for(Forme f : forme){
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
  
  for(Forme f : forme){
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
  return forme;
}
