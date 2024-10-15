import fr.dgac.ivy.*;

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
    selectedForme = new Forme(0,0,0,0,0,0);
    
    try{
       bus = new Ivy("ListenMultiModalMotor","",null);
       bus.start("127.255.255.255:2010");
       
       bus.bindMsg("^sra5 Parsed=(.*) Confidence=(.*) NP=.*",new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
           if(float(args[1])>0.60)messageReceiveOral(args[0]);
         }
       });
       
       bus.bindMsg("^IvyClick Action=(.*)",new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
           messageReceiveClick(args[0]);
         }
       });
       
       bus.bindMsg("^OneDollarIvy Template=(.*) Confidence=(.*)", new IvyMessageListener(){
         public void receive(IvyClient client, String[] args){
            if(float(args[1])>0.60)messageReceiveGeste(args[0]); 
         }
       });
       
    }catch(IvyException e){}
  }
  
  void messageReceiveOral(String message){
    String[] parsed = message.split("=");
    
  }
  
  //si bug pointeur ne vaut pas copie
  void messageReceiveClick(String message){
     String[] list = message.split(",");
     String action = list[0];
     if(action.equals("Move")){
       cursorX = int(list[1]);
       cursorY = int(list[2]);
     }else if(action.equals("BouttonCouleur")){
       lastColor.set(0,int(list[1]));
       lastColor.set(1,int(list[2]));
       lastColor.set(2,int(list[3]));
     }else if(action.equals("ClickForme")){
        for(Forme f : getForme()){
           if(f.getIndex()==int(list[1])){
              selectedForme = f; 
           }
        }
     }else if(action.equals("BouttonForme")){
        lastForme = list[2];
     }else{
        //mettre la fonction pour dessiner une forme 
     }
  }
  
  void messageReceiveGeste(String message){
    lastForme = message;
  }
}
