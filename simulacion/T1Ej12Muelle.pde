/*Clara Peñalva
Tema 1 - Ejercicio 12: Simular el escenario de la figura para interactuar
con un muelle con y sin amortiguación.*/
  
final int AMORT = 0;
final int NAMORT = 1; 
//variables
Muelle mAmort, mNAmort; 
float dt, lact, lrep, kd, masa;
void setup() {
  size(450, 450);
  kd = 0.05;
  masa = 2.0;
  ini();
  
  f = loadFont("ArialMT-48.vlw");
  textSize(18);
}
 
void draw() {
  background(#ffffff);
  fill(#000000);
  text("Para volver a comenzar, pulse 'espacio'", 40, 40);
  fill(#ff0000);
  text("Muelle con amortiguador", 40, 60);
  fill(#045FB4);
  text("Muelle sin amortiguador", 40, 80);  
  fill(#000000);
  text("Valor de Kd: " + kd, 40, 110); 
  text("Valor dela masa: " + masa, 40, 130); 
  
  fill(#000000);
  text("Modificar el valor Kd: '+' o '-'", 40, 400);
  text("Modificar la masa: 'flecha arriba' 'flecha abajo'", 40, 420);
  
  translate(width/2, height/3);
  stroke(#000000);
  line(-150, 0,150, 0);
  line(-50,0,-50, mAmort.l);
  line(50,0,50, mNAmort.l);
  fill(#ff0000);
  mAmort.run();
  fill(#045FB4);
  mNAmort.run();
}

void ini(){
  dt = 0.1;
  lact = 150.0;
  lrep = 120.0;
  
  mAmort = new Muelle(lact, lrep, masa, AMORT, kd);
  mNAmort = new Muelle(lact, lrep, masa, NAMORT, 0.0);
}
 
//pausar la simulación
void mousePressed() {
  noLoop();
}

void mouseReleased() {
  loop();
}

class Muelle {
  float  l, lrep, vel, a, fk, ks, kd, g, masa;
  int mode;
  Muelle(float lini, float lrep0, float mas_, int m_, float kd_) {
    l = lini;
    lrep = lrep0;
    masa = mas_;
    mode = m_;
    g = 9.8;
    ks = -0.6;
    kd = kd_; //solo para el amortiguador
    vel = 0;
    
  }
  
  void run(){
    display();
    update();
  }  
  
  void display() {
    switch (mode)
    {
      case AMORT:
        ellipse(-50,  l, masa*20, masa*20);
        break;
      
      case NAMORT:
        ellipse(50,  l, masa*20, masa*20);
      break;
    }
  }
   
  void update(){
    switch (mode)
    {
      case AMORT:
        fk = ks * (l - lrep) - kd*vel;
        break;
      
      case NAMORT:
        fk = ks * (l - lrep);
      break;
    }
    a = fk - masa * g;
    vel += a * dt;
    l += vel * dt;
  }
}

void keyPressed(){
   
   if(key == ' '){
     ini();
   } 
   if(key == '+'){
     kd += 0.01;
     ini();
   } 
   if(key == '-'){
     kd -= 0.01;
     if(kd < 0.01)
       kd = 0;
     ini();
   } 
   if(keyCode == UP){
     masa += 0.1;
     ini();
   } 
   if(keyCode == DOWN){
     masa -= 0.1;
     if(masa < 0.1)
       masa = 0;
     ini();
   } 
}