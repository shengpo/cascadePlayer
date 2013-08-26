/*
ImageSource 這個 class 是一個必須被客製化的 class
您可以照您的需求來制定這個 class 的內容，但必須 implements ImageSourceInterface !
*/

/*這個class使用的方法不好*/

public class ImageSource2 implements ImageSourceInterface{
    private Movie movie = null;
    private PGraphics pg = null;
    
    private float timing = 0;
    private int movieFrameRate = 30;    //可設定
    private float rateScale = 2;      //可設定
    
    
    public ImageSource2(PApplet papplet, String videoFileName){
        pg = createGraphics(client.getLWidth(), client.getLHeight(), P2D);
        pg.beginDraw();
        pg.background(0);
        pg.endDraw();

        movie = new Movie(papplet, videoFileName);

        // Pausing the video at the first frame. 
        movie.play();
        movie.jump(0);
        movie.pause();
    }
    
    
    public void update(){
        timing = timing + (1f/movieFrameRate)*rateScale;
        if(timing > movie.duration()){
            timing = 0;
        }
        
        movie.play();
        movie.jump(timing);
        movie.pause();
        
        
        if (movie.available() == true) {
            movie.read(); 
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
