/*Clara Peñalva
Práctica 3 - colisión partícula-plano, partícula-partícula
*/
 
//variables
ParticleSystem partic;
PVector loc;
Plane planeA, planeB, planeC;
PVector A, B, C, D;
PVector vecBA;
int radio;
float dt;
int npart, numPartIni;
int m, antesComp, despComp, antesDraw, despDraw;
int tipoColision;
String tipoCol;
//Archivo para almacenar los datos de la curva a representar
//PrintWriter output, output2, output3, output4;

void setup(){  
  size(600,500);
  smooth();
  textSize(15);
  ini();
}
 
void draw(){
  m = millis();
  background(#000000);
  //dibujo mar
  stroke(#ffffff);
  planeA.display();
  planeB.display();
  planeC.display();
  fill(255);
  text("Partículas: " + npart , 15, height-170);
  text("FrameRate: " + frameRate , 15, height-150);
  
  //output.println(npart);
  //output2.println(frameRate);
  
  antesComp = millis();
  partic.update(); //corrigo las partículas de pos
  partic.collision(tipoColision); //calculo las colisiones
  despComp = millis()-antesComp;
   
  partic.particFuera();
  
  antesDraw = millis();
  partic.display();
  despDraw = millis()-antesDraw; 
  
  fill(255);
  text("Tipo de colisión: " + tipoCol, 15, height-90);
  text("T. dibujado: " + despDraw,  15, height-130);
  text("T. cómputo: " + despComp,  15, height-110);
  
  text("Leyenda botones:", 300, height-170);
  text("Ratón: añade 10 partículas aleatorias", 320, height-150);
  text("Espacio: añade 1000 partículas", 320, height-130);
  text("'N': volver a empezar", 320, height-110);
  text("'1': tipo colisión velocidades", 320, height-90);
  text("'2': tipo colisión muelles", 320, height-70);
  
  //output3.println(despComp);
  //output4.println(despDraw);
}

//se anyade un bloque de partículas
void keyPressed(){
  if(key == ' '){
    int y = 0;
    int cont = 0;
    float x = 70;
    int maxFila = (width-140)/(radio*2+1)+1;  
    
    for(int i = 0; i < numPartIni; i++){
      //definir un color
      float r = random(0, 255);
      float g = random(0, 255);
      float b = random(0, 255);
      color miColor = color(r,g,b);
      partic.addParticle(new PVector(x, y), miColor, radio);
      cont += 1;
      x += radio*2+1; 
      if(cont == maxFila){
         cont = 0;
         y += radio*2+1;
         x = 70;
      }
    }
  }
  if(key == 'n' ||key == 'N'){
    partic.removeParticles();
    ini();
  }  
  if(key == '1'){
    tipoColision = 1;
    tipoCol = "basada en velocidades";
  }  
  if(key == '2'){
    tipoColision = 2;
    tipoCol = "basada en muelles";
  }
  
  
  /*if(key == 'f' || key == 'F'){
    output.flush();
    output.close();
    output2.flush();
    output2.close();
    output3.flush();
    output3.close();
    output4.flush();
    output4.close();
  }*/
} 

//se anyaden 10 partículas aleatorias  
void mousePressed(){  
   for(int i = 0; i < 10; i++){
        //definir un color
        float r = random(0, 255);
        float g = random(0, 255);
        float b = random(0, 255);
        color miColor = color(r,g,b);
        partic.addParticle(new PVector(random(70, width-70), random(0, 150)), miColor, radio);
    }
}
 void ini(){
    /*DATOS MODIFICABLES*/ 
  dt = 0.05; //diferencial de tiempo
  radio = 5; //radio de las bolas
  numPartIni = 1000; //número de partículas nuevas al presionar 'espacio'
  tipoColision = 2; //tipo de colisión entre partículas
                    //1 = velocidades, 2 = muelles
  tipoCol = "basada en muelles";

  partic = new ParticleSystem();
  npart = 0;
  
 /* A     D
      \_/
     B   C
 */
  //cálculo de los puntos 
  B = new PVector(100, height-200);
  C = new PVector( width-100, height-200);
  A = new PVector(0, 100);
  D = new PVector( width, 100);
  
  //inserción de planos
  planeA = new Plane(A, B);
  planeB = new Plane(B, C);
  planeC = new Plane(C, D);
  
  //Creacion del fichero
  /*output = createWriter("Particulas2.txt");
  output2 = createWriter("FrameRate2.txt");
  output3 = createWriter("TComputo2.txt");
  output4 = createWriter("TDibujado2.txt");*/
  }
  
  
  
  
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float radio;
  int id;
  float m;
  color clr;
  
  Particle(PVector l, int id_, color clr_, float radio_) {
    radio = radio_;
    acceleration = new PVector(0,9.8);//se toma que la fuerza de la gravedad ya está aplicada
    velocity = new PVector(0,0); //marca la forma del emisor
    location = l.get();
    id = id_;
    clr = clr_;
    m = 30; //al estar actuando solo la gravedad, no afecta
  }

  void collision(int tipo) {
    collisionPlane(planeA);
    collisionPlane(planeB);
    collisionPlane(planeC);
    if(tipo == 1)
      collisionParticle1();
    else
      collisionParticle2();
  }

  // Method to update location
  void update() { //integrador    
    velocity.x += acceleration.x * dt;
    velocity.y += acceleration.y * dt;
    location.x += velocity.x * dt;
    location.y += velocity.y * dt;   
  }
  
  // Method to display
  void display() {
    fill(clr);
    stroke(clr);
    ellipse(location.x,location.y,radio*2,radio*2);
  }
  
  // Method to make calculs with planes
  void collisionPlane(Plane plane){    
    float dcol;
    float d;   
    dcol = PVector.sub(location, plane.p1).dot(plane.normal);

    d = dcol - radio;
    
    if(dcol < radio)
    {        
      float Kr = 0.85;//constante       
      PVector desBall = PVector.mult(plane.normal, d*(1+Kr));
      location = PVector.sub(location, desBall);
      
      float nv = plane.normal.dot(velocity);      
      PVector vn = PVector.mult(plane.normal, nv);
      PVector vt = PVector.sub(velocity, vn);        
      velocity = PVector.sub(vt, PVector.mult(vn, Kr));     
    }

  } 
  
  //colsión partícula-partícula velocidades
  void collisionParticle1(){    
   for (int i = 0; i < npart;i++){
   
     if(i != id) // si no es ella misma
     {
        PVector p1 = PVector.add(location, new PVector(radio, radio));
        Particle ball2 = partic.particles.get(i);
        PVector p2 = PVector.add(ball2.location, new PVector(ball2.radio, ball2.radio));
        PVector dist = PVector.sub(p2, p1);
        
        //si están "una dentro de la otra"
        if(abs(dist.mag()) < radio+ball2.radio && dist.mag() != 0){
          PVector distNorm = new PVector();
          distNorm.set(dist);
          distNorm.normalize();
          //Velocidades normal/tangencial          
          PVector normal1 = PVector.mult(distNorm,this.velocity.dot(dist)/dist.mag());
          PVector normal2 = PVector.mult(distNorm,ball2.velocity.dot(dist)/dist.mag());
          
          PVector tang1 = PVector.sub(this.velocity, normal1);
          PVector tang2 = PVector.sub(ball2.velocity, normal2);
          
          // Restitución
          float L = radio+ball2.radio - dist.mag();
          float vrel = PVector.sub(normal1, normal2).mag();          
          this.location = PVector.add(this.location,PVector.mult(normal1, -L/vrel));
          ball2.location = PVector.add(ball2.location,PVector.mult(normal2,-L/vrel));
          
          //Vel de salida
          float u1 = PVector.dot(normal1, distNorm)/dist.mag();
          float u2 = PVector.dot(normal2, distNorm)/dist.mag();
          float m2 = ball2.m;
          float v1 = (((m - m2) * u1)+(2 * m2 * u2))/(m + m2);
          float v2 = (((m2 - m) * u2)+(2 * m * u1))/(m + m2);
          normal1 = PVector.mult(distNorm, v1);
          normal2 = PVector.mult(distNorm, v2);
          this.velocity.set(PVector.add(normal1, tang1));
          ball2.velocity.set(PVector.add(normal2, tang2));
        }
      }
    }  
  }
  
  void particFuera(){
    if(location.x < 0){
      location.x = 0;  
    }
    else if(location.x > width){
      location.x = width-1;
    }
    if(location.y < 0){
      location.y = 0;
    }
  } 
  
  //colsión partícula-partícula muelles
  void collisionParticle2(){
    for (int i = 0; i < npart;i++){
      Particle ball2 = partic.particles.get(i);
      float dx = ball2.location.x - this.location.x;
      float dy = ball2.location.y - this.location.y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = ball2.radio + radio;
      
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = this.location.x + cos(angle) * minDist;
        float targetY = this.location.y + sin(angle) * minDist;
        float ax = (targetX - ball2.location.x) * 0.9;
        float ay = (targetY - ball2.location.y) * 0.9; //k
        this.velocity.x -= ax;
        this.velocity.y -= ay;
        ball2.velocity.x += ax;
        ball2.velocity.y += ay;
        float n = 0.998;
        this.velocity = PVector.mult(velocity, n); //amortiguamiento
        ball2.velocity = PVector.mult(ball2.velocity, n);       
      }
    }  
  }  
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void addParticle(PVector location, color miColor, float radio) {    
    particles.add(new Particle(location, npart, miColor, radio));
    npart++;
  }

  void update() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update(); 
    }
  }
  
  void collision(int tipo) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.collision(tipo); 
    }
  }
  
  void particFuera(){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.particFuera(); 
    }
  }
  
  void display(){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display(); 
    }  
  }
  
  void removeParticles() {
    for (int i = particles.size()-1; i >= 0; i--) {
        particles.remove(0);
        
    }
  }
}






class Plane{
  PVector p1, p2;
  PVector normal, dir;
   
  Plane(PVector p1_, PVector p2_){
    p1 = p1_;
    p2 = p2_;
    float a = p2.x - p1.x;
    float b = p2.y - p1.y;
    normal = new PVector(b, -a);
    normal.normalize();
  }
  
  void display(){
    stroke(255);
    line(p1.x, p1.y, p2.x, p2.y);  
  }   
  
}