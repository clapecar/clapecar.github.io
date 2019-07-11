/*Clara Peñalva
 Tema 4 - Ejercicio 1: Simular el movimiento de una
 pelota que se mueve sobre un plano sin deslizarse*/

//import peasy.*;

//variables globales
float dt;
Bola ball;
float radio;
//PeasyCam camera;

void setup() {
  size(640, 300, P3D);
 // camera = new PeasyCam(this, width/2, height/2, 390, 0);
  //Datos modificables
  radio = 100;
  textSize(20);
  
  ball = new Bola(new PVector(width/2, height-50-radio, 0), radio);
   
}
 
void draw() {
  background(255);
  dt = 0.1; //diferencial de tiempo
  
  stroke(100);
  line(0, height-50, width, height-50);
  
  ball.run();
  
  fill(#000000); 
  /*text("Leyenda botones:", 50, 250);
  text("Flecha derecha: +1 velocidad derecha", 100, 270);
  text("Flecha izquierda: +1 velocidad izquierda", 100, 290);
  text("Velocidad centro de masas: " + ball.velocity.x, 50, 320);
  text("Velocidad angular: " + ball.velocityAng.z, 50, 340);
  text("Velocidad punto de contacto con suelo: " + ball.velocityPtoContact, 50, 360);
*/
}

//cambio de velocidades
void keyPressed() {
  if (keyCode == LEFT) {
    ball.velocity.x -= 1.0;
  } else if (keyCode == RIGHT) {
    ball.velocity.x += 1.0;
  } 
}


class Bola {
  PVector location;
  PVector velocity;
  PVector velocityAng;
  float rad, angleZ;
  PVector r;
  PVector velocityPtoContact;
   
  Bola(PVector location_, float rad_) {
    location = location_.get();
    rad = rad_;
    angleZ = 0;
    velocity = new PVector(0.0, 0.0, 0.0);
    velocityAng = new PVector(0.0, 0.0, 0.0);
    r = new PVector(0.0, rad, 0.0); //del centro de masas al pto de contacto
    velocityPtoContact = new PVector(0.0, 0.0, 0.0);
  }
   
  void run() {
    update();
    display();
  }
   
  void update() {
    //si se sale de pantalla
    if (location.x-rad >= width) 
      location.x = 0-rad;
    else if (location.x+rad <= 0) 
      location.x = width+rad;
      
    velocityAng.z = velocity.x / rad;
    angleZ += velocityAng.z * dt;
    velocityPtoContact = PVector.add(velocityAng.cross(r), velocity); //debe dar 0
    location.add(PVector.mult(velocity, dt));
    
  }
   
  void display() {
    stroke(1, 169, 219);
    noFill();
    pushMatrix();
    translate(location.x, location.y, location.z);
    rotateZ(angleZ);
    sphere(rad);
    popMatrix();
  }
}