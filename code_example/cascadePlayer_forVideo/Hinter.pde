public class Hinter {
    private String hint = "";
    private float alpha = 255;
    private float alphaDelta = -5;
    
    
    public Hinter(String hint){
        this.hint = hint;
        
        PFont myFont = createFont("Georgia", 32);
        textFont(myFont);
        textAlign(CENTER, CENTER);
    }
    
    public void showHint(){
        if(alpha > 10){
            noStroke();
            fill(255, alpha);
            rect(0, height/2-20, width, 40);
            
            fill(255, 0, 0, alpha);
            text(hint, width/2, height/2);
            
            alpha = alpha + alphaDelta;
        }
    }
}
