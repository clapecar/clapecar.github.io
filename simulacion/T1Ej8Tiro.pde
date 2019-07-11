/*Clara Peñalva
Tema 1 - Ejercicio 8: Simular un tiro parabólico (velocidad inicial v, 
gravedad g y masa m) con el método de Euler y calcular el error
cometido.*/


final int ANALIT = 0;
final int EU = 1;
final int EUSEMIM = 2;
final int HEUN = 3;
final int RK4 = 4;

//variables
float dt, t; //diferencial de tiempo
boolean inicio, fin;
Tiro Tanalit, Teu, Teusemim, Theun, TRK4;

void setup(){
  size(850,650);  
  ini();
  textSize(24);
}
 
void draw(){
  if(inicio){
    fill(#000000);
    text("Para volver a comenzar, pulse 'espacio'", 350, 40);
    fill(119, 119, 119, 255);
    text("Solución analítica", 220, 400);
    fill(190, 24, 24, 255);
    text("Euler explícito", 220, 430);
    fill(139, 18, 176, 255);
    text("Euler semimplícito", 220, 460);
    fill(228, 210, 11, 255);
    text("Heun", 220, 490);
    fill(18, 176, 65, 255);
    text("RK4", 220, 520); 
    
    //superficie sobre la que empieza
    fill(#cccccc);
    rect(10, 360, 200, 280);
    
    inicio = false;
  }
  if(Tanalit.pos.x > width - 50 ){
    fin = true;
  }
  if(fin){
    noLoop();
    fill(119, 119, 119, 255);
    text(" dt = " + dt, 220, 550);
    fill(190, 24, 24, 255);
    text(", error: " + abs(Tanalit.pos.y - Teu.pos.y), 370, 430);
    fill(139, 18, 176, 255);
    text(", error: " + abs(Tanalit.pos.y - Teusemim.pos.y), 415, 460);
    fill(228, 210, 11, 255);
    text(", error: " + abs(Tanalit.pos.y - Theun.pos.y), 275, 490);
    fill(18, 176, 65, 255);
    text(", error: " + abs(Tanalit.pos.y - TRK4.pos.y), 265, 520); 
    fin = false;
  }
  Tanalit.run();
  Teu.run();
  Teusemim.run();
  Theun.run();
  TRK4.run();
  
  t += dt;
} 

void ini(){
  
  //Valores iniciales
  dt = 0.2;
  t = 0;  
  inicio = true;
  fin = false;
  background(#ffffff);
  Tanalit = new Tiro(new PVector(20, height - 300), ANALIT);
  Teu = new Tiro(new PVector(20, height - 300), EU);
  Teusemim = new Tiro(new PVector(20, height - 300), EUSEMIM);
  Theun = new Tiro(new PVector(20, height - 300), HEUN);
  TRK4 = new Tiro(new PVector(20, height - 300), RK4);  
}

//Pulsar espacio para volver a empezar
void keyPressed(){
  if(key == ' '){
    loop();    
    ini();
    
  }
}

class Tiro{
  PVector pos, pos0, vel, a;
  int mode;
  float dt, g, m;
  
  PVector pos1, vel1, pos2, vel2;
  PVector pos3, vel3, pos4, vel4, velTot;
  
  Tiro(PVector pos_, int mode_ ){
    g = 9.8;
    pos = pos_.get();
    pos0 = pos_.get();
    vel = new PVector(50, -70);
    a = new PVector(0, g);
    mode = mode_;
    dt = 0.2;  
    m = 1;
  }
  
  void update(){
    switch (mode)
    {
      case ANALIT:
        vel.x += a.x*dt;
        vel.y += a.y*dt;
       
        pos.x = vel.x * t + pos0.x;
        pos.y = -0.5*g*t*t + vel.y * t + pos0.y;
      
      break;
      
      case EU:      
        pos.x += vel.x *dt;
        pos.y += vel.y *dt;
        
        vel.x += a.x*dt;
        vel.y += a.y*dt;
        
        break;
        
      case EUSEMIM:
        vel.x += a.x*dt;
        vel.y += a.y*dt;
        
        pos.x += vel.x *dt;
        pos.y += vel.y *dt;
        break;      
        
      case HEUN:
        
        pos1 = pos.get();
        vel1 = vel.get();
        
        pos2 = PVector.add(pos1, PVector.mult(vel1, dt));
        vel2 = PVector.add(vel1, PVector.mult(a, dt));
		
        PVector mix = new PVector();
		mix = vel1.get();
		mix.add(vel2);
		mix.mult(dt/2);		
        pos = PVector.add(pos1, mix);
		
		mix = a.get();
		mix.add(a);
		mix.mult(dt/2);	
        vel = PVector.add(vel1, mix);
        break;
      
      case RK4:
        pos1 = pos.get();
        vel1 = vel.get();
        
        pos2 = PVector.add(pos1, PVector.mult(vel1, dt/2));
        vel2 = PVector.add(vel1, PVector.mult(a, dt/2));
        
        pos3 = PVector.add(pos1, PVector.mult(vel2, dt/2));
        vel3 = PVector.add(vel1, PVector.mult(a, dt/2));
        
        pos4 = PVector.add(pos1, PVector.mult(vel3, dt/2));
        vel4 = PVector.add(vel1, PVector.mult(a, dt/2));
        
        velTot = PVector.add(vel1, PVector.add(PVector.mult(vel2, 2.0), PVector.add(PVector.mult(vel3, 2.0), vel4)));
        
        pos = PVector.add(pos1, PVector.mult(velTot, dt/6));       
        
        vel = PVector.add(vel1, PVector.mult(a, dt));      
        
        break;
    }
  }
  void display(){
    switch (mode)
    {
      case ANALIT:
        //dibuja
        fill(119, 119, 119, 100);
        ellipse(pos.x, pos.y, 10, 10);
      break;
      
      case EU:
        fill(190, 24, 24, 100);
        ellipse(pos.x, pos.y, 10, 10);
        break;
        
      case EUSEMIM:
        fill(139, 18, 176, 100);
        ellipse(pos.x, pos.y, 10, 10);
        break;      
        
      case HEUN:
        fill(245, 226, 16, 100);
        ellipse(pos.x, pos.y, 10, 10);
      break;
      
      case RK4:
        fill(11, 216, 69, 255);
        ellipse(pos.x, pos.y, 5, 5);
      break;
    }    
    
  }
  
  void run(){
     display();
     update();
  }
}