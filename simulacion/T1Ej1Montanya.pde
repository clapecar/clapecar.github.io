/*Clara Peñalva
 Tema 1 - Ejercicio 1: Simular el movimiento de una
 circunferencia que se mueve a tramos de velocidad*/

//variables globales
PVector pos, vel;
float dt, t;

//ArrayList para ir almacenando velocidades/posiciones y crear tramos
void setup() //constructor de todo
{
  size(750, 500);
  pos = new PVector(0, height/3);
  vel = new PVector(100, 50);
  t =0;

  textSize(20);
}

void draw()
{
  dt = 1/frameRate; //velocidad de verdad
  t += dt;
  background(255);
  fill(0);
  line(width/3, 0, width/3, height);
  line(width/3*2, 0, width/3*2, height);
  line(width, 0, width, height);
  text("3 tramos a distintas velocidades.", 20, 40);
  text("Velocidad actual x: " + vel.x, 40, 60);
  text("Velocidad actual y: " + vel.y, 40, 80);
  //tenemos un obj movil, necesitaremos una posicion, vel, diferencial de tiempo
  
  ellipse(pos.x, pos.y,  30, 30); //pinta donde esté el ratón. pinta en pixels
  //refleja la velocidad frente al tiempo
  //ellipse(t*10, height - vel.x, 10, 10);
  if(pos.x < width/3){
      vel.x = 100; 
      vel.y = 50;
  }
  else{
    if(pos.x < width/3*2){
        vel.x = 50 ; 
        vel.y = -40;
    }
    else{
      if(pos.x > width){
        pos.x = 0;
        pos.y = height/3;
        vel.x = 100;
        vel.y = 50;
      }
      else{
        vel.x = 120;
        vel.y = 70;
       }
      }
    } 
    pos.x += vel.x * dt;
    pos.y += vel.y * dt; 
}