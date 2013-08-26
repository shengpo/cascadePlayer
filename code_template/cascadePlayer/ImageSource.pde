/*
ImageSource 這個 class 是一個必須被客製化的 class
您可以照您的需求來制定這個 class 的內容，但必須 implements ImageSourceInterface !

建議使用 PGraphics 來繪製畫面，以作為 WarpManager.mapping() 的影像來源
(使用 PGraphics 為參考作法，您可根據您的實際需求更改作法)
*/

public class ImageSource implements ImageSourceInterface{
    private PGraphics pg = null;
    
    
    public ImageSource(){
        pg = createGraphics(client.getLWidth(), client.getLHeight(), P2D);
        pg.beginDraw();
        pg.background(0);
        pg.endDraw();
    }
    
    
    public void update(){
        //update something here ...
    }
    
    
    public void render(){
        pg.beginDraw();
        pg.background(0);
        pg.pushMatrix();
        pg.translate(-imageShiftX, -imageShiftY);
        
        //draw something in pg here ...

        pg.popMatrix();
        pg.endDraw();
    }
    

    public PImage getImage(){
        return pg;
    }
}
