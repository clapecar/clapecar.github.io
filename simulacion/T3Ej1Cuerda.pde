/*Clara Peñalva
  Tema 3 - Ejercicio cuerda
*/
//import peasy.*;
 
final int STRUCTURED = 1;
final int SHEAR = 2;
final int BEND = 3;
final int TOT = 4;

//variables
Cuerda cuerda;
//PeasyCam camera;
int radio;
float dt;
float k;
int gridFilas, gridColum, distPart;
float tamBandera;
PVector gravity;
float damping;
PVector wind;
boolean viento, bolas;

void setup(){  
  size(750,480);
  smooth();
  //camera = new PeasyCam(this, width/2, height/2, 0, 450);

  textSize(20);
  ini();
}

void ini(){
  /*DATOS MODIFICABLES*/ 
  dt = 1/20.0; //diferencial de tiempo
  radio = 5; //radio de las bolas
  gridFilas = 20;
  distPart = 15;
  tamBandera = gridFilas * distPart;
  viento = true;
  bolas = true;
  
              //(distancia, loc, k, damping)
  cuerda = new Cuerda(distPart, width/2, 25, 0.2);  
  gravity = new PVector(0, 9.8, 0);
  wind = new PVector(0,0,0);
}
 
void draw(){
  background(#000000);
  
  
  //se modifica el viento aleatorio
  if(viento){
    wind.x = 12.5+random(0,10);
    wind.y = 0.012+random(-1,1);
    wind.z = 5+random(0,10);
  }
  
  for (int i = 0; i < 25; i++)
    cuerda.update();
  
  cuerda.display();
  
  fill(255);  
   text("FrameRate: " + frameRate , 20, height-130);
  text("dt: " + dt, 20, height-70);
  if(viento){
    text("viento: " + wind, 20, height-100);
    text("Estado del viento: activado", 300, height-70);
  }
  else
    text("Estado del viento: desactivado ", 300, height-70);
  text("Para reiniciar, pulse espacio ", 20, height-50);
  text("Para modificar el estado del viento, pulse 'v' ", 300, height-50);
  text("Para ver/ocultar las partículas, pulse 'p' ", 300, height-30);
}

//interacción
void keyPressed(){
  if(key == ' ')
    ini();
  if(key == 'v' || key == 'V')
    viento = !viento;
  if(key == 'p' || key == 'p')
    bolas = !bolas;
} 


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class Cuerda {
  Particle[] particles;
  float k, damping;
  Cuerda(int distPart, float loc, float k_, float damping_) {
    boolean fix;
    k = k_;
    damping = damping_;
    particles  = new Particle[gridFilas];
    for(int i = 0; i < gridFilas; i++)
    {
      if(i==0)
        fix = true;
      else
        fix = false;
      particles[i] = new Particle(new PVector(i*distPart + loc, 0, 0), radio, fix, i); 
    }
  }

 

  void update() {
   for(int i = 0; i < gridFilas; i++)
    {
        //se resetean
        particles[i].acceleration.set(0, 0, 0);
        particles[i].force.set(0, 0, 0);
        
        particles[i].force.add(PVector.mult(gravity,particles[i].massa));  //gravedad
      
        particles[i].vDamp.set(particles[i].velocity.x, particles[i].velocity.y);
        particles[i].vDamp.mult(-damping);
        particles[i].force.add(particles[i].vDamp);
        
        //viento
        if(viento){
         // PVector windProp = updateWind(i, j, particles[i]);
          particles[i].force.add(wind);
        }
        
        //structured
          particles[i].force.add(getForce(i+1, distPart, k, particles[i]));
          particles[i].force.add(getForce(i-1, distPart, k, particles[i]));
        
        
        //bend
          particles[i].force.add(getForce(i-2, distPart*2, k, particles[i]));
          particles[i].force.add(getForce(i+2, distPart*2, k, particles[i]));    
   }
      
   for(int i = 0; i < gridFilas; i++)
      particles[i].update();

      
  }
    
  void display(){
    pushMatrix();
    fill(240, 70, 70);
    stroke(255);   

    for(int x = 0; x < gridFilas-1; x++){
      PVector p1 = particles[x].location;
      PVector p2 = particles[x+1].location;
      line(p1.x, p1.y, p2.x, p2.y);
     }    
     popMatrix();
    
    if(bolas){
       for(int i = 0; i < gridFilas; i++)
       {
          particles[i].display();
       }
    
    }
  }
  
  //obtiene la fuerza de la partícula que se quiera (particles[x])
  PVector getForce(int x, float d, float k, Particle p1){
    //x e y son los índices de la particula en la tela
    PVector force = new PVector(0, 0);
    PVector dist = new PVector(0, 0);
    float L = 0.0;
     
    //si no se sale de rango (es un vecino que existe)
    if (x >= 0 && x < gridFilas) 
    { 
      Particle p2 = particles[x];
       
      dist = PVector.sub(p1.location, p2.location);
      L = dist.mag() - d; 
      dist.normalize();       
      force = PVector.mult(dist, -k*L);
    }    
    return force;
  }
}


class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force;
  float radio;
  boolean fixed;
  float massa;
  int x, y;
  PVector vDamp;
  Particle(PVector l, float radio_, boolean fixed_, int x_) {
    radio = radio_;
    fixed = fixed_;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0); //marca la forma del emisor
    location = l.get();
    vDamp = new PVector(0, 0);
    force = new PVector(0, 0);
    massa = 1;
    x = x_; //índices de la tela
  }

 
  // Method to update location
  void update() { //integrador 
    if(!fixed){ //si no es una fija       
    force.div(massa);    
      acceleration.set(force);  
    acceleration.mult(dt);    
      velocity.add(acceleration);
    velocity.mult(dt);
      location.add(velocity);  
    }
  }
  
  
  // Method to display
  void display() {
    fill(100);
    stroke(100);
    ellipse(location.x,location.y,radio*2,radio*2);
  }
    
}