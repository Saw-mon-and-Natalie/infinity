import themidibus.*;
import java.util.*;
import controlP5.*;

public class MidiController {

    private MidiBus myBus;
    private PApplet papplet;
    private String[] availableInputs;
    private Gui gui;
    private ScrollableList midiList;
    private CallbackListener cb;
    
    public MidiController(PApplet parent, Gui gui) {
        MidiBus.list();
        papplet = parent;
        this.gui = gui;
        availableInputs = MidiBus.availableInputs();
        //         myBus = new MidiBus(this, -1, -1);
        midiList = this.gui.addScrollableList("midiInputs", 10, papplet.g.height - 200, 200, 200);
        midiList.addItems(availableInputs);
        
        //cb = new CallbackListener() {
        //  public void controlEvent(CallbackEvent theEvent) {
        //    println("im changed");
        //  }
        //};
        
        //midiList.onChange(cb);
    }
    
    public void init(String inputName) {
      myBus = new MidiBus(this, inputName, -1);
    }
    
    public void controllerChange(int channel, int number, int value, long timestamp, String bus_name) {
        println("channel:", channel, "number:", number, "value:", value, "timestamp:", timestamp, "bus_name:", bus_name);
    }
    
    public void changeParameter(String name, float value) {
      // gui.cp5.get(ScrollableList.class, "midiInputs")
      // gui.cp5.getController("name").setValue(float)
      Slider s = gui.cp5.(Slider.class, name);
      float min = s.getMin();
      float max = s.getMax();
      float v = value / 127.0 * (max - min) + min;
      
      s.setValue(v);
    }
    
}
