/******************************************************
cascadePlayer_forVideo
======================

此為利用 cascadePlayer 架構完成的一個同步影片播放器範例，提供參數設定、全螢幕播放，以及projection mapping校正。


TODO
----
- ImageSource能夠做mask (利用GLSL)


已知問題
-------
若是載入影片，目前測試為同時跑兩個 cascadePlayer 可得最好效果。若跑三個以上的 cascadePlayer 則有明顯稍稍不同步的狀況
    

Dependency
----------
- Most-Pixel-Ever library (bigscreens version)    https://github.com/shiffman/Most-Pixels-Ever-Processing/tree/bigscreens
- mappingtools library (version 0.0.3)            http://www.iact.umontreal.ca/mappingtools/


說明
----
- 需搭配 mpe server 使用
- 每個 cascadePlayer 都是 mpe client
- 請先了解 mpe (Most-Pixel-Ever library 的運作原理)
    - https://github.com/shiffman/Most-Pixels-Ever-Processing/wiki/How-This-Works
    - http://www.chris3000.com/portfolio/most-pixels-ever/
- mappingtools library 預設支援以下按鍵功能：
    - 按鍵 `c` ： 顯示/隱藏控制點
    - 按鍵 `d` ： reset 控制點為預設值
    - 按鍵 `s` ： 將控制點位置記錄下來，在 sketch 所在位置儲存成 presets.txt 檔
    - 按鍵 `p` ： 載入先前所儲存的控制點位置( presets.txt 檔)
- 目前支援四邊形(Quad)、貝茲曲面形(Bezier)、自由面(free)的 projection mapping 的投影校正
- cascadePlayer 每次只能使用一種 projection mapping 模式 (Quad, Bezier, or free)，且每個模式只會存在一個實體 (instance)，不會同時存在多個。
    - 例如：不能在每個 cascadePlayer 中使用兩個以上的四邊形(Quad) mapping
    - 註解：若有特殊需求，請自行修改 `WarpManager class`
- 每次開啟 cascadePlayer 均自動載入之前的 projection mapping 設定檔 (presets.txt)

    

使用方法
-------
- 設定檔皆放在 `setting` 資料夾 (`data`資料夾下)
    - `mpe.ini` 為 mpe 相關的參數設定
    - `player.ini` 為 cascadePlayer 相關的參數設定

- mpe server 用法
    - 先開啟終端機 (terminal)
    - 切換至 mpe server (mpeServer.jar) 所在位置的資料夾
    - 執行指令: `java -jar mpeServer.jar -debug1 -framerate30 -screens2`
    - 參數說明：
        - debug1 表示開啟 debug 資訊(sever端送出及接收的所有訊息)
        - debug0 表示不開啟 debug 資訊
        - framerate30 表示 server 端運行的 frame rate 為30，也就是說所有的 mpe client (cascadePlayer) 的 frame rate 都是30。30這個數值可依需求更改。
        - screens2 表示有2個 mpe client (cascadePlayer)，2這個數值可依實際情況更改。
    - 可參考：https://github.com/shiffman/Most-Pixels-Ever-Processing/wiki/Processing-Tutorial

- mpe server "必須"先啟動後，再啟動每個 cascadePlayer (此為 bigscreens version 的限制)

- 手動設定 projection mapping 參數
    - 按鍵 `c` ： 顯示/隱藏控制點
    - 按鍵 `d` ： reset 控制點為預設值
    - 按鍵 `s` ： 將控制點位置記錄下來，在 sketch 所在位置儲存成 presets.txt 檔
    - 按鍵 `p` ： 載入先前所儲存的控制點位置( presets.txt 檔)




 
Author Info
-----------
- Author:  Shen, Sheng-Po (http://shengpo.github.io)
- Development Environment: Processing 2.0.2
- Date:    2013.08.23
- License: CC BY-SA 3.0
******************************************************/



import mpe.client.*;
import mappingtools.*;
import processing.video.*;    //for ImageSource class


//for system
int playerX = 0;    //cascadePlayer在螢幕上的位置(x座標)
int playerY = 0;    //cascadePlayer在螢幕上的位置(y座標)

//for garbage collector
GarbageCollector gc = null;
float gcPeriodMinute = 5;    //設定幾分鐘做一次gc

//for projection mapping
WarpManager warpManager = null;
int mappingMode = 0;
int mappingGridResolution = 10;

//for mpe
TCPClient client = null;

//for ImageSource
ImageSource imageSource = null;
//ImageSource2 imageSource = null;
String videoFileName = "";
//imageShiftX跟imageShiftY在此範例中沒用到
int imageShiftX = 0;    //for mpeHackForCascadePlayer()
int imageShiftY = 0;    //for mpeHackForCascadePlayer()

//for Hinter
Hinter hinter = null;



//set frame undecorated to emulate full screen
void init(){
    frame.dispose();  
    frame.setUndecorated(true);  
    super.init();
}


void setup(){
    //loading initial files first
    loadingSetting();

    size(client.getLWidth(), client.getLHeight(), P2D);
    background(0);

    //for WarpManager
    warpManager = new WarpManager(this, mappingMode, mappingGridResolution);
    
    //for ImageSource
    imageSource = new ImageSource(this, videoFileName);
//    imageSource = new ImageSource2(this, videoFileName);

    //for garbage collector
    gc = new GarbageCollector(gcPeriodMinute);
    gc.start();

    //set frame location to emulate full screen
    frame.setLocation(playerX, playerY);

    //start mpe client!
    client.start();
}

//keep this method empty, let the mpe's event handling to handle this
void draw(){
}


// Triggered by the client whenever a new frame should be rendered.
// All synchronized drawing should be done here when in auto mode.
void frameEvent(TCPClient c) {
    background(0);
    
    //rendering source image
    imageSource.update();
    imageSource.render();
    
    //texture-mapping source image
    warpManager.mapping(imageSource.getImage());
    
    //show hint
    if(hinter != null)    hinter.showHint();
    
    // read any incoming messages
    if (c.messageAvailable()) {
        String[] msg = c.getDataMessage();
        //...
    }
}


// broadcast some messages to other cascadePlayers
// this method needs to be called manually, it will not be called automatically
void broadcasting() {
/** never include a ":" when broadcasting your message **/

// example:
//    int x = mouseX + client.getXoffset();
//    int y = mouseY + client.getYoffset();
//    client.broadcast(x + "," + y);
}


void keyPressed(){
    if(key == 'd'){
        hinter = new Hinter("RESET mapping");
    }

    if(key == 's'){
        hinter = new Hinter("SAVE mapping");
    }

    if(key == 'p'){
        hinter = new Hinter("LOAD mapping");
    }
}

