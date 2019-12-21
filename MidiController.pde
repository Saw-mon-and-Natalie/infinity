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
        if(channel == 9) {
          switch(number) {
            case(0):
              changeParameter("dA", value);
              break;
            case(1):
              changeParameter("dt", value);
              break;
            case(2):
              changeParameter("zoom1", value);
              break;
            case(3):
              changeParameter("zoom2", value);
              break;
            case(4):
              changeParameter("dB", value);
              break;
            case(5):
              break;
            case(6):
              changeParameter("angle1", value);
              break;
            case(7):
              changeParameter("angle2", value);
              break;
            case(8):
              changeParameter("f", value);
              break;
            case(9):
              break;
            case(10):
              changeParameter("x", value);
              break;
            case(11):
              changeParameter("y", value);
              break;
            case(12):
              changeParameter("k", value);
              break;
            default:
              break;
          }
        }
        
        if(channel == 0) {
          switch(number) {
            case(16):
              changeParameter("s11", value);
              break;
            case(18):
              changeParameter("w0", value);
              break;
            case(19):
              changeParameter("w4", value);
              break;
            case(20):
              changeParameter("s12", value);
              break;
            case(22):
              changeParameter("w1", value);
              break;
            case(24):
              changeParameter("s21", value);
              break;
            case(26):
              changeParameter("w2", value);
              break;
            case(28):
              changeParameter("s22", value);
              break;
            case(30):
              changeParameter("w3", value);
              break;
            default:
              break;
          }
        }
        
        if(channel == 10 && number == 15) {
          switchShaders = (value == 0) ? false : true;
        }
    }
    
    public void changeParameter(String name, float value) {
      // gui.cp5.get(ScrollableList.class, "midiInputs")
      // gui.cp5.getController("name").setValue(float)
      Slider s = this.gui.cp5.get(Slider.class, name);
      float min = s.getMin();
      float max = s.getMax();
      float v = value / 127.0 * (max - min) + min;
      
      s.setValue(v);
    }
    
}
