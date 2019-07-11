/*Clara Peñalva
Tema 1 - Ejercicio 6: Implementar una rutina que simule el movimiento 
de una partícula a lo largo de la espiral 2D de la figura. La función
recibirá el diferencial de tiempo transcurrido desde la llamada
anterior y debe moverse a una velocidad w en vueltas/seg.
Parámetros: inicio(1, 0), fin(0, 0)*/
 
float dt; //diferencial de tiempo
float radio, r_ini;
float t, w, f;
int num_vuelt;
PVector pos, vel;
boolean inicio, primero;
void setup(){
  size(650,650);
  num_vuelt = 4; //se puede modificar
  ini();
  textSize( 20);
}
 
void draw(){
  dt = 1/frameRate;

  fill(#FA5858);
  
  //actualiza posiciones
  pos.x = width/2 + radio*cos(w*t);
  pos.y = height/2 + radio*sin(w*t);
  
  //dibuja la siguiente posición
  ellipse(pos.x, pos.y, 10, 10);
     
  if(radio <= 0){ //Para que pare
     //Resultados
     fill(#000000);
	 if(primero){
		text("Tiempo: " + t, 30, 100); 
		primero = false;
	 }
  }
  else{
    radio -= r_ini/num_vuelt * f * dt; //modifica en función de las vueltas
    t += dt; 
  }
  
  //escribe el num. de vueltas al principio
  if(inicio){
    fill(#000000);
    text("Vueltas: " + num_vuelt, 30, 70);
	text ("Volver a comenzar: 'espacio'", 30, 40);
	text ("Modificar el número de vueltas:'+' o '-'", 300, 40);
    line(30, width/2, 620, width/2);
    line(height/2, 60, height/2, 630);
    inicio = false;
  }
}

void ini(){
  background(#ffffff);
  inicio = true;
  primero = true;
  r_ini = 300; //radio inicial
  radio = r_ini;
  t = 0;
  f = 1; //frecuencia
  w = TWO_PI * f;
  pos = new PVector(1, height/2);
}

//Pulsar espacio para volver a empezar
void keyPressed(){
  if(key == ' '){
    ini();
  }
  if(key == '+'){
    if(num_vuelt < 10)
      num_vuelt ++;
    ini();
  }
  if(key == '-'){
    if(num_vuelt > 0)
      num_vuelt --;
    ini();
  }
}