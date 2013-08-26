void loadingSetting(){
    //loading mpe's initial setting
    client = new TCPClient(sketchPath("setting/mpe.ini"), this);

    //loading cascadePlayer's initial setting
    String[] lines = loadStrings(sketchPath("setting/player.ini"));

    if(lines == null)    return;
    
    for(int i=0; i<lines.length; i++){
        if(!lines[i].equals("") && !lines[i].startsWith("#")){
            if(lines[i].startsWith("screenLocation=") && lines[i].endsWith(";")){
                String values = lines[i].substring("screenLocation=".length(), lines[i].indexOf(";"));
                String[] datas = split(values, ",");
                playerX = int(datas[0]);
                playerY = int(datas[1]);
            }

            if(lines[i].startsWith("randomSeed=") && lines[i].endsWith(";")){
                String value = lines[i].substring("randomSeed=".length(), lines[i].indexOf(";"));

                //若有使用到random()，則必須先設定randomSeed()，以讓所有的player所產生的random同步跟一致
                if(int(value) >= 0){
                    randomSeed(int(value));
                }
            }
            
            if(lines[i].startsWith("mappingMode=") && lines[i].endsWith(";")){
                String value = lines[i].substring("mappingMode=".length(), lines[i].indexOf(";"));
                
                mappingMode = int(value);
            }

            if(lines[i].startsWith("mappingGridResolution=") && lines[i].endsWith(";")){
                String value = lines[i].substring("mappingGridResolution=".length(), lines[i].indexOf(";"));
                
                mappingGridResolution = int(value);
            }

            //other settings here
            //...
        }
    }

    mpeHackForCascadePlayer();
}


/*
因為在 mpe 中使用了 mappingtools library 做 projection mapping，又 mapping 內容來自 ImageSource class
使得 mpe 在 sketch 中設定 localLocation (位於 mpe.ini 中)的功能失效
所以需要我們自己在 ImageSource class 中 把他補回來
*/
void mpeHackForCascadePlayer(){
    //loading mpe.ini for hakcing
    String[] lines = loadStrings(sketchPath("setting/mpe.ini"));

    if(lines == null)    return;
    
    for(int i=0; i<lines.length; i++){
        if(!lines[i].equals("") && !lines[i].startsWith("#")){
            if(lines[i].startsWith("imageShift=") && lines[i].endsWith(";")){
                String values = lines[i].substring("imageShift=".length(), lines[i].indexOf(";"));
                String[] datas = split(values, ",");
                imageShiftX = int(datas[0]);
                imageShiftY = int(datas[1]);
            }
        }
    }
}
