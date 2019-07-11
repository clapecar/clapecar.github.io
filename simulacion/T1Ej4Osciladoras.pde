/*Clara Peñalva
  Tema 1 - Ejercicio 4: Animar el movimiento de una particula 
  a velocidad v sobre las 2 funciones osciladoras.*/
 
float t, dt, pos_y;
PVector pos, pos2;
int vel;
ArrayList<PVector> estela;
ArrayList<PVector> estela2;

void setup(){
  size(700,650);
  ini();

  textSize(20);
}
 
void draw()
{   
  background(#FFFFFF); 
  fill(#000000);
  text ("Para volver a comenzar, pulse 'espacio'.", 30, 40);
  
  //Función 1  
  pos.x += vel * dt;
  pos2.x += vel * dt;
  //con escalado horizontal: 1/10 y vertical: 100 para uqe se visualice bien
  pos.y = sin(pos.x * 1/4) * exp(-0.002 * pos.x * 1/4) * 100; 
  fill(#ff0000);
  ellipse(pos.x, (pos_y/2)+pos.y, 20, 20);
  estela.add(pos.get());
  for (int i = 0; i < estela.size(); i++) {
    ellipse(estela.get(i).x, (pos_y/2)+estela.get(i).y, 5, 5);
  }
  
  //línea separatoria
  fill(#000000);
  line(0,height/2,width,height/2);
   
  //Función 2  
  pos2.y = (0.5 * sin(3 * pos2.x * 1/15) + 0.5 * sin(3.5 * pos2.x * 1/15)) * 100;
  fill(#ff0000);
  ellipse(pos2.x, (pos_y*1.5) + pos2.y, 20, 20); 
  estela2.add(pos2.get());
  for (int i = 0; i < estela2.size(); i++) {
    ellipse(estela2.get(i).x, (pos_y*1.5) + estela2.get(i).y, 5, 5);
  }
  
  t += dt;
  
  //parar la animación
  if(pos.x > width - 40){
    noLoop();
  }
}

//Parametros inicio
void ini(){
  pos_y = height/2;
  vel = 4; 
  pos = new PVector(40, height/2);
  pos2 = new PVector(40, height/2);
  estela = new ArrayList<PVector>();
  estela2 = new ArrayList<PVector>();
  dt = 0.1; 
  t = 0;
}

//Interaccion
void keyPressed(){
  if(key == ' ')
  //volver a empezar
      estela.clear();
      estela2.clear();
      loop();
      ini();
}