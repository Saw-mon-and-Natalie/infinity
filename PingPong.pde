java.lang.reflect.Field;

public class PingPong extends AbstractShader {

    protected PShader sharpen;
    private Field zoom1, zoom2, angle1, angle2;
    private Field w0, w1, w2, w3, w4;
    private Field x, y;
    private Field time;

    public PingPong(final PApplet parent, String shader, String sharpen) {
        this.sharpen = loadShader(sharpen);
        super(parent, shader);
    }

    protected void getFields() {
        zoom1 = getField("zoom1");
        zoom2 = getField("zoom2");

        angle1 = getField("angle1");
        angle2 = getField("angle2");

        x = getField("x");
        y = getField("y");

        time = getField("time");

        w0 = getField("w0");
        w1 = getField("w1");
        w2 = getField("w2");
        w3 = getField("w3");
        w4 = getField("w4");
    }

    protected void initializeFields() {
        zoom1.setFloat(papplet, 1.0);
        zoom2.setFloat(papplet, 1.0);

        angle1.setFloat(papplet, 90.0);
        angle2.setFloat(papplet, 45.0);

        x.setFloat(papplet, 100.0);
        y.setFloat(papplet, 100.0);

        time.setFloat(papplet, 0.0);

        w0.setFloat(papplet, 1.0);
        w1.setFloat(papplet, 1.0);
        w2.setFloat(papplet, 1.0);
        w3.setFloat(papplet, 1.0);
        w4.setFloat(papplet, 1.0);
    }

    protected void setUniforms() {
        shader.set("zoom1", zoom1.getFloat(papplet));
        shader.set("zoom2", zoom2.getFloat(papplet));

        shader.set("angle1", angle1.getFloat(papplet));
        shader.set("angle2", angle2.getFloat(papplet));

        shader.set("x", x.getFloat(papplet));
        shader.set("y", y.getFloat(papplet));

        shader.set("time", time.getFloat(papplet));
        
        shader.set("w0", w0.getFloat(papplet));
        shader.set("w1", w1.getFloat(papplet));
        shader.set("w2", w2.getFloat(papplet));
        shader.set("w3", w3.getFloat(papplet));
        shader.set("w4", w4.getFloat(papplet));

        sharpen.set("time", time.getFloat(papplet));
    }

    public void draw() {

        setUniforms();

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

    public void draw(PImage tex) {

        setUniforms();
        setTexture(tex);

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
