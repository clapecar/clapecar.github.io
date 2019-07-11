/*Clara Peñalva
Tema 2 - Ejercicio 3 - Humo con textura y viento*/
 
ParticleSystem ps;
PImage humoImg;

//modulo de la intensidad del viento
float viento;
PVector ptoOrigV;
PVector vientoVect;
boolean vientoFlag;
String vientoText;
void setup() {
  size(750, 700);
  textSize(20);
  ini();
}
 
void draw() {
  background(214, 229, 251); 
  
  if(vientoFlag){
    //Velocidad del viento
    
    vientoVect.set(mouseX - ptoOrigV.x, mouseY - ptoOrigV.y);
    vientoVect.normalize();
    vientoVect.mult(0.001);
    viento = mouseX - ptoOrigV.x;  
    vientoText = "activado";
  }
  else{
    vientoText = "desactivado";
  }
  ps.addParticle();
  ps.run();
  fill(145, 86, 23);
  noStroke();
  rect(width/3, height/4*3+90, 130, 100); 
  fill(0);
  text("Para volver a empezar, pulse 'espacio'", 30, 30);
  text("Para cambiar el estado del viento, pulse 'v'", 30, 50);
  text("Estado de viento: " + vientoText, 30, 70);  
  stroke(0);
  strokeWeight(2);
  line(200, 90, 200+viento, 90);
  ellipse(200+viento, 90, 4, 4);
}

void keyPressed(){
  //cambio de estado de viento
  if(key == 'v' || key == 'V'){
    vientoFlag = !vientoFlag;
  }
  if(key == ' '){
    ini();
  }
}  

void ini(){
  viento = 0;
  vientoFlag = false;
  vientoText = "desactivado";
  ptoOrigV = new PVector(width/2, height/2);
  vientoVect = new PVector(0.0, 0.0);  
  humoImg = loadImage("simulacion/particle_smoke.png");
  ps = new ParticleSystem(new PVector(width/3, height/4*3));

}



 
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector F;
  float lifespan;
  float tamanyo;
  float masa;
  
  Particle(PVector location_) {
    F = new PVector(0,0);
    acceleration = new PVector(0, -0.0001);
    velocity = new PVector(random(-1, 1), random(-3, -0.5));
    location = location_.get();
    lifespan = 255.0;
    tamanyo = random(60, 125);
    masa = 1;
  }
 
  void run() {
    update();
    display();
  }
 
  // Method to update location
  void update() {
   
    actualizaFuerza();
    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration.x = F.x / masa;
     
    //--->utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.add(acceleration);     
    location.add(velocity);
    
    lifespan -= 1.5;
    tamanyo = tamanyo*0.995;
  }
  
  void actualizaFuerza(){
     
   //--->la fuerza tiene dos componentes. En uno, siempre  actua la gravedad
   if(vientoFlag)
     F.x = vientoVect.x;
  //la fuerza del viento se puede acoplara la otra componente de la fuerza de la particula (o incluso a las dos)

  }
  
  // Method to display
  void display() {
    tint(255, lifespan); //para que la imagen se vaya diluyendo    
    image(humoImg, location.x, location.y, tamanyo, tamanyo);
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