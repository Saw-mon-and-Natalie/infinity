public class GrayScott {

    private PGraphics out;
    private PGraphics pg, pgb;
    private PImage texture;
    private PShader grayscott, fil;
    private int w, h;

    public GrayScott(final PGraphics out, PShader shader, PShader fil) {
        this.out = out;
        grayscott = shader;

        this.fil = fil;

        init();
    }

    public void init() {
        w = out.width;
        h = out.height;

        pg = createGraphics(w, h, P2D);
        pgb = createGraphics(w, h, P2D);

        pg.beginDraw();
        pg.background(255,0,0);
        pg.stroke(200);
        pg.strokeWeight(15);
        pg.endDraw();

        pgb.beginDraw();
        pgb.background(255);
        pgb.endDraw();
    }

    public void set(float f, float k, float dA, float dB, float dt) {
        grayscott.set("f",f);
        grayscott.set("k",k);
        grayscott.set("dA",dA);
        grayscott.set("dB",dB);
        grayscott.set("dt",dt);
    }

    public void set(String k, float value) {
        grayscott.set(k, value);
    }

    public void set(String k, float[] value) {
        grayscott.set(k, value);
    }

    public void setTexture(PImage tex) {
        texture = tex;
        grayscott.set("imageTexture", texture);
    }

    public void draw() {
        pg.beginDraw();
        pg.shader(grayscott);
        pg.image(pgb, 0, 0);
        pg.endDraw(); 

        pgb.beginDraw();
        pgb.image(pg, 0, 0);
        pgb.endDraw();

        // or papplet.g.image ??
        out.beginDraw();
        out.image(pgb, 0, 0);
        out.filter(fil);
        out.endDraw();
    }
}
