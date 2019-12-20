java.lang.reflect.Field;

public abstract class AbstractShader {

    protected PApplet papplet;
    protected PGraphics out;
    protected PGraphics pg, pgb;
    protected PImage texture;
    protected PShader shader, sharpen;
    protected int w, h;

    public AbstractShader(final PApplet parent, String shader) {
        papplet = parent;
        this.shader = loadShader(shader);

        init();
    }

    public void init() {
        w = papplet.g.width;
        h = papplet.g.height;

        pg = createGraphics(w, h, P2D);
        pgb = createGraphics(w, h, P2D);
        out = createGraphics(w, h, P2D);

        pg.beginDraw();
        pg.background(255,0,0);
        pg.stroke(200);
        pg.strokeWeight(15);
        pg.endDraw();

        pgb.beginDraw();
        pgb.background(255);
        pgb.endDraw();

        out.beginDraw();
        out.background(255);
        out.endDraw();

        getFields();
        initializeFields();
        shader.set("resolution", float(w), float(h));
        setUniforms();
    }

    protected void setTexture(PImage tex) {
        texture = tex;
        shader.set("imageTexture", texture);
    }

    protected Field getField(String name) {
        return papplet.getClass().getDeclaredField(name);
    }

    public PGraphics output() {
        return out;
    }

    protected abstract void initializeFields();
    protected abstract void getFields();
    protected abstract void setUniforms();
    public abstract void draw();
    public abstract void draw(PIamge tex);
}