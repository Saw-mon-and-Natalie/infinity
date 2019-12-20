import processing.video.*;
Capture cam;

Gui gui;

PShader feedbackLoop, sharpen, grayscott, render;

GrayScott gs;
PingPong pp;

PGraphics out1, out2;

// feedback loop variables
float zoom1, zoom2;
float angle1, angle2;
float w0, w1, w2, w3, w4;
float x, y;
float time;

// grayscott variables
float dA = 1.0;
float dB = 0.5;
float f  = 0.0545;
float k  = 0.062;
float dt = 1.0;

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
  grayscottInit();
  feedbackLoopInit();
  
  // camInit();
}
void draw() {
  time = millis() / 1000.0;
  grayscottDraw();
  feedbackLoopDraw();
  
  image(out2, 0, 0);
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
    default:
      break;
  }
  
}

//public void controlEvent(ControlEvent c){
//    if(c.isFrom(cpa)) {
//    float r = c.getArrayValue(0)/255;
//    float g = c.getArrayValue(1)/255;
//    float b = c.getArrayValue(2)/255;
//    render.set("ca",new PVector(r,g,b));
    
//    //println("event \tred:"+r+"\tgreen:"+g+"\tblue:"+b);
//  }
//  if(c.isFrom(cpb)) {
//    float r = c.getArrayValue(0)/255;
//    float g = c.getArrayValue(1)/255;
//    float b = c.getArrayValue(2)/255;
//    render.set("cb",new PVector(r,g,b));

//    //println("event \tred:"+r+"\tgreen:"+g+"\tblue:"+b);
//  }
//}

public void feedbackLoopInit() {
  zoom1 = 1.0;
  zoom2 = 1.0;

  angle1 = 90.0;
  angle2 = 45.0;

  x = 100;
  y = 100;

  time = 0.0;
  
  w0 = 1.0;
  w1 = 1.0;
  w2 = 1.0;
  w3 = 1.0;
  w4 = 1.0;
  

  feedbackLoop = loadShader("feedbackloop.glsl"); 
  feedbackLoop.set("resolution", float(width), float(height));

  feedbackLoop.set("zoom1", zoom1);
  feedbackLoop.set("zoom2", zoom2);

  feedbackLoop.set("angle1", angle1);
  feedbackLoop.set("angle2", angle2);

  feedbackLoop.set("x", x);
  feedbackLoop.set("y", y);

  feedbackLoop.set("time", time);
  
  feedbackLoop.set("w0", w0);
  feedbackLoop.set("w1", w1);
  feedbackLoop.set("w2", w2);
  feedbackLoop.set("w3", w3);
  feedbackLoop.set("w4", w4);

  sharpen = loadShader("sharpen.glsl");
  sharpen.set("time", time);
  
  out2 = createGraphics(width, height, P2D);

  pp = new PingPong(out2, feedbackLoop, sharpen);
}

public void grayscottInit() {
  s11 = 0.16;
  s12 = -0.13;
  s21 = 0.02;
  s22 = 0.04;

  grayscott = loadShader("grayscott.glsl");
  render = loadShader("render.glsl");
  render.set("ca", new PVector(0, 0, 0));
  render.set("cb", new PVector(1, 1, 1));
  
  out1 = createGraphics(width, height, P2D);

  gs = new GrayScott(out1, grayscott, render);
}

public void camInit() {
  cam = new Capture(this);
  cam.start(); 
}

public void guiInit() {
  gui = new Gui(this);
  gui.setGUI();
}

public void grayscottDraw() {
  gs.set(f, k, dA,dB, dt);

  gs.set("s11", s11);
  gs.set("s12", s11);
  gs.set("s21", s11);
  gs.set("s22", s11);
  
  //if(cam.available()){
  //  cam.read();
  //  gs.setTexture(cam);
  //}
  
  gs.setTexture(tracker.getCanvas());

  gs.draw();
}

public void feedbackLoopDraw() {
  //if(cam.available()){
  //  cam.read();
  //  pp.setTexture(cam);
  //}
  
  pp.setTexture(out1);
  pp.set("zoom1", zoom1);
  pp.set("zoom2", zoom2);

  pp.set("angle1", angle1);
  pp.set("angle2", angle2);

  pp.set("x", x);
  pp.set("y", y);

  pp.set("time", time);
  
  pp.set("w0", w0);
  pp.set("w1", w1);
  pp.set("w2", w2);
  pp.set("w3", w3);
  pp.set("w4", w4);

  pp.draw();
}
