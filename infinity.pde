import processing.video.*;
Capture cam;

PShader pass1;

PGraphics canvas;
PGraphics ping, pong;

float zoom, rotationAngle;



void setup() {
  size(640,360, P2D);
  
  canvas = createGraphics(width, height, P2D);
  
  ping = createGraphics(width, height, P2D);
  pong = createGraphics(width, height, P2D);
  
  pass1 = loadShader("feedbackloop.glsl"); 
  pass1.set("resolution", float(width), float(height));
  
  zoom = 1.0;
  rotationAngle = 90.0;
  
  pass1.set("zoom", zoom);
  pass1.set("angle", rotationAngle);
  
  
  cam = new Capture(this);
  cam.start();
  
  
  ping.beginDraw();
  ping.background(255);
  ping.noStroke();
  ping.fill(0);
  ping.endDraw(); 
  
  canvas.beginDraw();
  canvas.background(255);
  canvas.noStroke();
  canvas.fill(0);
  canvas.circle(mouseX, mouseY, 100);
  canvas.endDraw(); 
  
}
void draw() { //<>//
  
  pass1.set("imageTexture", canvas);
  pass1.set("zoom", zoom);
  pass1.set("angle", rotationAngle);
  
  if(cam.available()){
    cam.read();
  }
  
  pass1.set("imageTexture", cam);
  
  pong.beginDraw();
  pong.image(ping, 0, 0);
  pong.shader(pass1);
  pong.endDraw();
  
  ping.beginDraw();
  ping.image(pong, 0, 0);
  ping.endDraw();
  
  canvas.beginDraw();
  canvas.background(255);
  canvas.noStroke();
  canvas.fill(0);
  canvas.circle(mouseX, mouseY, 100);
  canvas.endDraw(); 
  
  image(pong, 0, 0);
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
    default:
      break;
  }
  
}
