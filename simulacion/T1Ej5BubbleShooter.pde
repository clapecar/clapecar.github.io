/*Clara Peñalva
  Tema 1 - Ejercicio 5: Bubble Shooter*/

PVector bola = new PVector(0,0);
PVector mouse = new PVector(mouseX, mouseY);
PVector axis;
float v = 0.06;
float diam = 50;
boolean disparo = false;
PVector mouse_aux = new PVector(0,0);
BolaSystem bolas;
PVector locFin = new PVector();

void setup()
{
  size(600,750);
  smooth();
  axis = new PVector(width/2, height-100); //eje para el shooter
  bolas = new BolaSystem();

  textSize( 15);
}
 
void draw()
{
  background(#000000);
    
  //obtenemos las coordenadas del ratón
  mouse.x = mouseX;
  mouse.y = mouseY;
  
  mouse.sub(axis);
  mouse.normalize(); // de 0 a 1
  mouse.mult(70); //lo hacemos grande (también el shooter)
  
  locFin.x = mouse.x+axis.x;
  locFin.y = mouse.y+axis.y;
  
   //Dibujamos el "shooter"   
  stroke(1,169,219);
  fill(1,169,219);
  strokeWeight(3);
  arc(axis.x, axis.y, 80, 40, PI, TWO_PI);
  line(axis.x, axis.y, locFin.x, locFin.y);
  
  fill(#aaaaaa);
  stroke(#aaaaaa);
  rect(0, height-100, 600, 100);
  
  fill(#000000);
  text("Apunte con el ratón y dispare con 'ESPACIO'.", 150, height-50);
  
  bolas.run();  
}

void keyPressed()
{
  //Se lanza bola nueva
  if(key == ' '){
    if (locFin.y < height - 115) 
    {
      bolas.updateLoc(locFin); // Se actualiza la posición del final
      bolas.addBola(); //Se añade bola
    }
  }
}

// A simple Bola class

class Bola {
  PVector location;
  PVector velocity;
  PVector originP;

  Bola(PVector l) {
    originP = l.get();   
    PVector auxVel = new PVector(originP.x - axis.x,  originP.y - axis.y);
    auxVel.normalize();
    auxVel.mult(10);
    velocity = auxVel.get();
    location = l.get();
    
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {    
    location.add(velocity);
  }

  // Method to display
  void display() {
    stroke(255);
    fill(#ffffff);
    ellipse(location.x,location.y,8,8);
  }
  
  // Is the Bola still useful?
  boolean isDead() {
    if ( location.x > width || location.x < 0 || location.y < 0 || location.y > height -100) 
    {
      return true;
    } 
    else 
    {
      return false;
    }
  }
}

class BolaSystem {
  ArrayList<Bola> particles;
  PVector origin;

  BolaSystem() {
    origin = new PVector();
    particles = new ArrayList<Bola>();
  }

  void addBola() {
    particles.add(new Bola(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Bola p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  void updateLoc(PVector loc){
    origin = loc.get();
  }
}