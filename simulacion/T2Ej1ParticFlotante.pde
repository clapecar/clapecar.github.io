/*Clara Peñalva
Tema 2 - Ejercicio 1 - Partícula flotante con splash*/
 
//variables
float dt = 0.1; //diferencial de tiempo
Ball ball; //pelota
ParticleSystem particleS; //splash
float kr_aire = 0.1; // Constante de rozamiento aire
float kr_agua = 0.3; // Constante de rozamiento agua

void setup() {
  size(500, 500);
  background(200);
  ini();
  textSize(20);
}
 
void draw() {
  background(255);   
  ball.run();
  particleS.run();
   
  //se dibuja el mar
  noStroke();
  fill(50, 100, 255, 150);
  rect(0, height/2, width, height);
  
  fill(0);
  text("Para volver a empezar, pulse 'espacio'", 40, 40);
}
 
//se resetea
void keyPressed() {
  if (key == ' ') {
     ini();
  }
}
void ini(){
   ball = new Ball(new PVector(width/2.0, width/4.0));
   particleS = new ParticleSystem(new PVector(width/2.0, width/2.0));
}


class Ball { 
//variables
  PVector location;
  PVector velocity;
  PVector acceleration;
  float massa, rad;
  float vs, h, a, p;
  PVector gravity;
  PVector Fr;
 
  Ball(PVector location_) {
    location = location_.get();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0.0, 0.0);
    
    gravity = new PVector(0.0, 9.8);
    Fr = new PVector(0.0, 0.0);
    massa = 2;
    rad = 35;
    p = 0.00003;
  }
 
  void run() {
    update();
    display();
  }
   
  /*
    flotabilidad --> densidad *g*volumen sumergido
    volumen totalmente sumergido --> 4*pi*radio*radio*radio/3
    parcialmente --> h = y + radio - altura/2
                     a = raiz(2*h*radio - h*h)
                     vs = (3 *a*a + h*h)*pi*h/6
  */
  // Method to update location
  void update() {
    
    if (location.y+rad <= height/2) {
      // En el aire
      vs = 0;
      Fr.y = -kr_aire * velocity.y;      
    } else if (location.y+rad > height/2 && location.y-rad < height/2) {
      // Parcialmente sumergido
      float h = location.y + rad - height/2;
      float a = sqrt(2 * h * rad - h * h);
      vs = (3 * a * a + h * h) * PI * h/6.0;
      Fr.y = -kr_agua * velocity.y;
    } else {      
      // En el agua completamente
      vs = 4.0 * PI * rad * rad * rad / 3.0;
      Fr.y = -kr_agua * velocity.y;
    }
     
    //se aplican las fuerzas y actualizan (euler)
    applyForce(PVector.mult(gravity, massa)); //gravedad
    applyForce(new PVector(0.0, -p * gravity.y * vs));   //fuerza de flotación  
    applyForce(Fr); //fuerza de rozamiento
    velocity = PVector.add(PVector.mult(acceleration, dt), velocity);
    location = PVector.add(PVector.mult(velocity, dt), location);
     
    acceleration.set(0.0, 0.0); //se resetea para no acumular
  }
   
  void applyForce(PVector force) {
	PVector f = new PVector();
	f = force.get();
	f.div(massa);
    acceleration.add(f);
  }
 
  // Method to display
  void display() {
    fill(180, 0, 20);
    ellipse(location.x, location.y, rad*2, rad*2);
  }
}


class Particle {
  PVector loc;
  PVector vel;
  PVector acceleration;
  float lifespan;
  
  Particle(PVector l, boolean type) {
    acceleration = new PVector(0.0, 0.05);
	loc = new PVector(0.0, 0.0);
    if(type){ //left
      vel = new PVector(random(0, 3), random(-3, 0));
      loc = l.get()
	  loc.add(ball.rad-2, 0);
    }
    else{ //right
      vel = new PVector(random(-3, 0), random(-3, 0));
      loc = l.get()
	  loc.add(-ball.rad+2, 0);
    }
    lifespan = 200.0;     
    vel.mult(ball.velocity.y/30); //su velocidad depende de la bola
  }
 
  void run() {
    update();
    display();
  }
 
  // Method to update loc
  void update() {
    vel.add(acceleration);
	//vel = PVector.add(acceleration, vel);
	
    //loc = PVector.add(vel, loc);
	
	loc.add(vel);

    
    lifespan -= 1.0;
  }
 
  // Method to display
  void display() {
    noStroke();
    fill(50, 100, 255, lifespan);
    ellipse(loc.x, loc.y, 8, 8);
  }
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0 || loc.y > width/2.0) {
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
  boolean pos; //true -> left | false -> right
  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
    pos = true;
  }
 
  void addParticle() {
    particles.add(new Particle(origin, pos));
    pos = !pos;
  }
 
  void run() {
    if (ball.velocity.y > 5 && ball.location.y+ball.rad > height/2.0) //si acaba de entrar en el agua
      addParticle(); //salpicaduras
      
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}