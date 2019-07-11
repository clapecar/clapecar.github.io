/*Clara Peñalva
Práctica 3 - Grid*/

//variables
ParticleSystem partic;
Grid grid;
PVector loc;
Plane planeA, planeB, planeC;
PVector A, B, C, D;
PVector vecBA;
int radio;
float dt;
int npart, numPartIni;
int m, antesComp, despComp, antesDraw, despDraw;
int gridFilas, gridColum;
float cellSize;
boolean muestraGrid;

//Archivo para almacenar los datos de la curva a representar
//PrintWriter output, output2, output3, output4;

void setup(){ 
  size(600,500);
  smooth();
  textSize(15);
  cellSize = 40; //tamaño de las celdas
  ini();
  
}
 
void draw(){
  m = millis();
  background(#000000);
  
  //dibujo grid
  if(muestraGrid){
    grid.displayGrid();
  }
  
  //dibujo planos
  stroke(#ffffff);
  planeA.display();
  planeB.display();
  planeC.display();
  fill(255);
  text("Partículas: " + npart , 15, height-150);
  text("FrameRate: " + frameRate , 15, height-130);
  
  //output.println(npart);
  //output2.println(frameRate);
  
  antesComp = millis();
  partic.update(); //corrigo las partículas de pos
  partic.particFuera(); //corrigo para que no se salgan del grid
  grid.updateGrid(partic); //actualizo  el grid
  grid.collisionGrid(); //se calculan las colisiones
  despComp = millis()-antesComp;  
  
  antesDraw = millis();
  partic.display();
  despDraw = millis()-antesDraw; 
  
  fill(255);
  
  text("T. dibujado: " + despDraw, 15, height-110);
  text("T. cómputo: " + despComp,  15, height-90);
  text("Tamaño celda: " + cellSize,  15, height-70);
  
  text("Leyenda botones:", width-350, height-150);
  text("Ratón: añade 10 partículas aleatorias", width-300, height-130);
  text("Espacio: añade 1000 partículas", width-300, height-110);
  text("'G': muestra/oculta el grid", width-300, height-90);
  text("'N': volver a empezar", width-300, height-70);
  text("'+': +1 tamaño de celda", width-300, height-50);
  text("'-': -1 tamaño de celda", width-300, height-30);
 // output3.println(despComp);
 // output4.println(despDraw);
}


void keyPressed(){
  //se anyade un bloque de partículas
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
  
  //se muestra el grid
  if(key == 'g' || key == 'G'){
     muestraGrid = !muestraGrid;
  }
  if(key == 'n' ||key == 'N'){
    partic.removeParticles();
    ini();
  } 
  if(key == '+'){
    if(cellSize != width){
       cellSize += 1;
       ini();
    }
  }
  if(key == '-'){
   if(cellSize > 5.0){
      cellSize -= 1;
      ini();
    }
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
    
  
  //cálculo del número de celdas
  muestraGrid = true;
  if(height % cellSize != 0){  
    gridFilas = int(height/cellSize) + 1;
  }else{
    gridFilas = int(height/cellSize);
  }   
  if(width % cellSize != 0){  
    gridColum = int(width/cellSize) + 1;
  }else{
    gridColum = int(width/cellSize);
  }
  
  partic = new ParticleSystem();
  grid = new Grid();
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
 /* output = createWriter("ParticulasG.txt");
  output2 = createWriter("FrameRateG.txt");
  output3 = createWriter("TComputoG.txt");
  output4 = createWriter("TDibujadoG.txt");*/
}





class Grid {
  ArrayList<Particle>[][] grid;
  ArrayList<Particle> ballCalculoColl;
  Grid() {
    grid = new ArrayList[gridFilas][gridColum];
    
    for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++)
        grid[i][j] = new ArrayList<Particle>();
        
    ballCalculoColl = new ArrayList<Particle>();
    //print(gridFilas +" fil");
    //print(gridColum +" col");
  }
  
  void displayGrid(){
    stroke(50);
    for (int i = 0; i < width; i+= cellSize){
      line(i, 0, i, height);
    }
    for (int i = 0; i < height; i+= cellSize){
      line(0,i,width,i);
    }
  }
  
  
  void updateGrid(ParticleSystem partic){
      //se borra
      for(int i = 0; i < gridFilas; i++)
        for(int j = 0; j < gridColum; j++)
          grid[i][j].clear();
      //se van anyadiendo en cada lugar
      for (int i = partic.particles.size()-1; i >= 0; i--) {
        Particle p = partic.particles.get(i);
        int posColumn = int(p.location.x / cellSize);
        int posFila = int(p.location.y / cellSize);
        grid[posFila][posColumn].add(p);
      }     
  }
  
  void collisionGrid(){
    ballCalculoColl.clear(); //se limpia por si tiene algo
    //recorro una a una cada celda
    for(int i = 0; i < gridFilas; i++)
      for(int j = 0; j < gridColum; j++){        
        //añado en esta lista todas las bolas que voy a calcular
        ballCalculoColl.addAll(grid[i][j]);
        if(gridFilas != 1 && gridColum != 1) //si hay más de una fila y columna
        {
          if(i == 0){ //primera fila
            if(j == 0){ //primera fila y columna
              ballCalculoColl.addAll(grid[i+1][j]);
              ballCalculoColl.addAll(grid[i][j+1]);
              ballCalculoColl.addAll(grid[i+1][j+1]);
            }
            else{ 
              if(j == gridColum-1) //primera fila, última columna
              {  
                ballCalculoColl.addAll(grid[i+1][j]);
                ballCalculoColl.addAll(grid[i][j-1]);
                ballCalculoColl.addAll(grid[i+1][j-1]);              
              }
              else //las restantes de la primera fila
              { 
                ballCalculoColl.addAll(grid[i+1][j]);
                ballCalculoColl.addAll(grid[i+1][j-1]);
                ballCalculoColl.addAll(grid[i+1][j+1]);
                ballCalculoColl.addAll(grid[i][j-1]);
                ballCalculoColl.addAll(grid[i][j+1]);
              }
            }
          }
          else{ //1
            if(i == gridFilas-1) //última fila
            {
              if(j==0){//última fila y primera columna
                ballCalculoColl.addAll(grid[i-1][j]);
                ballCalculoColl.addAll(grid[i][j+1]);
                ballCalculoColl.addAll(grid[i-1][j+1]);
              }
              else{
                if(j == gridColum-1){ //última fila y columna
                  ballCalculoColl.addAll(grid[i-1][j]);
                  ballCalculoColl.addAll(grid[i][j-1]);
                  ballCalculoColl.addAll(grid[i-1][j-1]);
                }
                else{//las restantes de la última fila
                  ballCalculoColl.addAll(grid[i-1][j]);
                  ballCalculoColl.addAll(grid[i-1][j-1]);
                  ballCalculoColl.addAll(grid[i-1][j+1]);
                  ballCalculoColl.addAll(grid[i][j-1]);
                  ballCalculoColl.addAll(grid[i][j+1]);              
                }
              }
            }
            else{ //2
              if(j == 0){ //primera columna (sin ser primera o última fila)
                ballCalculoColl.addAll(grid[i-1][j]);
                ballCalculoColl.addAll(grid[i+1][j]);
                ballCalculoColl.addAll(grid[i-1][j+1]);
                ballCalculoColl.addAll(grid[i][j+1]);
                ballCalculoColl.addAll(grid[i+1][j+1]);
              }
              else{ //3
                if(j == gridColum-1){ //última columna (sin ser primera o última fila)
                  ballCalculoColl.addAll(grid[i-1][j]);
                  ballCalculoColl.addAll(grid[i+1][j]);
                  ballCalculoColl.addAll(grid[i-1][j-1]);
                  ballCalculoColl.addAll(grid[i][j-1]);
                  ballCalculoColl.addAll(grid[i+1][j-1]);
                }
                else{ //TODO el resto de celdas que queden por el centro
                  ballCalculoColl.addAll(grid[i-1][j]);
                  ballCalculoColl.addAll(grid[i+1][j]);
                  ballCalculoColl.addAll(grid[i-1][j-1]);
                  ballCalculoColl.addAll(grid[i][j-1]);
                  ballCalculoColl.addAll(grid[i+1][j-1]);
                  ballCalculoColl.addAll(grid[i-1][j+1]);
                  ballCalculoColl.addAll(grid[i][j+1]);
                  ballCalculoColl.addAll(grid[i+1][j+1]);
                }
              } //end 3
            } //end 2
          } //end 1    
        }
        else{ //solo hay 1 fila o columna
          if(gridFilas == 1 && gridColum != 1) //hay 1 fila y más de una columna
          {
            if(j == 0)
              ballCalculoColl.addAll(grid[i][j+1]); 
            else
              ballCalculoColl.addAll(grid[i][j-1]); 
          }
        }
        //comparo cada una de las bolas almacenadas en el nuevo array   
        for (int k = grid[i][j].size()-1; k >= 0; k--) {
          Particle p = grid[i][j].get(k);
          p.collision(ballCalculoColl);    
        }
        
        ballCalculoColl.clear(); //se limpia para la siguiente celda
      } //end for
  } //end collisionGrid()
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
    
    for (int i = 0; i < ballCalculoColl.size(); i++){
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