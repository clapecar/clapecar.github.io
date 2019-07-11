/*Clara Peñalva
Práctica 3 - tabla Hash
*/

//variables
ParticleSystem partic;
Hash tabla;
PVector loc;
Plane planeA, planeB, planeC;
PVector A, B, C, D;
PVector vecBA;
int radio;
float dt;
int npart, numPartIni;
int m, antesComp, despComp, antesDraw, despDraw;
int tipoColision;
int cellSize;

//Archivo para almacenar los datos de la curva a representar
//PrintWriter output, output2, output3, output4;

void setup(){  
  size(600,450);
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
  text("Partículas: " + npart , 15, height-110);
  text("FrameRate: " + frameRate , 15, height-90);
  
  //output.println(npart);
  //output2.println(frameRate);
  
  antesComp = millis();
  partic.update(); //corrigo las partículas de pos
  partic.particFuera();
  tabla.updateHash(partic); //actualizo  el grid
  tabla.collisionHash(); //se calculan las colisiones
  despComp = millis()-antesComp;
     
  antesDraw = millis();
  partic.display();
  despDraw = millis()-antesDraw; 
  
  fill(255);
  text("T. dibujado: " + despDraw,  15, height-70);
  text("T. cómputo: " + despComp,  15, height-50);
  
  text("Leyenda botones:", width-350, height-110);
  text("Ratón: añade 10 partículas aleatorias", width-300, height-90);
  text("Espacio: añade 1000 partículas", width-300, height-70);
  text("'N': volver a empezar", width-300, height-50); 
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
  cellSize = 10; //tamaño de las celdas
  radio = 5; //radio de las bolas
  numPartIni = 1000; //número de partículas nuevas al presionar 'espacio'  
  
  npart = 0;
  partic = new ParticleSystem();
  tabla = new Hash(cellSize, npart);
  
 /* A     D
      \_/
     B   C
 */
  //cálculo de los puntos 
  B = new PVector(100, height-150);
  C = new PVector( width-100, height-150);
  A = new PVector(0, 100);
  D = new PVector( width, 100);
  
  //inserción de planos
  planeA = new Plane(A, B);
  planeB = new Plane(B, C);
  planeC = new Plane(C, D);
  
  //Creacion del fichero
  /*output = createWriter("ParticulasH.txt");
  output2 = createWriter("FrameRateH.txt");
  output3 = createWriter("TComputoH.txt");
  output4 = createWriter("TDibujadoH.txt");*/
}





class Hash {
  ArrayList<ArrayList<Particle>> tabla;
  int cellSize;
  int tamHash;
  ArrayList<Particle> ballCalculoColl;   
  
  Hash(int cs_, int npart_) {
    cellSize = cs_;
    tamHash = 5000;
    tabla = new ArrayList<ArrayList<Particle>>();
    ballCalculoColl = new ArrayList<Particle>();
     
    //se crea el array de arrays de bolas
    for (int i=0; i < tamHash; i++) {
      tabla.add(new ArrayList<Particle>());
    }
  }
  
  void updateHash(ParticleSystem partic) //actualizo  la tabla hash insertando cada particula
  {
    for(int i = 0; i < tabla.size(); i++)
      tabla.get(i).clear();
      
    //se añade en cada posición de la tabla las partículas que tocan
    for (int i = partic.particles.size()-1; i >= 0; i--) {
        Particle p = partic.particles.get(i);
        int h = hash(p.location);    
        tabla.get(h).add(p); //h debe estar entre 0 y tamaño de hash/2
     }     
  }
  
  void collisionHash() //se calculan las colisiones
  {
     ballCalculoColl.clear(); //se limpia por si tiene algo
     for (int i=0; i < partic.particles.size(); i++) { 
       Particle p = partic.particles.get(i);
       ArrayList<Particle> listaVecinos = calculaVecinos(p.location); //se calculan sus vecinos
       p.collision(listaVecinos); //se calculan las colisiones entre ellas
     }
  }
  
  
  
   
  int hash(PVector posicion) {
    int xd = (int)floor(posicion.x/cellSize);
    int yd = (int)floor(posicion.y/cellSize);
     
    int h = (73856093 * xd + 19349663 * yd) % (npart*2);
     
    if (h < 0) {
      h += 5000;
    }
    return h;
  }
      
  ArrayList calculaVecinos(PVector loc) {
     ArrayList<Particle> listaVec = new ArrayList<Particle>();
     float angle;
     PVector locVecino = new PVector(0, 0);
      
     int celda = hash(loc);
     listaVec.addAll(tabla.get(celda));
      
     for (int i = 0; i < 8; i++) {
       angle = QUARTER_PI * i;
       locVecino.x = loc.x + cellSize * cos(angle);
       locVecino.y = loc.y + cellSize * sin(angle);
       celda = hash(locVecino);        
       listaVec.addAll(tabla.get(celda));
     }
     return listaVec;
  }
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

  void collision(ArrayList<Particle> ballCalculoColl) {
    collisionPlane(planeA);
    collisionPlane(planeB);
    collisionPlane(planeC);
    collisionParticle2(ballCalculoColl);
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
  void collisionParticle2(ArrayList<Particle> ballCalculoColl){
    for (int i = 0; i < ballCalculoColl.size();i++){
      Particle ball2 = ballCalculoColl.get(i);
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
        
        this.velocity = PVector.mult(this.velocity, 0.998); //amortiguamiento
        ball2.velocity = PVector.mult(ball2.velocity, 0.998);       
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