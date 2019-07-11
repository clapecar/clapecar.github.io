/*Clara Peñalva
Tema 1 - Ejercicio 13: Obtener la gráfica de velocidad y simular 
el movimiento de un coche con acelerador.*/

int t; //tiempo actual
float dt; //diferencial de tiempo
Coche coche;
int widthFunc;
int heightFunc;
float [] copiaVel;
float vel_max; //velocidad máxima
boolean avDrcha; 
  
void setup()
{
  size(1000,600);
  ini();
  smooth();
  textSize(24);
}
  
void draw()
{
  background(255);
  fill(0,0,0);

  
  text("Para acelerar, pulse la flecha derecha o izquierda.", 40, 40);
  text("Para volver a comenzar, pulse 'espacio'.", 40, 80);
  text("Gráfica velocidad / tiempo:", 40, 470);
  stroke(0);
  strokeWeight(2);
  line(0, 282, width, 282);
 
  //Actualizo valores coche
  coche.updateCar();
  
  //Actualizo gráfica
  //se actualiza la velocidad máxima para ajustar la gráfica  
  if(vel_max < abs(coche.vel))
     vel_max = abs(coche.vel);
  copiaVel[t] = abs(coche.vel);
  updateFunc(t); //<>//
  t = (t+1) % widthFunc; //para que la gráfica se reinicie ("t vuelve a 0")
   
  //Dibujo coche
  coche.drawCar();
    
  if(keyPressed) //si se apreta la flecha de la derecha //<>//
  {
    if(keyCode == RIGHT){
      avDrcha = true;
      coche.AplicarPotencia();
    }
    if(keyCode == LEFT){
      avDrcha = false;
      coche.AplicarPotencia();
    }
    
  }
   
}

//Inicializo los valores
void ini(){
  avDrcha = true;
  dt = 0.2; //diferencial de tiempo
  widthFunc = width-10;
  heightFunc = height/6;
  copiaVel = new float[widthFunc];
  vel_max = 0.0; //velocidad máxima
  t = 0; //tiempo actual
  coche = new Coche(4,0.0,0.0);
}

//Si se presiona espacio, se vuelve a empezar
void keyPressed(){
  if(key == ' '){
     ini();
   }
}  
void updateFunc(int time)
{
  stroke(0);
  strokeWeight(1);
  fill(255);
  rectMode(CORNER);
  rect(2,height-heightFunc-10, widthFunc, heightFunc+5);
  stroke(0);
  textSize(10);
  strokeWeight(3);
  stroke(255,0,0);
    
  for(int i = 5; i < time; i++)
    if(vel_max == 0.0)
      point (i, height - 7); //dibuja cuando aún no ha empezado
    else
     point (i, height - 7 - (copiaVel[i]/vel_max)*heightFunc);
 }
 
 
 class Coche
{
  float masa;   
  float Ec;
  PVector pos; 
  float vel;
  float P; //potencia (cte, se calibra)
  float P_roz;
  float K; //coeficiente rozamiento  
  Coche(float m, float v, float en)
  {
    masa = m;
    vel = v;
    Ec = en;
    pos = new PVector(0,0);
    P = 500;
    K = 0.2;
  }
    
  //Se aplica la potencia, aumenta la energía
  void AplicarPotencia()
  {
    Ec += P * dt;
  }
 
  //Actualiza la velocidad
  void updateVelo()
  {
    P_roz = -K*vel*vel; //frena el coche
    Ec = Ec + (P_roz*dt);
    
    //La velocidad se invierte si la dirección lo hace
    if (avDrcha)
      vel = sqrt(2*Ec/masa);
    else
      vel = -sqrt(2*Ec/masa);
  }
  void updateCar(){
    
    updateVelo();
    pos.x = pos.x + coche.vel * dt;
    //si se sale de pantalla
    if (pos.x > 1000 && avDrcha) {
        pos.x = -100; //hacemos que aparezca por la izquierda
    }
    if (pos.x < -150 && !avDrcha) {
        pos.x = 1000; //hacemos que aparezca por la derecha
    }
  }
  void drawCar()
  {
    pushMatrix();
    translate(pos.x, 0);
    stroke(0);
    strokeWeight(1);   
    fill(1,169,219);
    rect(40, 230, 80, 40);
    fill(0,0,0);
    ellipse(60,270, 25, 25);
    ellipse(100,270, 25, 25);
    fill(255,255,255);
    ellipse(60,270, 10, 10);
    ellipse(100,270, 10, 10);
    popMatrix();
    
  }
}