public class PingPong {

    private PGraphics out;
    private PGraphics pg, pgb;
    private PImage texture;
    private PShader shader, sharpen;
    private int w, h;

    public PingPong(final PGraphics out, PShader shader, PShader sharpen) {
        this.out = out;
        this.shader = shader;
        this.sharpen = sharpen;

        init();
    }

    public void init() {
        w = out.width;
        h = out.height;

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

    public void set(String k, float[] value) {
        shader.set(k, value);
    }

    public void setTexture(PImage tex) {
        texture = tex;
        shader.set("imageTexture", texture);
    }

    public void draw() {
        pg.beginDraw();
        pg.shader(shader);
        pg.image(pgb, 0, 0);
        
        pg.endDraw();
        
        pgb.beginDraw();
        pgb.shader(sharpen);
        pgb.image(pg, 0, 0);
        
        pgb.endDraw();

        // or papplet.g.image ??
        out.beginDraw();
        out.image(pgb, 0, 0);
        out.endDraw();
    }
}
