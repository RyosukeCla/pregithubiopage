Object[] obj = new Object[3];
void setup() {
  size(700, 150);
  textAlign(CENTER, CENTER);
  textSize(50);
  noStroke();
  frameRate(40);
  for (int i = 0; i < obj.length; i++) {
    obj[i] = new Object(i);
  }
}

void draw() {
  background(0, 0, 30);
  for (int i = 0; i < obj.length; i++) {
    obj[i].update();
    if (obj[i].x > width + 100) {
      obj[i] = new Object(0);
    }
    obj[i].display();
  }
  fill(240, 240, 255, 200);
  text("This is Processing!!", width/2, height/2);
}

class Object {
  float x, y;
  color co;
  int num;
  float theta;
  float size;
  Object(int n) {
    co = color(random(20, 150), random(50, 160), random(80, 230));
    num = (int)random(3, 14);
    theta = random(-360,360);
    x = -100.0 -n*900.0/3;
    y = height/2.0;
    size = random(40, 80);
  }

  void update() {
    x+=3;
    theta+=2;
    y += 1.9*sin(radians(theta));
  }

  void display() {
    fill(co);
    pushMatrix();
    translate(x, y);
    rotate(radians(theta));
    beginShape();
    for (int i = 0; i < num; i++) {
      vertex(size*cos(radians((float)360.0*i/num)), size*sin(radians((float)360.0*i/num)));
    }
    endShape();
    popMatrix();
  }
}

