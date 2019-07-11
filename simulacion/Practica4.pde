/*Clara Peñalva
  Práctica 4
*/
//import peasy.*;
 
final float RANDMAX = 10;
final int STRUCTURED = 1;
final int SHEAR = 2;
final int BEND = 3;
final int TOT = 4;

//variables
Tela tela1, tela2, tela3, tela4;
//PeasyCam camera;
int radio;
float dt;
float k;
int gridFilas, gridColum, distPart;
float distPartDiag, tamBandera;
PVector gravity;
float damping;
PVector wind;
boolean viento, textura, grid;
PImage texturaBandera;


void setup(){  
  frameRate(1000);
  size(1000,480, P3D);
  smooth();
//textMode(SCREEN);
  // camera = new PeasyCam(this, width/2, height/2, 0, 450);
  texturaBandera = loadImage("simulacion/bandera.jpg");
  textSize(16);
  ini();
}

void ini(){
  /*DATOS MODIFICABLES*/ 
  dt = 1/20.0; //diferencial de tiempo
  radio = 5; //radio de las bolas
  gridFilas = 20;
  gridColum = 20;
  distPart = 10;
  tamBandera = gridFilas * distPart;
  distPartDiag = sqrt(distPart*distPart+distPart*distPart);
  viento = true;
  textura = true;
  grid = false;
              //(distancia, tipo, loc, k, damping)
  tela1 = new Tela(distPart, STRUCTURED, 0, 100, 0.2);  
  tela2 = new Tela(distPart, SHEAR, 250, 25, 0.2);  
  tela3 = new Tela(distPart, BEND, 500, 25, 0.2);
  tela4 = new Tela(distPart, TOT, 750, 25, 0.2);
  gravity = new PVector(0, 9.8, 0);
  wind = new PVector(0,0,0);
}
 
void draw(){
  background(#000000);
  
  //se modifica el viento aleatorio
  if(viento){
    wind.x = 50.5+random(0,10);
    wind.y = 0.012+random(-1,1);
    wind.z = 5+random(0,10);
  }
  
  for (int i = 0; i < 25; i++)
  {
    tela1.update();
    tela2.update();
    tela3.update();
    tela4.update();
  }
  tela1.display();
  tela2.display();
  tela3.display();
  tela4.display();
  
  fill(255);  
 /* text("STRUCTURED", 20, 15);
  text("STRUCTURED + SHEAR", 250, 15);
  text("STRUCTURED + BEND", 520, 15);
  text("STRUCTURED + SHEAR + BEND", 740, 15);

  text("FrameRate: " + frameRate , 20, height-70);
  text("dt: " + dt, 220, height-70);
  if(viento){
    text("viento: " + wind, 300, height-70);
    text("Estado del viento: activado", 300, height-90);
  }
  else
    text("Estado del viento: desactivado " + wind, 300, height-70);
  text("Para reiniciar, pulse espacio ", 20, height-50);
  text("Para modificar el estado del viento, pulse 'v' ", 300, height-50);
  text("Para modificar el estado del grid, pulse 'g' ", 300, height-30);
  text("Para modificar el estado de la textura, pulse 't' ", 300, height-10);
  */
}

//interacción
void keyPressed(){
  if(key == ' ')
    ini();
  if(key == 'v' || key == 'V')
    viento = !viento;
  if(key == 't' || key == 'T')
    textura = !textura;
  if(key == 'g' || key == 'G')
    grid = !grid;
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
  Particle(PVector l, float radio_, boolean fixed_, int x_, int y_) {
    radio = radio_;
    fixed = fixed_;
    acceleration = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0); //marca la forma del emisor
    location = l.get();
    vDamp = new PVector(0, 0, 0);
    force = new PVector(0, 0, 0);
    massa = 1;
    x = x_; //índices de la tela
    y = y_;
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



// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class Tela {
  Particle[][] particles;
  int type;
  float k, damping;
  Tela(int distPart, int type_, float loc, float k_, float damping_) {
    boolean fix;
    type = type_;
    k = k_;
    damping = damping_;
    particles  = new Particle[gridFilas][gridColum];
    for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++){
        if(i==0)
          fix = true;
        else
          fix = false;
        particles[i][j] = new Particle(new PVector(i*distPart + loc, j*distPart, 0), radio, fix, i, j); 
      }
  }

 

  void update() {
   for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++){
        //se resetean
        particles[i][j].acceleration.set(0, 0, 0);
        particles[i][j].force.set(0, 0, 0);
        
        particles[i][j].force.add(PVector.mult(gravity,particles[i][j].massa));  //gravedad
      
        particles[i][j].vDamp.set(particles[i][j].velocity.x, particles[i][j].velocity.y, particles[i][j].velocity.z);
        particles[i][j].vDamp.mult(-damping);
        particles[i][j].force.add(particles[i][j].vDamp);
        
        //viento
        if(viento){
          PVector windProp = updateWind(i, j, particles[i][j]);
          particles[i][j].force.add(windProp);
        }
        
        if (type == STRUCTURED || type == TOT || type == SHEAR || type == BEND){
          particles[i][j].force.add(getForce(i, j+1, distPart, k, particles[i][j]));
          particles[i][j].force.add(getForce(i, j-1, distPart, k, particles[i][j]));
          particles[i][j].force.add(getForce(i+1, j, distPart, k, particles[i][j]));
          particles[i][j].force.add(getForce(i-1, j, distPart, k, particles[i][j]));
        }
        if (type == SHEAR || type == TOT) {
          particles[i][j].force.add(getForce(i-1, j+1, distPartDiag, k, particles[i][j]));
          particles[i][j].force.add(getForce(i-1, j-1, distPartDiag, k, particles[i][j]));
          particles[i][j].force.add(getForce(i+1, j+1, distPartDiag, k, particles[i][j]));
          particles[i][j].force.add(getForce(i+1, j-1, distPartDiag, k, particles[i][j]));
        }
        if (type == BEND || type == TOT) {
          particles[i][j].force.add(getForce(i-2, j, distPart*2, k, particles[i][j]));
          particles[i][j].force.add(getForce(i+2, j, distPart*2, k, particles[i][j]));
          particles[i][j].force.add(getForce(i, j+2, distPart*2, k, particles[i][j]));
          particles[i][j].force.add(getForce(i, j-2, distPart*2, k, particles[i][j]));
        }
        
      }
      
   for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++){
        particles[i][j].update();
      }
      
  }
    
  void display(){
    pushMatrix();
    translate(20, 20, 0);
    
    if (grid) 
      stroke(255);
    else
      noStroke();

    for(int x = 0; x < gridFilas-1; x++){
      beginShape(QUAD_STRIP);
      if(textura)
        texture(texturaBandera);
      for(int y = 0; y < gridColum; y++){
        PVector p1 = particles[x][y].location;
        PVector p2 = particles[x+1][y].location;
        if(textura){
		  fill(#ffffff);
          vertex(p1.x, p1.y, p1.z, x*(texturaBandera.width/(gridFilas-1)), y*(texturaBandera.height/(gridColum-1))); //u, v
          vertex(p2.x, p2.y, p2.z, (x+1)*(texturaBandera.width/(gridFilas-1)), y*(texturaBandera.height/(gridColum-1)));
        }
        else{
			fill(240, 70, 70);
          vertex(p1.x, p1.y, p1.z);
          vertex(p2.x, p2.y, p2.z);
        }
      } 
      endShape();
    }
    popMatrix();
  }
  
  //obtiene la fuerza de la partícula que se quiera (particles[x][y])
  PVector getForce(int x, int y, float d, float k, Particle p1){
    //x e y son los índices de la particula en la tela
    PVector force = new PVector(0, 0, 0);
    PVector dist = new PVector(0, 0);
    float L = 0.0;
     
    //si no se sale de rango (es un vecino que existe)
    if (x >= 0 && x < gridFilas && y >= 0 && y < gridColum) 
    { 
      Particle p2 = particles[x][y];
       
      dist = PVector.sub(p1.location, p2.location);
      L = dist.mag() - d; 
      dist.normalize();       
      force = PVector.mult(dist, -k*L);
    }    
    return force;
  }
  
  //calcula el viento de la partícula dada
  PVector updateWind(int x, int y, Particle p1) {
    PVector d1 = new PVector();
    PVector d2 = new PVector();
    PVector normalVertex;
    float proporcion;
    
    if(x == 0) //primera columna
    {
      if(y == 0){ //primer elemento
        d1 = PVector.sub(p1.location, particles[x][y+1].location); // Con el de abajo
        d2 = PVector.sub(p1.location, particles[x+1][y].location); // Con el de derecha
      }
      else if(y == gridFilas-1) //último elemento
      {
        d1 = PVector.sub(p1.location, particles[x+1][y].location); // Con el de derecha
        d2 = PVector.sub(p1.location, particles[x][y-1].location); // Con el de arriba
      }
      else{ //resto de primera columna
        d1 = PVector.sub(p1.location, particles[x+1][y].location); // Con el de derecha
        d2 = PVector.sub(p1.location, particles[x][y-1].location); // Con el de arriba
      }
    } //fin primera columna
    
    
    else{
      if(x == gridColum-1) //última columna
      {
        if(y == 0) //primer elemento
        {
          d1 = PVector.sub(p1.location, particles[x-1][y].location); // Con el de izquierda 
          d2 = PVector.sub(p1.location, particles[x][y+1].location); // Con el de abajo
        }  
        else if(y == gridFilas-1) //último elemento
        {
          d1 = PVector.sub(p1.location, particles[x][y-1].location); // Con el de arriba
          d2 = PVector.sub(p1.location, particles[x-1][y].location); // Con el de izquierda       
        }
        else{//resto de última columna
          d1 = PVector.sub(p1.location, particles[x][y-1].location); // Con el de arriba
          d2 = PVector.sub(p1.location, particles[x-1][y].location); // Con el de izquierda  
        }
      }//fin última columna
      
      
      else if(y == 0)//primera fila
            {
              d1 = PVector.sub(p1.location, particles[x-1][y].location); // Con el de izquierda 
              d2 = PVector.sub(p1.location, particles[x][y+1].location); // Con el de abajo      
            }
      
      
            else if(y == gridFilas-1) //última fila
            {
              d1 = PVector.sub(p1.location, particles[x][y-1].location); // Con el de arriba
              d2 = PVector.sub(p1.location, particles[x-1][y].location); // Con el de izquierda 
            }
      
      
            else //resto(centro)
            {
              d1 = PVector.sub(p1.location, particles[x+1][y].location); // Con el de derecha
              d2 = PVector.sub(p1.location, particles[x][y+1].location); // Con el de abajo 
            }          
    }
    
    // Se calcula la normal del vértice
    normalVertex = d1.cross(d2);
    normalVertex.normalize();
     
    // Se calcula el resultado proporcional
    proporcion = PVector.dot(normalVertex, wind);
    normalVertex.mult(proporcion);
     
    return normalVertex;
  }
}