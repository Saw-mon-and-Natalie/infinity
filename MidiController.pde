import themidibus.*;
import java.util.*;

public class MidiController {

    private MidiBus myBus;
    private PApplet papplet;
    private String[] availableInputs;
    private Gui gui;
    
    public MidiController(PApplet parent, Gui gui) {
        // MidiBus.list();
        papplet = parent;
        this.gui = gui;
        availableInputs = MidiBus.availableInputs();
        //         myBus = new MidiBus(this, -1, -1);
        this.gui.addScrollableList(
          "midiInputs", 
          10, papplet.g.height - 48, 200, 10, 
          Arrays.asList(availableInputs)
        );
    }
    
    public void init(String inputName) {
      myBus = new MidiBus(this, inputName, -1);
    }
    
    public void controllerChange(int channel, int number, int value, long timestamp, String bus_name) {
        println("channel:", channel, "number:", number, "value:", value, "timestamp:", timestamp, "bus_name:", bus_name);
    }
    
}
