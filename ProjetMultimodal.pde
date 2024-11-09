import fr.dgac.ivy.*;
import java.awt.*;
import processing.core.PApplet;

IvyClick ivyClick;
MoteurMultiModal multi;
ArrayList<Button> buttonForme;
ArrayList<Button> buttonCouleur;
ArrayList<Forme> formes;
Button buttonClear;

Thread thread_forme;

void setup(){
  ivyClick = new IvyClick();
  multi = new MoteurMultiModal();
  
  buttonForme = new ArrayList<>();
  buttonCouleur = new ArrayList<>();
  buttonClear = new Button(1500,0,100,50,0,"Clear");
  formes = new ArrayList<>();
  
  buttonForme.add(new Button(0,0,100,50,0,"Rectangle"));
  buttonForme.add(new Button(100,0,100,50,0,"Triangle"));
  buttonForme.add(new Button(200,0,100,50,0,"Cercle"));
  buttonForme.add(new Button(300,0,100,50,0,"Carré"));
  
  buttonCouleur.add(new Button(500,0,100,50,1,"Rouge"));
  buttonCouleur.add(new Button(600,0,100,50,1,"Bleu"));
  buttonCouleur.add(new Button(700,0,100,50,1,"Vert"));
   
  lancement_python(); 
  
  try {
    bus = new Ivy("OneDollarIvy", " OneDollarIvy is ready", null);
    bus.start("127.255.255.255:2010");
  }catch (IvyException ie) {}
  
  thread_forme = new Thread(new Runnable() {
        public void run() {
            while(true){
              String list_forme_string = "";
              for(Forme f : formes){
                if(f.getLabel().equals("Carré"))list_forme_string += "#Carre,"+Integer.toString(f.getR())+","+Integer.toString(f.getG())+","+Integer.toString(f.getB())+","+Integer.toString(f.getX())+","+Integer.toString(f.getY());
                else list_forme_string += "#"+f.getLabel()+","+Integer.toString(f.getR())+","+Integer.toString(f.getG())+","+Integer.toString(f.getB())+","+Integer.toString(f.getX())+","+Integer.toString(f.getY());
              }
              
              try{
                bus.sendMsg("Formes Liste="+list_forme_string);
                Thread.sleep(50);
              }
              catch (IvyException ie) {}
              catch(InterruptedException ie){}
              
            }
        }
  });
  thread_forme.start();
  
  size(1600,1000);
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
  
  buttonClear.display();
}

void mousePressed(){
  if (mouseButton == LEFT) {
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
    
    if(buttonClear.isMouseOver(mouseX,mouseY)){
      ivyClick.deleteAll();
      buttonClear.reinit(); //ne pas afficher en selectionné
      for(Button b : buttonCouleur){ //remise par defauts des boutons couleurs
         b.reinit();
    }
      return;
    }
  
    ivyClick.traitementSouris(mouseX,mouseY); 
  }else{
     for(Forme f: formes){
        if(f.isMouseOver(mouseX,mouseY)){
          ivyClick.deleteForm(f);
          return;
        }
     }
  }
}

void mouseMoved(){
   ivyClick.positionSouris(mouseX,mouseY); 
}

ArrayList<Forme> getForme(){
  print(formes.size());
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
  for(int i = 0; i < formes.size(); i++){
     if(formes.get(i).getIndex() == index){
        formes.remove(i); 
     }
  }
}

void delete_all(){
  formes.removeAll(formes);
}

void modify_color(int r, int g, int b, int index){
  for(int i = 0; i < formes.size(); i++){
     if(formes.get(i).getIndex() == index){
        Forme forme_tmp = formes.get(i);
        forme_tmp.setR(r);
        forme_tmp.setG(g);
        forme_tmp.setB(b);  
     }
  }
}

void move_shape(int x, int y,int index){
  for(int i = 0; i < formes.size(); i++){
     if(formes.get(i).getIndex() == index){
        Forme forme_tmp = formes.get(i);
        forme_tmp.setX(x);
        forme_tmp.setY(y); 
     }
  }
}
