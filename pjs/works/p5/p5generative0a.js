var a, b, c;
function setup() {
	if (displayWidth < 900) {
		createCanvas(900,900);

	} else {
		createCanvas(displayWidth,displayHeight);

	}

frameRate(60);
a = 2;
b = 1;
c = 1;

}

function draw() {
background(0, 0, 30);
blendMode(ADD);
noStroke();
translate(width/2, height/2);
for (var i = 0; i < 3600; i+=1) {
    var xpos = (50 + radians(i * b) * sin(radians(i*a))) * cos(radians(i));
    var ypos = (50 + radians(i * c) * sin(radians(i*a))) * sin(radians(i));
    fill(70, 200, 140, 100);
    ellipse(xpos, ypos, 3, 3);
}
a+=0.01;
b = 5.0 * mouseX/width;
c = 5.0 * mouseY/height;
if (mouseIsPressed) 
	a = 2;
}