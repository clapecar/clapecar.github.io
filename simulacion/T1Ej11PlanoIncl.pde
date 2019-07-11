/*Clara Peñalva
Tema 1 - Ejercicio 11: Simular plano inclinado.*/
 
final int ROZ = 0;
final int NROZ = 1;
//variables
Caja cR, cNR; 
float ang, rad, k;
void setup(){
  
  size(650,650);
  smooth();
  ini(30,0.5);
  textSize(20);
}
 
void draw(){
  background(#ffffff);
  stroke(#000000);
  
  fill(#000000);
  text ("Volver a comenzar: 'espacio'.", 40, 40);
  text ("Pausar simulación: ratón", 40, 60);
  text ("Aumentar inclinación: '+'.", 370, 90);
  text ("Disminuir inclinación: '-'.", 370, 110);
  text ("Aumentar rozamiento: 'flecha arriba'.", 40, 90);
  text ("Disminuir rozamiento: 'flecha abajo'.", 40, 110);
  fill(#ff0000);
  text ("Pelota con rozamiento", 350, 40);
  fill(#045FB4);
  text ("Pelota sin rozamiento", 350, 60);
  
  fill(#000000);
  text ("Valor coeficiente de rozamiento 'k': " + k, 300, 140);
  text ("Valor ángulo inclinación: " + ang, 300, 160);
  
  //para la caída
  if(cNR.pos.x >= width-50 ||  cNR.pos.y >= height-50){
    noLoop();
  }
  
  //superficie sobre la que cae
  line(cR.orig.x-rad, cR.orig.y,cR.orig.x-rad + width*cos(radians(ang)), cR.orig.y + height*sin(radians(ang)));
  line(cR.orig.x-rad, cR.orig.y, cR.orig.x-rad,  cR.orig.y + height*sin(radians(ang)));
  line(cR.orig.x-rad, cR.orig.y + height*sin(radians(ang)), cR.orig.x-rad + width*cos(radians(ang)), cR.orig.y + height*sin(radians(ang)));
  
  stroke(#000000);
  strokeWeight(1);
  cNR.go();
  cR.go();
}

void ini(float angle, float k_){
  ang = angle;
  rad = 30;
  k = k_;
         //Caja(ang, rad, modo, K, masa)
  cNR = new Caja(angle, rad, NROZ, 0.0, 100.0);
  cR = new Caja(angle, rad, ROZ, k, 100.0);
}

void keyPressed(){
   if(key == '+')
     if(ang < 90){
       ang+=5;
       ini(ang,k);
       loop();
     }
   if(key == '-')
     if(ang > 0){
       ang-=5;
       loop();
       ini(ang,k);
      }
   if(key == ' '){
     ini(ang,k);
     loop();
   }
   if(keyCode == UP){
     k +=0.1;
     loop();
     ini(ang,k);
   }
   if(keyCode == DOWN){
     if(k > 0){
        k -=0.1;
        loop();
        ini(ang,k);
     }
   }
}

void mousePressed() {
  noLoop();
}

void mouseReleased() {
  loop();
}

class Caja {
  PVector orig, pos;
  float rad; 
  float k;
  float theta, res, m;
  PVector acc, vel, F;
  int mode;
  float t, g, dt;
  
  Caja(float th, float r, int m_, float k_, float mas){
    rad = r;
    mode = m_;
    theta = radians(th);
    k = k_;
    pos = new PVector(50, height/4);
    orig = new PVector(50, height/4);
    m = mas;
    F = new PVector(0, 0);
    vel = new PVector(0,0);
    t = 0.0;
    dt = 0.1;
    g = 9.8;
    acc = new PVector(0,0);   
  }

 void go(){
   update();
   render();
   t += dt;
 }
 
  void update(){
    switch(mode){
      case ROZ:   
        
        res = (m*g*sin(theta)) - (k * vel.mag());
        F.x = res * cos(theta);
        F.y = res * sin(theta);
        break;
    
     case NROZ:   
        
        res = m*g*sin(theta);
        F.x = res * cos(theta);
        F.y = res * sin(theta);
        break;
    }
    acc.x = F.x / m;
    acc.y = F.y / m;
    
    pos.x += vel.x * dt;
    pos.y += vel.y * dt;
    
    vel.x += acc.x * dt;
    vel.y += acc.y * dt;
    
  }
  
  void render(){
    switch(mode){
      case ROZ:
        fill(#ff0000, 150);
        break;
      case NROZ:
        fill(#045FB4, 150);
        break;
    }
  stroke(#000000);
  ellipse(pos.x, pos.y, rad, rad);
  }
}