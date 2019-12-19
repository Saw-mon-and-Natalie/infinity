import processing.video.*;
Capture cam;

Gui gui;

PShader feedbackLoop, sharpen, grayscott, render;

GrayScott gs;
PingPong pp;

// feedback loop variables
float zoom, rotationAngle;
float s11, s12, s21, s22;
float time;

// grayscott variables
float dA = 1.0;
float dB = 0.5;
float f  = 0.0545;
float k  = 0.062;
float dt = 1.0;

void setup() {
  size(640,360, P2D);

  guiInit();
  feedbackLoopInit();
  grayscottInit();
  camInit();
}
void draw() {
  time = millis() / 1000.0;
  grayscottDraw();
}

void keyPressed(){
  switch(key) {
    case('w'):
      zoom += 0.01;
      break;
    case('s'):
      zoom -= 0.01;
      break;
    case('a'):
      rotationAngle += 0.1;
      break;
    case('d'):
      rotationAngle -= 0.1;
      break;
    case('h'):
      gui.hideGUI();
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
  zoom = 1.0;
  rotationAngle = 90.0;
  time = 0.0;

  feedbackLoop = loadShader("feedbackloop.glsl"); 
  feedbackLoop.set("resolution", float(width), float(height));
  feedbackLoop.set("zoom", zoom);
  feedbackLoop.set("angle", rotationAngle);
  feedbackLoop.set("time", time);

  sharpen = loadShader("sharpen.glsl");
  sharpen.set("time", time);

  pp = new PingPong(this, feedbackLoop, sharpen);
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

  gs = new GrayScott(this, grayscott, render);
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
  
  if(cam.available()){
    cam.read();
    gs.setTexture(cam);
  }

  gs.draw();
}

public void feedbackLoopDraw() {
  if(cam.available()){
    cam.read();
    pp.setTexture(cam);
  }
  pp.set("zoom", zoom);
  pp.set("angle", rotationAngle);
  pp.set("time", time);

  pp.draw();
}
