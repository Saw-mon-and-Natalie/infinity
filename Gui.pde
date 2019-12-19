import controlP5.*;

class Gui {
    private PApplet theParent;
    private ControlP5 cp5;
    private ColorPicker cpa, cpb;

    private boolean hideGUI = false;

    public Gui(PApplet theParent) {
        this.theParent = theParent;

        cp5 = new ControlP5(this.theParent);
    }

    public void setGUI(){
        this.addSlider("zoom", 0.00, 2.00, 1.00, 10, 10, 200, 14);
        this.addSlider("rotationAngle", -90.00, 90.00, 10.00, 10, 30, 200, 14); 
         
        this.addSlider("dA", 0.00, 2.00, 1.00, 10, 50, 200, 14);
        this.addSlider("dB", 0.00, 2.00, 0.50, 10, 70, 200, 14);
        this.addSlider("f", 0.00, .20, 0.0540, 10, 90, 200, 14);
        this.addSlider("k", 0.00, .20, 0.0620, 10, 110, 200, 14);
        this.addSlider("dt", 0.0, 2.0, 1.0, 10, 1300, 200, 14);
        
        this.addSlider("s11", -0.20, 0.20,  0.16, 220, 10, 200, 14);
        this.addSlider("s12", -0.20, 0.20, -0.13, 220, 30, 200, 14);  
        this.addSlider("s21", -0.20, 0.20,  0.02, 220, 50, 200, 14);
        this.addSlider("s22", -0.20, 0.20,  0.04, 220, 70, 200, 14);
        
        cpa = cp5.addColorPicker("pickera")
                .setPosition(10, 140)
                .setColorValue(color(0, 0, 0, 0));
        cpb = cp5.addColorPicker("pickerb")
                .setPosition(10, 200)
                .setColorValue(color(255, 255, 255, 0));
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
