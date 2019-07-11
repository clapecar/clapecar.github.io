/*Clara Peñalva
Tema 1 - Ejercicio 14: Simular el movimeinto de una nave espacial*/

int t; //tiempo actual
float dt; //diferencial de tiempo
Coche coche;
int widthFunc;
int heightFunc;
int cont;
boolean avDrcha, avUp,  avIzq, win; 
  
void setup()
{
  size(1000,750);
  ini(0);
  smooth();
  textSize(30);
}
  
void draw()
{
  if(!win){
    background(255);
    fill(0,0,0);
    
    text("JUEGO: llega a la segunda estrella a la derecha,", 20, 620);
	 text("pero sin tocar las paredes y el techo. ¡Si te chocas, vuelve a empezar!", 20, 650);
    text("Para acelerar, pulsa la flecha derecha, izquierda o arriba.", 200, 680);
    text("Para volver a comenzar,pulsa 'espacio'.", 200, 710);
    text("Repeticiones: " + cont, 50,740);
    stroke(0);
    strokeWeight(2);
    fill(#F4FA58);
    ellipse(150, 100, 50, 50);
    ellipse(80, 160, 25, 25);
    line(10, 575, width-10,575);
    line(10, 40, width-10,40);
    line(10, 575, 10, 40);
    line(width-10, 575, width-10, 40);
    //Actualizo valores coche
    coche.updateCar(); //<>//
     
    //Dibujo coche
    coche.drawCar();
      
    if(keyPressed) //si se apreta la flecha de la derecha //<>//
    {
      if(keyCode == RIGHT){
        avDrcha = true;
        avIzq = false;
        avUp = false;
        coche.AplicarPotencia();
      }
      if(keyCode == LEFT){
        avIzq = true;
        avDrcha = false;
        avUp = false;
        coche.AplicarPotencia();
      }
      if(keyCode == UP){
        avUp = true;
        avDrcha = false;
        avIzq = false;
        coche.AplicarPotencia();
      }
      
    }
  }
  else
  {
    textSize(40);
    text("¡Enhorabuena, has llegado al País de Nunca Jamás!", 40, height/2);
    textSize(30);
    text("Para volver a comenzar,pulsa 'espacio'.", 40, height/2 + 50);
  }
 
}

//Inicializo los valores
void ini(int c){
  resetBool();
  cont = c;
  win = false;
  dt = 0.2; //diferencial de tiempo
  widthFunc = width-10;
  heightFunc = height/6;
  t = 0; //tiempo actual
  coche = new Coche(4, new PVector(0.0, 0.0), 0.0);
}

//Si se presiona espacio, se vuelve a empezar
void keyPressed(){
  if(key == ' '){
     ini(0);
   }
}  

void resetBool(){
  avDrcha = false;
  avIzq = false;
  avUp = false;  
}

class Coche
{
  float masa;   
  PVector Ec;
  PVector pos; 
  PVector vel;
  float P, P2; //potencia (cte, se calibra)
  float P_roz, P_roz2;
  float K, K2; //coeficiente rozamiento  
  Coche(float m, PVector v, float en)
  {
    masa = m;
    vel = v.get();
    Ec = new PVector(en, 0);
    pos = new PVector(0,0);
    P = 500;
    P2 = 200;
    K = 0.2;
	K2 = 1.2;
  }
    
  //Se aplica la potencia, aumenta la energía
  void AplicarPotencia()
  {
    if(avDrcha || avIzq)
      Ec.x += P * dt;
    if(avUp)
      Ec.y += P2 * dt;
  }
 
  //Actualiza la velocidad
  void updateVelo()
  {
    P_roz = -K *(vel.x * vel.x); //frena el coche
    P_roz2 = -K2 *(vel.y * vel.y);
    Ec.x = Ec.x + (P_roz*dt);
    Ec.y = Ec.y + (P_roz2*dt);
    //La velocidad se invierte si la dirección lo hace
    if (avDrcha)
      vel.x = sqrt(2*Ec.x/masa);
    if(avIzq)
      vel.x = -sqrt(2*Ec.x/masa);
    
    //velocidad hacia arriba
    vel.y = -sqrt(2*Ec.y/masa);
           
  }
  void updateCar(){
    
    updateVelo();
    pos.x = pos.x + coche.vel.x * dt;        
    pos.y = pos.y + (coche.vel.y + 9.8*dt) * dt;
    
    //si se tocan las paredes, vuelve a empezar
    if (pos.x > width/2-50 || pos.x < -width/2+50 || pos.y < -480 ) {
        
        ini(cont += 1);
    }
 
    if ((pos.x < -320 && pos.x > -350) && (pos.y > -460 && pos.y < -410)) {
        win = true; 
    }
  
   //para que no caiga
    if (pos.y > 0) {
        pos.y = 0; 
    }

  }
  void drawCar()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    stroke(0);
    strokeWeight(1);   
    fill(1,169,219);
    arc(width/2, 550, 50, 50, PI, TWO_PI);
    line(width/2-25, 550, width/2-35, 560);
    line(width/2+25, 550, width/2+35, 560);
    arc(width/2, 560, 70, 25, 0, PI, OPEN);
    popMatrix(); 
  }
}