import fr.dgac.ivy.*;

Ivy bus;

public class IvyClick{
  IvyClick(){
    try{
      bus = new Ivy("IvyClick","IvyClick is ready",null);
      bus.start("127.255.255.255:2010");
    }
    catch(IvyException ie){
      println("Exception");
    }
  }
  
  void traitementSouris(int x, int y){
    try{
     bus.sendMsg("IvyClick Action=Click X="+x+" Y="+y);
    }
    catch(IvyException ie){
      println("Exception");
    }
  }
  
  void positionSouris(int x, int y){
    try{
     bus.sendMsg("IvyClick Action=Move,"+x+","+y);
    }
    catch(IvyException ie){}
  }
  
  void appuiButtonCouleur(Button b){
    try{
      bus.sendMsg("IvyClick Action=BouttonCouleur,"+b.getLabel());
    }
    catch(IvyException ie){}
  }
  
  void appuiButtonForme(Button b){
    try{
      bus.sendMsg("IvyClick Action=BouttonForme,"+b.getLabel());
    }
    catch(IvyException ie){}
  }
  
  void appuiForme(Forme f){
    try{
      bus.sendMsg("IvyClick Action=ClickForme,"+f.getIndex());
    }
    catch(IvyException ie){}
  }
  
  void deleteForm(Forme f){
     try{
       bus.sendMsg("IvyClick Action=DeleteForme,"+f.getIndex());
     }
     catch(IvyException ie){}
  }
}
