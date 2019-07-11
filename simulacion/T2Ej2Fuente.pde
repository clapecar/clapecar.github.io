/*Clara Peñalva
Tema 2 - Ejercicio 2 - Fuente*/

//variables
ParticleSystem particleS;
int i, n;
void setup() {
  size(700, 500);
  textSize(20);
  ini();
  textSize(25);
}
 
void draw() {
  frameRate(30);
  background(255);
  particleS.addParticle();  
  particleS.run();
  fill(0);
  text("Para volver a empezar, pulse 'espacio'", 40, 40);
}

void ini(){  
  i = 0;
  particleS = new ParticleSystem(new PVector(width/2.0, height-50));
}

//se resetea
void keyPressed() {
  if (key == ' ') {
     ini();
  }
}


// A simple Particle class
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float angle;
 
  Particle(PVector location_) {
    acceleration = new PVector(0, 0.05);     
    n = i%7;
    angle = -(60+10*n) * PI/180.0;
    velocity = new PVector(cos(angle)*5, sin(angle)*5);
    i++;
    location = location_.get();
    lifespan = 255.0;
  }
 
  void run() {
    update();
    display();
  }
 
  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }
 
  // Method to display
  void display() {
    noStroke();
    fill(100, 100, 255, lifespan);
    ellipse(location.x, location.y, 8, 8);
  }
   
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}



// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles
 
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
 
  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
 
  void addParticle() {
    particles.add(new Particle(origin));
  }
 
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}