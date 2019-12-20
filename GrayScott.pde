java.lang.reflect.Field;

public class GrayScott extends AbstractShader {

    protected PShader fil;
    private Field dA, dB, f, k, dt;
    private Field s11, s12, s21, s22;

    public GrayScott(final PApplet parent, String shader, String fil) {
        this.fil = loadShader(fil);

        this.fill.set("ca", new PVector(0, 0, 0));
        this.fill.set("cb", new PVector(1, 1, 1));

        super(parent, shader);
    }

    protected void getFields() {
        dA = getField("dA");
        dB = getField("dB");
        f = getField("f");
        k = getField("k");
        dt = getField("dt");

        s11 = getField("s11");
        s12 = getField("s12");
        s21 = getField("s21");
        s22 = getField("s22");
    }

    protected void initializeFields() {
        dA.setFloat(papplet, 1.0);
        dB.setFloat(papplet, 0.5);
        f.setFloat(papplet, 0.0545);
        k.setFloat(papplet, 0.062);
        dt.setFloat(papplet, 1.0);

        s11.setFloat(papplet, 0.16);
        s12.setFloat(papplet, -0.13);
        s21.setFloat(papplet, 0.02);
        s22.setFloat(papplet, 0.04);
    }

    protected void setUniforms() {
        shader.set("dA", dA.getFloat(papplet));
        shader.set("dB", dB.getFloat(papplet));
        shader.set("f", f.getFloat(papplet));
        shader.set("k", k.getFloat(papplet));
        shader.set("dt", dt.getFloat(papplet));

        shader.set("s11", s11.getFloat(papplet));
        shader.set("s12", s12.getFloat(papplet));
        shader.set("s22", s21.getFloat(papplet));
        shader.set("s22", s22.getFloat(papplet));
    }

    public void draw() {

        setUniforms();

        pg.beginDraw();
        pg.shader(shader);
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

    public void draw(PImage tex) {

        setUniforms();
        setTexture(tex);

        pg.beginDraw();
        pg.shader(shader);
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
