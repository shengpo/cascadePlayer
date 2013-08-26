public class Circle {
    private PGraphics pg = null;
    
    private float x = 0;
    private float y = 0;
    private float tx = 0;
    private float ty = 0;
    
    private int circleColor = 0;
    private float diameter = 10; 
    
    private int step = 30;
    
    
    public Circle(PGraphics pg){
        this.pg = pg;
        
        x = random(client.getMWidth());
        y = random(client.getMHeight());
        tx = random(client.getMWidth());
        ty = random(client.getMHeight());
        
        circleColor = color(random(256), random(256), random(256));
        diameter = random(10, 100);
    }
    
    
    public void update(){
        x = x + (tx-x)/step;
        y = y + (ty-y)/step;
        
        if(dist(x, y, tx, ty) < 0.1){
            tx = random(client.getMWidth());
            ty = random(client.getMHeight());
        }
    }
    
    
    public void show(){
        pg.stroke(38, 41, 44, 128);
        pg.fill(circleColor, 100);
        pg.ellipse(x, y, diameter, diameter);
    }
}
