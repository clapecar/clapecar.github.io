/*Clara Peñalva
  Práctica 5
*/
import peasy.*;

final int DIRECCIONAL = 1;
final int RADIAL = 2;
final int GERSTNER = 3;

//variables
Mar mar;
//PeasyCam camera;
float dt, t;
int gridFilas, gridColum, distPart;
float distPartDiag, tamMar;
PVector gravity;
boolean textura, grid;
int CantDir, CantRad, CantGerst;
PImage texturaBandera;


void setup(){  
  frameRate(60);
  size(700,300, P3D);
  smooth();
  /*camera = new PeasyCam(this, width/2, height/2, 0, 300);
  camera.lookAt(320, -100, 550);
  camera.rotateX(-PI/25);*/
  //camera(320, -100, 700, width/2, height/2, 0, 0.0, 1.0, 0.3);
  texturaBandera = loadImage("simulacion/Water_surface_lake.jpg");
  textSize(30);
  ini();
}

void ini(){
  /*DATOS MODIFICABLES*/ 
  dt = 0.05; //diferencial de tiempo
  gridFilas = 30;
  gridColum = 30;
  distPart = 20;
  tamMar = gridFilas * distPart;
  textura = true;
  grid = false;
              //(distancia, loc)
  mar = new Mar(distPart, 0);  
  CantDir = 0;
  CantRad = 0;
  CantGerst = 0;
  t = 0;
}
 
void draw(){
  background(#000000);
  //lights();
  mar.update();
  mar.display();
  
  fill(255); 
 /* text("FrameRate: " + frameRate , 20, -height+20, 20);
  text("dt: " + dt, 400, -height+20, 20);
  text("'D' Ondas direccionales: " + CantDir, 20, -height+55, 20);
  text("'R' Ondas radiales: " + CantRad, 20, -height+90, 20);
  text("'G' Ondas Gerstner: " + CantGerst, 20, -height+125, 20);
  text("Para reiniciar, pulse 'espacio' ", 20, -height+160, 20);
  text("Para modificar el estado de la textura, pulse 'T' ", 20,  -height+195, 20);
  text("Para modificar la visualización de la malla, pulse 'M' ", 20, -height+230, 20);
  */
  t += dt;
}

//interacción
void keyPressed(){
  if(key == ' ')
    ini();
  if(key == 'd' || key == 'D'){ //direccional
            //Onda (int type_, float A_, float T_, float longOnda_, PVector src_dir_)
     mar.ondas.add(new Onda(DIRECCIONAL, random(1,4), random(5,10), random(40,60), new PVector(random(0,1), 0, random(0,1))));
     CantDir++;
  }   
  if(key == 'r' || key == 'R'){ //radial
    mar.ondas.add(new Onda(RADIAL, random(2,8), random(5,10), random(40,60), new PVector(tamMar/2, 0, tamMar/2)));
    CantRad++;
  }
  if(key == 'g' || key == 'G'){ //gerstner
     mar.ondas.add(new Onda(GERSTNER, random(1,8), random(5,10), random(40,60), new PVector(random(0,1), 0, random(0,1))));
    CantGerst++;
  }
  if(key == 'm' || key == 'M'){ //grid
    grid = !grid;
  } //<>//
  if(key == 't' || key == 'T'){ //textura
    textura = !textura;
  }
} 
//nueva ola radial
void mouseClicked() { 
  mar.ondas.add(new Onda(RADIAL, random(2,8), random(5,10), random(40,60), new PVector(mouseX, 0, mouseY)));
  CantRad++;
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class Mar {
  Particle[][] particles; //particulas que constituyen la malla
  ArrayList<Onda> ondas; //ondas contenidas en la malla
  Mar(int distPart, float loc) {
    particles  = new Particle[gridFilas][gridColum];
    ondas = new ArrayList<Onda>();
    for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++){
        particles[i][j] = new Particle(new PVector(60+i*distPart + loc, 200, -500+j*distPart), i, j); 
      }
  }

  void update() {
   for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++){
        //se actualiza la posicion de cada partícula de la malla según las ondas que hayan
        particles[i][j].update();       
      }
      
  }
    
  void display(){
    pushMatrix();
    translate(20, 20, 0);
    fill(1, 169, 219);
    if (grid) 
      stroke(122, 16, 39);
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
          vertex(p1.x, p1.y, p1.z, x*(texturaBandera.width/(gridFilas-1)), y*(texturaBandera.height/(gridColum-1))); //u, v
          vertex(p2.x, p2.y, p2.z, (x+1)*(texturaBandera.width/(gridFilas-1)), y*(texturaBandera.height/(gridColum-1)));
        }
        else{
          vertex(p1.x, p1.y, p1.z);
          vertex(p2.x, p2.y, p2.z);
        }
      } 
      endShape();
    }
    popMatrix();
  }
}





class Onda {
  int type;
  float A, T, longOnda, f, vel, W, w, phi; 
  PVector src_dir;
  Onda (int type_, float A_, float T_, float longOnda_, PVector src_dir_){
    type = type_;
    A = A_;
    T = T_;
    longOnda = longOnda_; 
    src_dir = src_dir_.get();
    f = 1/T_;
    vel = longOnda_/T_;
    
    W = 2 * PI / T_;
    w = 2 * PI / longOnda_;
    phi =  2 * PI / T_;
    
  }
  
  PVector evaluate_auto(float t, PVector pto)
  {
    PVector res = new PVector(0.0, 0.0, 0.0);
    switch(type){
      case DIRECCIONAL: 
        src_dir.normalize();
        res.y = A * sin(w * PVector.dot(src_dir, pto) + phi * t);
      break;
      
      case RADIAL:
        res.y = A * sin(w * src_dir.dist(pto) - phi * t);
      break;
      
      case GERSTNER:
        float Q = (2*A*PI)/T;
        src_dir.normalize();
        res.x = res.x + Q * A * src_dir.x * cos(w * PVector.dot(src_dir, pto) + phi * t);
        res.y = res.y + Q * A * src_dir.y * cos(w * PVector.dot(src_dir, pto) + phi * t);
       // res.z = A * sin(w * PVector.dot(src_dir, pto) + phi * t);
      break;
    } 
     return res;
  }
}




class Particle {
  PVector location, locationOrig;
  int x, y;
  Particle(PVector l, int x_, int y_) {
    location = l.get();
    locationOrig = l.get();
    x = x_; //índices de la tela
    y = y_;
  }

 
  // Method to update location
  void update() { 
    //se resetea la posición de la partícula
    location.set(locationOrig);
    for(Onda onda : mar.ondas){ //se recorren todas las ondas 
      //se modifican esas posiciones sumando las ondas 1º y 2º sobre la y, tercero tambien sobre la x y la z
      PVector newLoc = onda.evaluate_auto(t, locationOrig);      
      location.x += newLoc.x;
      location.y += newLoc.y;
      location.z += newLoc.z;
    }
  }    
}