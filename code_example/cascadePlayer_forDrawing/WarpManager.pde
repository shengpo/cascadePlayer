public class WarpManager {
    private PApplet papplet = null;
    
    private int mode = 0;            // projection mapping 模式：0:不使用(None)、1:四邊形(Quad)、2:貝茲曲面形(Bezier)、3:自由面(free)
    private int gridResolution = 10; // grid resolution 參數僅使用在四邊形(Quad)、貝茲曲面形(Bezier)，其他不使用
    
    private QuadWarp qw = null;
    private BezierWarp bw = null;
    private FreeWarp fw = null;
    
    private boolean hasPresets = false;


    public WarpManager(PApplet papplet, int mode, int gridResolution){
        this.papplet = papplet;
        this.mode = mode;
        this.gridResolution = gridResolution;
                
        //check 是否之前已設定過 projection mapping 參數
        //若有，則自動載入設定檔 (presets.txt) 
        if(loadStrings(sketchPath("presets.txt")) != null){
            hasPresets = true;
            println("|| presets.txt is existed! loading settings for projection mapping");
        }

        setWarp();
    }
    
    
    public void mapping(PImage img){
        if(img == null) return;
        
        switch(mode){
            case 0:    //none
                image(img, (width-img.width)/2, (height-img.height)/2);
                break;
            case 1:    //quad
                if(qw != null)    qw.render(img);
                break;
            case 2:    //bezier
                if(bw != null)    bw.render(img);
                break;
            case 3:    //free
                if(fw != null)    fw.render(img);
                break;
            default:   //none
                image(img, (width-img.width)/2, (height-img.height)/2);
                break;
        }
    }


    private void setWarp(){
        switch(mode){
            case 0:    //none
                qw = null;
                bw = null;
                fw = null;
                println("|| mapping mode: None");
                break;
            case 1:    //quad
                qw = new QuadWarp(papplet, gridResolution);
                qw.showControls(false);    //使得一開始不會秀出控制點
                if(hasPresets == true)    qw.loadPresets();
                println("|| mapping mode: Quad");
                break;
            case 2:    //bezier
                bw = new BezierWarp(papplet, gridResolution);
                bw.showControls(false);    //使得一開始不會秀出控制點
                if(hasPresets == true)    bw.loadPresets();
                println("|| mapping mode: Bezier");
                break;
            case 3:    //free
                fw = new FreeWarp(papplet);
                fw.showControls(false);    //使得一開始不會秀出控制點
                if(hasPresets == true)    fw.loadPresets();
                println("|| mapping mode: free");
                break;
            default:   //none
                qw = null;
                bw = null;
                fw = null;
                mode = 0;
                println("|| mapping mode: None");
                break;
        }
    }    
    

    public int getMode(){
        return mode;
    }
}
