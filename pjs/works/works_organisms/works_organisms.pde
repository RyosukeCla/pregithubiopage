World world;
void setup() {
  size(580, 500);
  //frame.setResizable(true);
  frameRate(60);
  world = new World(5);
}

void draw() { 
  background(255);
  world.update();
}

void mouseReleased() {
  world.mouseListner();
}

void keyReleased() {
  if (keyCode == ENTER) {
    world = new World(5);
  }
}

class Food {
  PVector location;
  float size;
  color foodColor;
  boolean isTouched;
  boolean disp;
  Food(float x, float y, float s) {
    location = new PVector(x,y);
    size = s;
    isTouched = false;
    disp = false;
  }
  
  color setColor(int R, int G, int B, int alpha) {
    foodColor = color(R,G,B,alpha);
    return foodColor;
  }
  
  void system() {
    if (isTouched == true) {
      size -= 0.5;
      isTouched = false;
    }
    if (size < 4) {
      disp = true;
    }
  }
  
  void display() {
    noStroke();
    fill(foodColor);
    ellipse(location.x, location.y, size, size);
  }
}

class Organism {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float x, y;
  float r;
  float s;
  color organismColor;

  float rad;

  float maxspeed;
  float maxforce;

  float lifetime;
  float needFood;
  int time;
  boolean die;
  boolean growth;
  boolean newOrganism;
  boolean onceBring;

  int Rc, Gc, Bc, alc;

  Organism(float size, float xpos, float ypos) {
    r = size;
    location = new PVector(xpos, ypos);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0.0, 0.0);
    s = 0;
    organismColor = color(0, 0, 0);
    x = random(0, 10000);
    y = random(10000, 20000);
    rad = 0;
    maxspeed = 5;
    maxforce = 0.5;
    lifetime = int(random(80, 120));
    time = 0;
    die = false;
    growth = false;
    onceBring = false;
    needFood = 100;
  }

  color setColor (int R, int G, int B, int alpha) {
    color organismCol = color(R, G, B, alpha);
    organismColor = organismCol;
    Rc = R;
    Gc = G;
    Bc = B;
    alc = alpha;
    return organismCol;
  }

  void update() {
    velocity.add(acceleration);
    acceleration.mult(pow(r/15.0, 2));
    location.add(velocity);
    acceleration.mult(0);
    velocity.mult(0.98);
    tail(velocity);

    PVector desired = null;

    if (location.x > width - r*2.5) {
      desired = new PVector(-maxspeed, velocity.y);
    }
    if (location.x < 0 + r*2.5) {
      desired = new PVector(maxspeed, velocity.y);
    }
    if (location.y > height - r*2.5) {
      desired = new PVector(velocity.x, -maxspeed);
    }
    if (location.y < 0 + r*2.5) {
      desired = new PVector(velocity.x, maxspeed);
    }

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }

  void applyForce(PVector f) {
    acceleration.add(f);
  }

  void movement(Food food) {

    // temptated movement
    float dis = dist(food.location.x, food.location.y, this.location.x, this.location.y);
    if (dis < 2200.0 / r  && dis > food.size && needFood <= 95) {
      PVector temptatedVector = new PVector(food.location.x - this.location.x, food.location.y - this.location.y);
      temptatedVector.normalize();
      if (dis > food.size * 5) {
        temptatedVector.mult(0.13);
        applyForce(temptatedVector);
      } else {
        temptatedVector.mult(0.1);
        applyForce(temptatedVector);   
        velocity.mult(0.95);
      }
    }

    // normal movement
    else {
      x += 0.05;
      y += 0.05;

      float xa, ya;
      noiseDetail(12, 0.5);
      xa = map(noise(x), 0, 1, -0.5, 0.50);
      ya = map(noise(y), 0, 1, -0.5, 0.50);
      PVector motion = new PVector(xa, ya);
      applyForce(motion);
    }

    // action when organism touchs food
    if (growth == false && food.isTouched == false && needFood <= 98) {
      if (dis < this.r + food.size/2) {
        food.isTouched = true;
        growth = true;
      }
    }
  }

  void lifeSystem() {
    if (growth == true) {
      //println("hit");
      needFood += 2;
      growth = false;
    }
    time++;
    if (time == 11) {
      float needFoodSp = map(r,3,30,1.2,0.1);
      lifetime -= 0.18;
      r += 0.05;
      needFood -= 0.01 + needFoodSp;
      //println(lifetime);
      time = 0;
      if (lifetime <= 30 || needFood <= 30) {
        velocity.mult(0.97);
      }
    }
    if (lifetime <= 0 || needFood <= 0) {
      die = true;
    }
    if (needFood > 100) {
      needFood = 100;
    }
    if (r >= 30) {
      r = 30;
    }
    if (r > 20) {
      if (onceBring == false) {
        newOrganism = true;
      }
    }
  }

  void tail(PVector f) {
    s = f.mag()*5;
    rad += s;
    if (rad > 35 || rad < -35) {
      s *= -1;
    }
  }

  void dieAction() {
    organismColor = color(Rc, Gc, Bc, alc);
    velocity.mult(0.9);
    Rc -= 1;
    Gc -= 1;
    Bc -= 1;
    alc -= 1;
  }

  void display() {
    float theta = velocity.heading() + PI/2;
    noStroke();
    fill(organismColor);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*1);
    bezierVertex(r*1.1, r*(-0.9), r*1.1, r*0.1, r*1, r*0.5);
    bezierVertex(r*0.8, r*1.3, 0, r*1.4, 0 + r*sin(radians(rad)), r*2.0 + r*abs(cos(radians(rad))));
    bezierVertex(0, r*1.4, r*(-0.8), r*1.3, r*(-1), r*0.5);
    bezierVertex(r*(-1.1), r*0.1, r*(-1.1), r*(-0.9), 0, -r*1);
    endShape();
    popMatrix();
    
  }
  
  void parameter(int i) {
    fill(organismColor);
    text("life :" + lifetime, 10,i*12 + 12);
    text("food :" + needFood, 120 ,i*12 + 12);
    text("size :" + r, 230, i*12 + 12);
  }
}

class World {
  int numberOfOrganisms;
  int numberOfFoods;
  ArrayList<Organism> organisms;
  Food food;
  
  World(int numberOfOrganisms) {
    organisms = new ArrayList<Organism>();
    for (int i = 0; i < numberOfOrganisms; i++) {
      organisms.add(new Organism(random(2,6),random(width),random(height)));
      Organism organism = organisms.get(i);
      organism.setColor((int)random(150,255), (int)random(40,80), (int)random(150,255), 210);
    }
    
    food = new Food(random(width/4, width*3/4), random(height/4, height*3/4), random(10, 30));
    food.setColor(int(random(40, 120)), int(random(40, 120)), int(random(40, 120)), 255);
    
  }

  void update() {
    food.system();
    food.display();
    for (int i = 0; i < organisms.size(); i++) {
      Organism organism = organisms.get(i);
      organism.update();
      organism.lifeSystem();
      organism.movement(food);
      organism.display();
      //organism.parameter(i);
      
      if (organism.newOrganism == true) {
        int k = (int)random(1,7);
        for (int j = 0; j < k; j++) {
          organisms.add(new Organism(random(2,6),organism.location.x, organism.location.y));
        }
        for (int l = organisms.size() - 1; l > organisms.size() - 1 - k; l--) {
          Organism newOrganisms = organisms.get(l);
          newOrganisms.setColor((int)random(150,255), (int)random(40,80), (int)random(150,255), 210);
        }
        organism.newOrganism = false;
        organism.onceBring = true;
      }
      if (organism.die == true) {
        organism.dieAction();
        if (organism.alc <= 0) {
          organisms.remove(i);
        }
      }
    }
    
    if (food.disp == true) {
      food = new Food(random(width/4, width*3/4), random(height/4, height*3/4), random(10, 30));
      food.setColor(int(random(40, 120)), int(random(40, 120)), int(random(40, 120)), 200);
    }
  }
  
  void mouseListner() {
    food = new Food(mouseX, mouseY, random(10,30));
    food.setColor(int(random(40, 120)), int(random(40, 120)), int(random(40, 120)), 200);
  }
  
  void keyListner() {
    organisms.add(new Organism((int)random(2,6),random(width),random(height)));
    Organism organism = organisms.get(organisms.size() - 1);
    organism.setColor((int)random(150,255), (int)random(40,80), (int)random(150,255), 210);
  }
}