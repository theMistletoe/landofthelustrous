
SpitzStone testObj;
SpitzStone testObj2;
SpitzStone testObj3;
SpitzStone testObj4;
SpitzStone testObj5;
SpitzStone testObj6;
SpitzStone testObj7;
SpitzStone testObj8;
SpitzStone testObj9;
SpitzStone testObj10;

float partHeight = 0;

void setup() {
    size(800, 800, P3D);
    strokeWeight(1);
    testObj = new SpitzStone(-200, 300, -1000);
    testObj2 = new SpitzStone(300, 400, -300);
    testObj3 = new SpitzStone(200, 400, -150);
    testObj4 = new SpitzStone(100, 500, -100);
    testObj5 = new SpitzStone(-300, 400, -600);
    testObj6 = new SpitzStone(-100, 200, 200);
    testObj7 = new SpitzStone(-400, 400, -300);
    testObj8 = new SpitzStone(350, 200, -400);
    testObj9 = new SpitzStone(-650, 400, -30);
    testObj10 = new SpitzStone(420, 300, -300);

}

void draw() {
    background(10, 10, 30);

    for(int i = 0; i < width + 1000; i++) {
        int c = 255 * i / width + 1000;
        stroke(c);
        line(0, i,-1000, width+1000, i,-1000);
    }

    translate(width / 2, height / 2);


    testObj.drawMe();
    testObj2.drawMe();
    testObj3.drawMe();
    testObj4.drawMe();
    testObj5.drawMe();
    testObj6.drawMe();
    testObj7.drawMe();
    testObj8.drawMe();
    testObj9.drawMe();
    testObj10.drawMe();

    PImage img=createLight(noise(10),noise(20),0.6);
    image(img,0,partHeight);
    partHeight = partHeight - 0.1;

}


//発光表現の元となるクラス
PImage createLight(float rPower,float gPower,float bPower){
    int side=6;
    float center=side/2.0;

    PImage img=createImage(side,side,RGB);

    for(int y=0; y<side; y++) {
        for(int x=0; x<side; x++) {
            float distance=(sq(center-x)+sq(center-y))/10.0;
            int r=int((255*rPower)/distance);
            int g=int((255*gPower)/distance);
            int b=int((255*bPower)/distance);
            img.pixels[x+y*side]=color(r,g,b);
        }
    }
    return img;
}

/*
* Spitz Class.
*/
class SpitzStone {

    private float pointCenterX, pointCenterY, pointCenterZ;

    private float lengthX, lengthY, lengthZ;

    private PVector plot1, plot2, plot3, plot4, plot5, plot6;

    private float rotateRateX, rotateRateY, rotateRateZ;

    private float posDiffX, posDiffY, posDiffZ;

    private float r_color_val, g_color_val, b_color_val;
    private int color_grad_count;
    private boolean isIncrease = true;

    SpitzStone (float pPosDiffX, float pPosDiffY, float pPosDiffZ) {
        pointCenterX = 0; pointCenterY = 0; pointCenterZ = 0;

        lengthX = 40; lengthY = 80; lengthZ = 40;

        rotateRateX = 0; rotateRateY = 0; rotateRateZ = 0;

        posDiffX = pPosDiffX; posDiffY = pPosDiffY; posDiffZ = pPosDiffZ;

        calcPosVector();

        r_color_val = 0;
        g_color_val = 0;
        b_color_val = 0;

        color_grad_count = 0;

    }

    // calculate vertex from center and length
    void calcPosVector() {
        plot1 = new PVector(pointCenterX, pointCenterY + lengthY, pointCenterZ);
        plot2 = new PVector(pointCenterX - lengthX, pointCenterY, pointCenterZ);
        plot3 = new PVector(pointCenterX, pointCenterY, pointCenterZ - lengthZ);
        plot4 = new PVector(pointCenterX + lengthX, pointCenterY, pointCenterZ);
        plot5 = new PVector(pointCenterX, pointCenterY, pointCenterZ + lengthZ);
        plot6 = new PVector(pointCenterX, pointCenterY - lengthY, pointCenterZ);
    }

    // called for each frame
    void drawMe() {

        pushMatrix();

        translate(pointCenterX + posDiffX, pointCenterY + posDiffY, pointCenterZ + posDiffZ);
        pointCenterY--;


        floatMe();
        drawOutline();
        drawSurface(plot2,plot1,plot3);
        drawSurface(plot3,plot1,plot4);
        drawSurface(plot4,plot1,plot5);
        drawSurface(plot5,plot1,plot2);

        drawSurface(plot2,plot6,plot3);
        drawSurface(plot3,plot6,plot4);
        drawSurface(plot4,plot6,plot5);
        drawSurface(plot5,plot6,plot2);

        popMatrix();

    }

    // fucking fat!!!
    // color the surface of the Spitz
    void drawSurface(PVector tempPlot1,PVector tempPlot2, PVector tempPlot3) {
        color c1, c2;

        // increase and decrease rgb value
        // Back and forth between black and white
        if (isIncrease) {
            r_color_val = (r_color_val + 0.4);
            g_color_val = (g_color_val + 0.4);
            b_color_val = (b_color_val + 0.4);
            } else {
                r_color_val = (r_color_val - 0.4);
                g_color_val = (g_color_val - 0.4);
                b_color_val = (b_color_val - 0.4);
            }

            // println(r_color_val);
            // println(isIncrease);
            // switch vector change color
            if (isIncrease & 150 < r_color_val) {
                isIncrease = false;
                } else if(!isIncrease & 30 > r_color_val) {
                    isIncrease = true;
                }

                // fluid color
                c1 = color(r_color_val, g_color_val, b_color_val);
                // black blue
                c2 = color(0, 0, 100);

                // 多分頂点座標からベクトルの内積使って切片上の2点を特定してlineメソッドで線引いてるっぽい
                for (float i = 1; i<=1000; ++i) {

                    // float tempNum1 = random(100);
                    // float tempNum2 = random(100);
                    // float tempNum3 = random(100);

                    PVector tempVec1 = PVector.add(tempPlot1, PVector.mult(PVector.sub(tempPlot2, tempPlot1), i / 1000));
                    PVector tempVec2 = PVector.add(tempPlot2, PVector.mult(PVector.sub(tempPlot3, tempPlot2), (1 - i /1000)));
                    // PVector tempVec3 = PVector.add(tempPlot3, PVector.mult(PVector.sub(tempPlot1, tempPlot3), tempNum3/100));

                    strokeWeight(2);
                    // stroke(0,0,200, 60);
                    // gradate between c1 and c2
                    color c = lerpColor(c1, c2, i / 1000 + 0.1);
                    stroke(c);
                    line(tempVec1.x, tempVec1.y, tempVec1.z, tempVec2.x, tempVec2.y, tempVec2.z);
                    // stroke(0,0,200, 60);
                    // line(tempVec2.x, tempVec2.y, tempVec2.z, tempVec3.x, tempVec3.y, tempVec3.z);
                    // stroke(0,0,200, 60);
                    // line(tempVec3.x, tempVec3.y, tempVec3.z, tempVec1.x, tempVec1.y, tempVec1.z);
                    // stroke(0,0,0,0);
                    // strokeWeight(1);
                }
            }

            // draw line which compose Spits
            void drawOutline() {
                strokeWeight(0.02);
                stroke(150, 150, 150);
                line(plot1.x, plot1.y, plot1.z, plot2.x, plot2.y, plot2.z);
                line(plot1.x, plot1.y, plot1.z, plot3.x, plot3.y, plot3.z);
                line(plot1.x, plot1.y, plot1.z, plot4.x, plot4.y, plot4.z);
                line(plot1.x, plot1.y, plot1.z, plot5.x, plot5.y, plot5.z);

                line(plot2.x, plot2.y, plot2.z, plot3.x, plot3.y, plot3.z);
                line(plot3.x, plot3.y, plot3.z, plot4.x, plot4.y, plot4.z);
                line(plot4.x, plot4.y, plot4.z, plot5.x, plot5.y, plot5.z);
                line(plot5.x, plot5.y, plot5.z, plot2.x, plot2.y, plot2.z);

                line(plot6.x, plot6.y, plot6.z, plot2.x, plot2.y, plot2.z);
                line(plot6.x, plot6.y, plot6.z, plot3.x, plot3.y, plot3.z);
                line(plot6.x, plot6.y, plot6.z, plot4.x, plot4.y, plot4.z);
                line(plot6.x, plot6.y, plot6.z, plot5.x, plot5.y, plot5.z);
            }

            // rotate myself
            void floatMe() {

                rotateX(rotateRateX);
                rotateY(rotateRateY);
                rotateZ(rotateRateZ);

                // rotateRateX = rotateRateX + random(100) / 1000;
                // rotateRateY = rotateRateY + random(200) / 800;
                // rotateRateZ = rotateRateZ + random(10) / 700;

                rotateRateX = rotateRateX + noise(random(100)) / 20;
                rotateRateY = rotateRateY + noise(random(100)) / 10;
                rotateRateZ = rotateRateZ + noise(random(100)) / 6;

            }

        }
