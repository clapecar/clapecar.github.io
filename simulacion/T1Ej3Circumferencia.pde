/*Clara Peñalva
 Tema 1 - Ejercicio 3: Simular el movimiento de una 
 bola alrededor de un punto situado a una distancia r
 de la bola. Dará una vuelta por segundo.*/

float dt; //incremento del tiempo
float t; //tiempo
float w;
float radio; //distancia
float ang; //angulo
PVector posB; //vector que almacena posición de la bola 
void setup() {
  size(500,500);  
  ini();
  textSize( 20);
}

void draw() {
  dt = 1/frameRate;
  
  background(#ffffff);
  //lineas coordenadas
  fill(#000000); //Color del centro
  text ("Para volver a comenzar, pulse 'espacio'.", 30, 470);
  stroke(0);
  strokeWeight(1);
  line(50, height/2, 450, height/2);
  line(width/2, 50, width/2, 450);
  ellipse(width/2, height/2, 5, 5); //dibujamos el centro
  
  //Resultados
  fill(#000000);
  text("Tiempo: " + t, 30, 40); 
  
  fill(#0B2161); //Color de la bola
  ellipse(posB.x, posB.y, 20, 20); //dibujamos la bola
  posB.x=width/2 + radio*cos(w*t);
  posB.y=height/2 + radio*sin(w*t);
  
  t += dt;
  ang += dt*w; //variación del ángulo en función del tiempo
}


void ini(){
  posB = new PVector(0, 0);
  radio = 150;
  ang = 0;
  t = 0;
  w = 2*3.1416;  
}

void keyPressed(){
  if(key == ' ')
      ini();
}