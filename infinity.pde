import processing.video.*;
Capture cam;

Gui gui;
MidiController midiController;

GrayScott gs;
PingPong pp;

// switch order of shaders
boolean switchShaders = false;

// feedback loop variables
float zoom1, zoom2;
float angle1, angle2;
float w0, w1, w2, w3, w4;
float x, y;
float time;

// grayscott variables
float dA, dB, f, k, dt;
float s11, s12, s21, s22;

// kinect control variables
int th = 0;
float angle = 0;

KinectTracker tracker;

void setup() {
  //fullScreen(P2D);
  size(1600, 800, P2D);

  tracker = new KinectTracker(this);

  guiInit();
  
  pp = new PingPong(this, "feedbackloop.glsl", "sharpen.glsl");
  gs = new GrayScott(this, "grayscott.glsl", "render.glsl");
  
  midiController = new MidiController(this, gui);

}
void draw() {
  time = millis() / 1000.0;

  if(switchShaders) {
    gs.draw(tracker.getCanvas());
    pp.draw(gs.output());
    image(pp.output(), 0, 0);
  } else {
    pp.draw(tracker.getCanvas());
    gs.draw(pp.output());
    image(gs.output(), 0, 0);
  }
  
}

void keyPressed(){
  switch(key) {
    case('h'):
      gui.hideGUI();
      break;
    case('z'):
      tracker.setThreshold(5);
      break;
    case('x'):
      tracker.setThreshold(-5);
      break;
    case('c'):
      tracker.setTilt(1);
      break;
    case('v'):
      tracker.setTilt(-1);
      break;
    case('s'):
      switchShaders = !switchShaders;
      break;
    default:
      break;
  }
  
}

public void midiInputs(int n) {
  println(n, gui.cp5.get(ScrollableList.class, "midiInputs").getItem(n));
  String midiInputName = (String) gui.cp5.get(ScrollableList.class, "midiInputs").getItem(n).get("text");
  midiController.init(midiInputName);
}

public void controlEvent(ControlEvent c){
}


public void camInit() {
  cam = new Capture(this);
  cam.start(); 
}

public void guiInit() {
  gui = new Gui(this);
  gui.setGUI();
}
