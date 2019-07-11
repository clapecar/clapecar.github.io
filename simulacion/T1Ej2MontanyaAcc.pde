/*Clara Peñalva
 Tema 1 - Ejercicio 2: Simular el movimiento de una
 circunferencia que se mueve a tramos de velocidad. 
 Añadiendo aceleración*/

//variables globales
PVector pos, vel, acel;
float dt, t;
float[] pendientes;
boolean flag1, flag2;
void setup() //constructor de todo
{
  size(750, 500);
  pos = new PVector(0, height/3);
  vel = new PVector(100, 50);
  acel = new PVector(10, 0);
  flag1 = true;
  flag2 = true;
  pendientes = new float[3];
  pendientes[0] = -10;
  pendientes[1] = 5;
  pendientes[2] = -15;
  t =0;
  textSize( 20);
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
  text("3 tramos con velocidades y aceleraciones.", 20, 40);
  text("Velocidad actual x: " + vel.x, 40, 60);
  text("Velocidad actual y: " + vel.y, 40, 80);
  //tenemos un obj movil, necesitaremos una posicion, vel, diferencial de tiempo
  
  ellipse(pos.x, pos.y,  30, 30); //pinta donde esté el ratón. pinta en pixels
  //refleja la velocidad frente al tiempo
  //ellipse(t*10, height - vel.x, 10, 10);
 
      if(pos.x < width/3*2 && pos.x >= width/3){
        if(flag1){
          vel.x = 70;
          vel.y = -30;
          acel.x = -5;
          flag1 = false;   
          
        }
      }
      else{
        if(pos.x < width && pos.x >= width/3*2){
          if(flag2){
            vel.x = 120;
            vel.y = 50;
            acel.x = 25;
            flag2 = false;
          }
        }
        else{
          if(pos.x > width){          
            pos.x = 0;
            pos.y = height/3;
            vel.x = 100;
            vel.y = 50;
            acel.x = 10;
            flag1 = true;
            flag2 = true;
          }
         }
        }
    
    vel.x += acel.x * dt; 
    vel.y += acel.x * dt; 
    pos.x += vel.x * dt;
    pos.y += vel.y * dt; 
}