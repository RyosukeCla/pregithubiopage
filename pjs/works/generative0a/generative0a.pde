void setup() {
  size(600, 600, P2D);
  blendMode(ADD);
  frameRate(30);
  a = 2;
  b = 1;
  c = 1;
}
float a,b,c;

void draw() {
  background(0, 0, 30);
  noStroke();
  blendMode(ADD);
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < 3600; i+=1) {
    float xpos = (50 + radians(i * b) * sin(radians(i*a))) * cos(radians(i));
    float ypos = (50 + radians(i * c) * sin(radians(i*a))) * sin(radians(i));
    fill(70, 200, 140, 100);
    ellipse(xpos, ypos, 3, 3);
  }
  popMatrix();
  a+=0.01;
  b = 5.0 * mouseX/width;
  c = 5.0 * mouseY/height;

}

void mousePressed() {
  a = 2;
}