/*
ImageSource 這個 class 是一個必須被客製化的 class
您可以照您的需求來制定這個 class 的內容，但必須 implements ImageSourceInterface !
*/

public class ImageSource implements ImageSourceInterface{
    private Movie movie = null;
    private PGraphics pg = null;
    private boolean isStart = false;
    
    
    
    public ImageSource(PApplet papplet, String videoFileName){
        pg = createGraphics(client.getLWidth(), client.getLHeight(), P2D);
        pg.beginDraw();
        pg.background(0);
        pg.endDraw();

        movie = new Movie(papplet, videoFileName);
        movie.play();
        movie.jump(0);
        movie.pause();
    }
    
    
    public void update(){
        /*
        不使用 loop() 的原因：讓兩個 cascadePlayer 重頭播放時，避免不同步的現象在每次重播時一直擴大
        */

        if(!isStart){
//            movie.loop();
            movie.play();
            isStart = true;
        }
        
        if (movie.available() == true) {
            movie.read(); 
        }
        
        if(movie.time() >= movie.duration()){
//            movie.stop();
//            movie.play();
            movie.jump(0);
            movie.pause();
            isStart = false;
        }
    }
    
    
    public void render(){
        pg.beginDraw();
//        pg.pushMatrix();                            //此範例不需要
//        pg.translate(-imageShiftX, -imageShiftY);   //此範例不需要

        pg.image(movie, 0, 0, client.getLWidth(), client.getLHeight());

//        pg.popMatrix();                             //此範例不需要
        pg.endDraw();
    }
    

    public PImage getImage(){
        return pg;
    }
}
