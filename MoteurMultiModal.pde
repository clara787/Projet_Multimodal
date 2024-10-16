import fr.dgac.ivy.*;
import java.util.*;

class MoteurMultiModal{
  int cursorX;
  int cursorY;
  ArrayList<Integer> lastColor;
  String lastForme;
  Forme selectedForme;
  Ivy bus;
  
  MoteurMultiModal(){
    cursorX = 0;
    cursorY = 0;
    lastColor = new ArrayList<>();
    lastColor.add(0);
    lastColor.add(0);
    lastColor.add(0);
    
    lastForme = "";
    selectedForme = new Forme(0,0,0,0,0,0,"");
    
    try{
       bus = new Ivy("ListenMultiModalMotor","",null);
       bus.start("127.255.255.255:2010");
       
       bus.bindMsg("^sra5 Text=(.*) Confidence=(.*)",new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
           String temp = args[1].replace(',', '.');
           if(float(temp)>0.30)messageReceiveOral(args[0]);
         }
       });
       
       bus.bindMsg("^IvyClick Action=(.*)",new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
           messageReceiveClick(args[0]);
         }
       });
       
       bus.bindMsg("^OneDollarIvy Template=(.*) Confidence=(.*)", new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
            String temp = args[1].replace(',', '.');
            if(float(temp)>0.60)messageReceiveGeste(args[0]); 
         }
       });
       
    }catch(IvyException e){}
  }
  
  void messageReceiveOral(String message){
    println(message);
    ArrayList<String> parsed = new ArrayList<>(Arrays.asList(message.split(" ")));
    
    if(parsed.contains("vert")){
        lastColor.set(0,0);
        lastColor.set(1,255);
        lastColor.set(2,0);
    }else if(parsed.contains("rouge")){
        lastColor.set(0,255);
        lastColor.set(1,0);
        lastColor.set(2,0);
    }else if(parsed.contains("bleu")){
        lastColor.set(0,0);
        lastColor.set(1,0);
        lastColor.set(2,255);
    }
    
    if(parsed.contains("rectangle")){
        lastForme = "Rectangle";
    }else if(parsed.contains("cercle")){
        lastForme = "Cercle";
    }else if(parsed.contains("triangle")){
        lastForme = "Triangle";
    }
    
    if(parsed.contains("modifier")){
        if(parsed.contains("rectangle")||parsed.contains("cercle")||parsed.contains("triangle")||parsed.contains("carré")){
          if(parsed.contains("rouge")||parsed.contains("vert")||parsed.contains("bleu")){
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                      if(formes.get(i).getCouleur().equals(lastColor)){
                         //modifier_shape(i); 
                         return;
                      }
                  }
              }
          }else{
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                         //modifer_shape(i); 
                         return;
                      }
              }
          }
        }else{
          //modifier_shape(selectedForme.getIndex());
          return;
        }
    }else if(parsed.contains("supprimer")){
        if(parsed.contains("rectangle")||parsed.contains("cercle")||parsed.contains("triangle")||parsed.contains("carré")){
          if(parsed.contains("rouge")||parsed.contains("vert")||parsed.contains("bleu")){
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                      if(formes.get(i).getCouleur().equals(lastColor)){
                         //delete_shape(i); 
                         return;
                      }
                  }
              }
          }else{
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                         //delete_shape(i); 
                         return;
                      }
              }
          }
        }else{
          //delete_shape(selectedForme.getIndex());
          return;
        }
    }else if(parsed.contains("déplacer")){
        if(parsed.contains("rectangle")||parsed.contains("cercle")||parsed.contains("triangle")||parsed.contains("carré")){
          if(parsed.contains("rouge")||parsed.contains("vert")||parsed.contains("bleu")){
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                      if(formes.get(i).getCouleur().equals(lastColor)){
                         //move_shape(i); 
                         return;
                      }
                  }
              }
          }else{
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                         //move_shape(i); 
                         return;
                      }
              }
          }
        }else{
          //move_shape(selectedForme.getIndex());
          return;
        }
        return;
    }
    
    if(parsed.contains("dessiner")||parsed.contains("créer")){
        draw_shape(cursorX,cursorY,lastColor.get(0),lastColor.get(1),lastColor.get(2),getForme().size(),lastForme);
    }
  }
  
  //si bug pointeur ne vaut pas copie
  void messageReceiveClick(String message){
     String[] list = message.split(",");
     String action = list[0];
     if(action.equals("Move")){
       cursorX = int(list[1]);
       cursorY = int(list[2]);
     }else if(action.equals("BouttonCouleur")){
       if(list[1].equals("Vert")){
         lastColor.set(0,0);
         lastColor.set(1,255);
         lastColor.set(2,0);
       }else if(list[1].equals("Rouge")){
         lastColor.set(0,255);
         lastColor.set(1,0);
         lastColor.set(2,0);
       }else if(list[1].equals("Bleu")){
         lastColor.set(0,0);
         lastColor.set(1,0);
         lastColor.set(2,255);
       }
     }else if(action.equals("ClickForme")){
        for(Forme f : getForme()){
           if(f.getIndex()==int(list[1])){
              selectedForme = f; 
           }
        }
     }else if(action.equals("BouttonForme")){
        lastForme = list[1];
     }else{
        draw_shape(cursorX,cursorY,lastColor.get(0),lastColor.get(1),lastColor.get(2),getForme().size(),lastForme);
     }
  }
  
  void messageReceiveGeste(String message){
    message = message.replaceFirst(".",(message.charAt(0)+"").toUpperCase());
    lastForme = message;
  }
  
  void testPrint(){
     println("Diagnostic:");
     println("cursorX:"+cursorX);
     println("cursorY:"+cursorY);
     println("couleur:"+lastColor.get(0)+","+lastColor.get(1)+","+lastColor.get(2)+",");
     println("lastForme:"+lastForme);
     println("selectedFormeName:"+selectedForme.getIndex());
  }
}
