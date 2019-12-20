import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import gab.opencv.*;

public class KinectTracker {

  //int threshold = Util.metersToRawDepth(g_meters);
  public int polygonApproximationFactor = 1;
  public int minContourArea = 10000;
  private int threshold = 965;
  private float angle = 0;
  
  // Raw location
  private PVector loc;

  // Interpolated location
  private PVector lerpedLoc;

  // Depth data
  private int[] depth;
  
  // What we'll show the user
  private PImage display;

  // External Objects
  private PApplet theParent;
  private Kinect kinect;

  OpenCV opencv;
  ArrayList<Contour> contours;

  PGraphics canvas;
   
  public KinectTracker(PApplet theParent) {
    this.theParent = theParent;
    this.kinect = new Kinect(theParent);
    this.opencv = new OpenCV(theParent, this.kinect.width, this.kinect.height); 
    this.opencv.startBackgroundSubtraction(5, 3, 0.5);
    
    contours = new ArrayList<Contour>();
    canvas = createGraphics(this.theParent.width, this.theParent.height, P2D);

    this.kinect.initDepth();
    this.kinect.enableMirror(true);
    this.kinect.setTilt(angle);

    display = createImage(this.kinect.width, this.kinect.height, RGB);

    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }
  
  
  public void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        
        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      loc = new PVector(sumX/count, sumY/count);
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.1f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.1f);
  }

  public PVector getLerpedPos() {
    return lerpedLoc;
  }

  public PVector getPos() {
    return loc;
  }

  public void findContours() {
    depth = kinect.getRawDepth();
    contours.clear();
    
    // Being overly cautious here
    if (depth == null) {print(depth.toString()); return; }

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect.width; x += 1) {
      for (int y = 0; y < kinect.height; y += 1) {

        int offset = x + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(150, 50, 50);
        } else {
          display.pixels[pix] = color(0,0,0,0);
        }
      }
    }
    display.updatePixels();
    
    opencv.loadImage(display);
    
    for (Contour contour : opencv.findContours()) {
      if(contour.area() > minContourArea){
        contour.setPolygonApproximationFactor(polygonApproximationFactor);
        contours.add(contour.getPolygonApproximation());
      }
    }
    
  }

  public void draw() {
    canvas.beginDraw();
    canvas.scale(theParent.width * 1.0 / kinect.width, theParent.height * 1.0 / kinect.height);

    canvas.background(0);
    canvas.fill(0,255,0);
    canvas.strokeWeight(1);

    for (Contour contour: contours) {
      canvas.beginShape();
      for (PVector point: contour.getPoints()) {
        canvas.vertex(point.x, point.y);
      }
      canvas.endShape(CLOSE);
    }
    canvas.endDraw();
  }

  public PGraphics getCanvas() {
    this.findContours();
    this.draw();

    return canvas;
  }

  public int getThreshold() {
    return threshold;
  }

  public void setThreshold(int dt) {
    threshold += dt;
    println("kinect threshold: %i", threshold); 
  }

  public void setTilt(float dA) {
    angle += dA;
    constrain(angle, 0, 30);
    kinect.setTilt(angle);
    println("kinect angle: %f", angle); 
  }
}
