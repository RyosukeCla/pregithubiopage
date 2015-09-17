Bar[] bar = new Bar[7];
void setup() {
  size(600, 600, P2D);
  blendMode(ADD);
  frameRate(30);
  a = 2;
  for (int i = 0; i < bar.length; i++) {
    bar[i] = new Bar(20, 20 + 45 * i);
    bar[i].setTitle("status" + i);
  }
  bar[0].setRange(0,150);
  bar[1].setRange(0,150);
  bar[2].setRange(0,10);
  bar[3].setRange(0,10);
  bar[4].setRange(0,20);
  bar[5].setRange(0,20);
  bar[6].setRange(1,7200);
  bar[0].setInitialValue(40);
  bar[1].setInitialValue(40);
  bar[2].setInitialValue(6);
  bar[3].setInitialValue(6);
  bar[4].setInitialValue(15);
  bar[5].setInitialValue(15);
  bar[6].setInitialValue(30);
}
float a;

void draw() {
  background(0, 0, 30);
  noStroke();
  blendMode(ADD);
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < 7200; i+=1) {
    float xpos = (bar[0].getValue() + radians(i*bar[2].getValue()) * sin(radians(i*bar[4].getValue()))) * cos(radians(i));
    float ypos = (bar[1].getValue() + radians(i*bar[3].getValue()) * sin(radians(i*bar[5].getValue()))) * sin(radians(i));
    fill(70, 200, 140, 100);
    ellipse(xpos, ypos, 3, 3);
  }
  popMatrix();
  //a = 10.0 * mouseX/width;
  for (int i = 0; i < bar.length; i++) {
    bar[i].update();
  }
}

void mousePressed() {
  for (int i = 0; i < bar.length; i++) {
    bar[i].mouseListener();
  }
}

class Bar {
  float x, y;
  float ra, rb;
  boolean canChange;
  float mx;
  String name;
  Bar(float x, float y) {
    this.x = x;
    this.y = y;
    ra = 0;
    rb = 1;
    canChange = false;
    mx = 60;
    name = "none";
  }
  void setRange(float a, float b) {
    ra = a;
    rb = b;
  }
  void setTitle(String str) {
    name = str;
  }
  void setInitialValue(float v) {
    mx = v;
  }
  void update() {
    if (mouseX >= x - 5 && mouseX <= x + 65 && mouseY >= y && mouseY <= y + 16) {
      canChange = true;
    } else {
      canChange = false;
    }
    pushMatrix();
    stroke(255, 255, 255, 255);
    strokeWeight(1);
    fill(255, 255, 255, 100);
    translate(x, y);
    line(0, 0, 0, 16);
    line(0, 8, 60, 8);
    line(60, 0, 60, 16);
    text(name, 64, 8);
    text((int)ra, 0, -4);
    text((int)rb, 60, -4);
    text(getValue(), mx - 2.5, 26);
    rect(mx - 2.5, 0, 5, 16);
    popMatrix();
  }
  float getValue() {
    return ra + (rb - ra) * mx/60.0;
  }
  void mouseListener() {
    if (canChange == true) {
      mx = mouseX - x;
      if (mx > 60) {
        mx = 60;
      }
      if (mx < 0) {
        mx = 0;
      }
    }
  }
}