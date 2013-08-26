/*
ImageSource 這個 class 是一個必須被客製化的 class
您可以照您的需求來制定這個 class 的內容，但必須 implements ImageSourceInterface !
*/

public class ImageSource implements ImageSourceInterface{
    private PApplet papplet = null;
    private PGraphics pg = null;
    
    private ArrayList<Circle> circleList = null;
    
    
    
    public ImageSource(PApplet papplet){
        this.papplet = papplet;
        
        pg = createGraphics(client.getLWidth(), client.getLHeight(), P2D);
        pg.beginDraw();
        pg.background(255);
        pg.endDraw();
        
        circleList = new ArrayList<Circle>();
        for(int i=0; i<50; i++){
            circleList.add(new Circle(pg));
        }
    }
    
    
    public void update(){
        for(int i=0; i<circleList.size(); i++){
            circleList.get(i).update();
        }
    }
    
    
    public void render(){
        pg.beginDraw();
        pg.background(255);
        pg.pushMatrix();
        pg.translate(-imageShiftX, -imageShiftY);
        
        for(int i=0; i<circleList.size(); i++){
            circleList.get(i).show();
        }
        
        pg.popMatrix();
        pg.endDraw();
    }
    

    public PImage getImage(){
        return pg;
    }
}
