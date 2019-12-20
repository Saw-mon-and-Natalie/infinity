import controlP5.*;

class Gui {
    private PApplet theParent;
    private ControlP5 cp5;
    // private ColorPicker cpa, cpb;

    private boolean hideGUI = false;

    public Gui(PApplet theParent) {
        this.theParent = theParent;

        cp5 = new ControlP5(this.theParent);
    }

    public void setGUI(){
        this.addSlider("zoom1" ,   -2.00,   4.00,  1.00, 10, 10, 600, 14);
        this.addSlider("angle1", -180.00, 180.00, 90.00, 10, 30, 600, 14); 

        this.addSlider("zoom2" ,   -2.00,   4.00,  1.00, 10, 50, 600, 14);
        this.addSlider("angle2", -180.00, 180.00, 45.00, 10, 70, 600, 14); 
        this.addSlider("x"     , -theParent.g.width/2, theParent.g.width/2, 100, 10, 90, 600, 14);
        this.addSlider("y"     , -theParent.g.height/2, theParent.g.height/2, 100, 10, 110, 600, 14);

        this.addSlider("dA", 0.00, 2.00, 1.00  , 10, 150, 600, 14);
        this.addSlider("dB", 0.00, 2.00, 0.50  , 10, 170, 600, 14);
        this.addSlider("f" , 0.00, 0.20, 0.0540, 10, 190, 600, 14);
        this.addSlider("k" , 0.00, 0.20, 0.0620, 10, 210, 600, 14);
        this.addSlider("dt", 0.00, 2.00, 1.0   , 10, 230, 600, 14);
        
        this.addSlider("s11", -0.20, 0.20,  0.16, 670, 10, 600, 14);
        this.addSlider("s12", -0.20, 0.20, -0.13, 670, 30, 600, 14);  
        this.addSlider("s21", -0.20, 0.20,  0.02, 670, 50, 600, 14);
        this.addSlider("s22", -0.20, 0.20,  0.04, 670, 70, 600, 14);
        
        this.addSlider("w0", -5, 5, 1.0, 670, 110, 600, 14);
        this.addSlider("w1", -5, 5, 1.0, 670, 130, 600, 14);  
        this.addSlider("w2", -5, 5, 1.0, 670, 150, 600, 14);
        this.addSlider("w3", -5, 5, 1.0, 670, 170, 600, 14);
        this.addSlider("w4", -5, 5, 1.0, 670, 190, 600, 14);
        
        //cpa = cp5.addColorPicker("pickera")
        //        .setPosition(10, 140)
        //        .setColorValue(color(0, 0, 0, 0));
        //cpb = cp5.addColorPicker("pickerb")
        //        .setPosition(10, 200)
        //        .setColorValue(color(255, 255, 255, 0));
    }

    private void addSlider(String name, float min, float max, float curr, int x, int y, int w, int h) {
        cp5.addSlider(name, min, max, curr, x, y, w, h)
            .setColorValue(color(255))
            .setColorActive(color(155))
            .setColorForeground(color(155))
            .setColorLabel(color(50))
            .setColorBackground(color(50));
    }

    public void hideGUI() {
        hideGUI = !hideGUI;
        if(hideGUI) {
            cp5.hide();
        } else {
            cp5.show();
        }
    }
}
