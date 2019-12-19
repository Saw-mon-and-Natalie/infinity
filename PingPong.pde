public class PingPong {

    private PApplet papplet;
    private PGraphics pg, pgb;
    private PImage texture;
    private PShader shader, sharpen;
    private int w, h;

    public PingPong(final PApplet theParent, PShader shader, PShader sharpen) {
        papplet = theParent;
        this.shader = shader;
        this.sharpen = sharpen;

        init();
    }

    public void init() {
        w = papplet.g.width;
        h = papplet.g.height;

        pg = createGraphics(w, h, P2D);
        pgb = createGraphics(w, h, P2D);

        pg.beginDraw();
        pg.background(255);
        pg.noStroke();
        pg.fill(0);
        pg.endDraw();  

        pgb.beginDraw();
        pgb.background(255);
        pgb.endDraw();
    }

    public void set(String k, float value) {
        shader.set(k, value);
        if (k == "time") {
            sharpen.set("time", value);
        }
    }

    public void setTexture(PImage tex) {
        texture = tex;
        shader.set("imageTexture", texture);
    }

    public void draw() {
        pg.beginDraw();
        pg.image(pgb, 0, 0);
        pg.shader(shader);
        pg.endDraw();
        
        pgb.beginDraw();
        pgb.image(pg, 0, 0);
        pgb.shader(sharpen);
        pgb.endDraw();

        // or papplet.g.image ??
        papplet.image(pgb, 0, 0);
    }
}
