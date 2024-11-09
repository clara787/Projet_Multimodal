import fr.dgac.ivy.*;
import java.util.*;

class MoteurMultiModal{
  int cursorX;
  int cursorY;
  ArrayList<Integer> lastColor;
  String lastForme;
  Forme selectedForme;
  Forme takeForme;
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
       
       bus.bindMsg("^PyVocal msg=(.*)",new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
           print(args[0]);
           messageReceiveOral(args[0]);
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
       
       bus.bindMsg("^PyMove msg=(.*)", new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){  
           messageReceiveGeste(args[0]);
         }
       });
       
    }catch(IvyException e){}
  }
  
  void messageReceiveOral(String message){
    ArrayList<String> parsed = new ArrayList<>(Arrays.asList(message.split(" ")));
    
    if(parsed.contains("vert") || parsed.contains("verte")){
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
    }else if(parsed.contains("carrÃ©")){
        lastForme = "Carré";
    }
    
    if(parsed.contains("modifie") || parsed.contains("modifier")){
        if(parsed.contains("rectangle")||parsed.contains("cercle")||parsed.contains("triangle")||parsed.contains("carrÃ©")){
          
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                     modify_color(lastColor.get(0), lastColor.get(1), lastColor.get(2), formes.get(i).getIndex()); 
                     return;
                  }
              }
        }else{
          modify_color(lastColor.get(0), lastColor.get(1), lastColor.get(2), selectedForme.getIndex()); 
          return;
        }
    }else if(parsed.contains("supprime") || parsed.contains("supprimer")){
        if(parsed.contains("rectangle")||parsed.contains("cercle")||parsed.contains("triangle")||parsed.contains("carrÃ©")){
          if(parsed.contains("rouge")||parsed.contains("vert")|| parsed.contains("verte") ||parsed.contains("bleu")){
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                     if(formes.get(i).getCouleur().get(0).equals(lastColor.get(0)) && formes.get(i).getCouleur().get(1).equals(lastColor.get(1)) && formes.get(i).getCouleur().get(2).equals(lastColor.get(2))){
                         delete_shape(formes.get(i).getIndex()); 
                         return;
                      }
                  }
              }
          }else{
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                         delete_shape(formes.get(i).getIndex()); 
                         return;
                      }
              }
          }
        }else{
          delete_shape(selectedForme.getIndex());
          return;
        }
    }else if(parsed.contains("déplace")||parsed.contains("dÃ©place")||parsed.contains("dÃ©placer")){
        if(parsed.contains("rectangle")||parsed.contains("cercle")||parsed.contains("triangle")||parsed.contains("carrÃ©")){
          if(parsed.contains("rouge")||parsed.contains("vert")||parsed.contains("verte") || parsed.contains("bleu")){
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                      if(formes.get(i).getCouleur().equals(lastColor)){
                         move_shape(cursorX, cursorY, formes.get(i).getIndex()); 
                         return;
                      }
                  }
              }
          }else{
              ArrayList<Forme> formes = getForme();
              for(int i = 0; i<formes.size(); i++){
                  if(formes.get(i).getLabel().equals(lastForme)){
                         move_shape(cursorX, cursorY, formes.get(i).getIndex()); 
                         return;
                      }
              }
          }
        }else{
          move_shape(cursorX, cursorY, selectedForme.getIndex());
          return;
        }
        return;
    }
    
    if(parsed.contains("dessiner")||parsed.contains("créer")||parsed.contains("crÃ©er") || parsed.contains("dessine")||parsed.contains("crÃ©e")){
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
     }else if(action.equals("DeleteForme")){
       delete_shape(int(list[1]));
     }else if(action.equals("DeleteAll")){
       delete_all();
     }else{
        draw_shape(cursorX,cursorY,lastColor.get(0),lastColor.get(1),lastColor.get(2),getForme().size(),lastForme);
     }
  }
  
  void messageReceiveGeste(String message){
    String[] list = message.split(",");
    String action = list[0];
    print(action);
    if(action.equals("newtake")){
      for(Forme f : formes){
         if(f.isMouseOver(int(list[1]),int(list[2]))){
            takeForme = f;
            print(f.getIndex());
            move_shape(int(list[1]),int(list[2]),takeForme.getIndex());
            return;
         }
      }
    }else if(action.equals("take")){
      if(takeForme == null)return;
      move_shape(int(list[1]),int(list[2]),takeForme.getIndex());
      if(takeForme.x >= 1440 && takeForme.y >= 55){
         delete_shape(takeForme.getIndex());
       }
      return;
    }else if(action.equals("release")){
       takeForme = null;
       return;
    }
    if(message.equals("CarrÃ©"))message = "Carré";
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
