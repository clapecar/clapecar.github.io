/*Clara Peñalva
 Práctica 2  Fuegos Artificiales*/
ArrayList<Cohete> castillo;
int npart = 0;
float dt = 0.1;
//modulo de la intensidad del viento
float viento;
boolean vientoFlag;
PVector ptoOrigV;
PVector vientoVect;
//PrintWriter output, output2;

void setup(){
  size(720,480);
//el castillo es un array de cohetes
  castillo = new ArrayList<Cohete>();
  npart = 0;
  viento = 0;
  ptoOrigV = new PVector();
  vientoVect = new PVector();
  vientoFlag = false;
  //Creacion del fichero
  //output = createWriter("NumParticulas.txt");
  //output2 = createWriter("FrameRate.txt");
  
  textSize(20); 
}


void draw(){
  background(0);
  //actualiza cada castillo
  for(int i = 0; i < castillo.size(); i++){
    Cohete c = castillo.get(i);
    c.run();
  }
  
  //Velocidad del viento
  if(vientoFlag){
	  ptoOrigV.x = width/2; 
	  ptoOrigV.y = height/2; 
	  vientoVect.x = mouseX - ptoOrigV.x;
	  vientoVect.y = mouseY - ptoOrigV.y;
	  vientoVect.normalize();
	  vientoVect.mult(5);
	  viento = vientoVect.x;  
  }  
//escribe en la pantalla el numero de particulas actuales --> TAMBIEN SE DEBE ESCRIBIR EN FICHERO
  
  fill(255);
  text("Frame-Rate: " + frameRate, 25, 25);
  text("Número de partículas: " + npart, 25, 45);
  if(vientoFlag){
	text("Viento: ", 25, 65);
	stroke(255);
	  strokeWeight(2);
	  line(200, 60, 200+mouseX - ptoOrigV.x, 60);
	  ellipse(200+mouseX - ptoOrigV.x, 60, 4, 4);
	  }
  else
	text("Viento desactivado, pulse 'v' para activar", 25, 65);
  
  
  //output.println(npart); 
  //output2.println(frameRate);   
 //--->lo mismo se puede indicar para el viento
 
}

//Podeis usar esta funcion para controlar el lanzamiento delcastillo
//cada vez que se pulse el ratón se lanza otro cohete
//puede haber simultaneamente varios cohetes  (castillo = vector de cohetes )
void mousePressed(){
  PVector pos = new PVector(mouseX, mouseY);

  //--->definir un color.Puede ser aleatorio usando random()
  float r = random(0, 255);
  float g = random(0, 255);
  float b = random(0, 255);
  color miColor = color(r,g,b);

  //--->definir el tipo de cohete (circular, cono,eliptico,....)
  int tipo = int(random(0, 6));
  
  Cohete c = new Cohete (pos, tipo, miColor);
  castillo.add(c);
}

void keyPressed(){
	  //cambio de estado de viento
	  if(key == 'v' || key == 'V'){
		vientoFlag = !vientoFlag;
	  }
	}




class Cohete {
//el cohete tiene dos tipos de particulas: la carcasa (una sola) y elsistema de particulas (vector) que forman los puntos de luz
  Particle carcasa;
  ArrayList<Particle> particles;

  //lugar de donde sale la particula
  PVector origin, dest;

  //el tipo sirve para controlar desde la clase castillo,el tipo de artefacto pirotecnico que se va a simular
  //podeis implementar diferentes explosiones:circulares, en cono hacia arriba, en cono hacia abajo, elipticas ...
  int tipo;

  color colorParticulas;

  //esta bandera sirve para indicar cuando se debe explotar la carcasa y pasar de una particula a un sistema de particulas
  boolean explotar;

  Cohete(PVector location, int type, color c) {
    dest = location.get();
    origin = new PVector(dest.x, height-3);
    //array de particulas luminosas.Aun NO SE CREAN las particulas concretas
    particles = new ArrayList<Particle>();
    tipo = type;
    colorParticulas = c;
    explotar = true;
    
   //Este metodo crea la particula carcasa
    crearCarcasa(origin, dest, c);
  }
  
  void crearCarcasa(PVector orig, PVector dest, color c){
   
    //la velocidad depende de origen y destino
    PVector vel = new PVector(0.0, -90.0);
 
    color col = c;
    String tipo = "carcasa";
    
    float distancia = dist(orig.x, orig.y, dest.x, dest.y);
    //--->tambien el retardo de la explosion depende de la distancia entre orig y destino
    int timeLive = int(distancia / -vel.y)*24;
    carcasa = new Particle(orig, vel, timeLive, tipo, col);

  }

  //el argumento pos del siguiente metodo es la posicion donde explota la carcasa
  //este metodo se llama en run()

  void addParticles(PVector pos) {
    PVector velocidad = new PVector(0, 0);
    float ang = 0;
    int time2liveParticulas = int(random(50,150));
    float rad;
    boolean ok = true;
    switch (tipo){
        //--->COHETE CIRCULAR
        case 0:
          rad = random(5, 50);
          for (int i=0; i<360; i++){        
            //--->preparar una velocidad con una nueva direccion
             velocidad.x = sin(ang)*rad + random(2);
             velocidad.y = cos(ang)*rad + random(2);
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p);            
            ang += 2 * PI / 360;
          }
          break;
        
        //--->COHETE EXPLOSIÓN
        case 1:
          for (int i=0; i<360; i++){     
            rad = random(5, 50);
            //--->preparar una velocidad con una nueva direccion
             velocidad.x = sin(ang)*rad + random(2);
             velocidad.y = cos(ang)*rad + random(2);
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p);            
            ang += 2 * PI / 360;
          }
          break;
        //--->COHETE CAZA IMPERIAL
        case 2:
          ang = 0;
          for (int i=0; i < 360; i++){ 
            //--->preparar una velocidad con una nueva direccion
            if(ok){
              velocidad.x = random(50);
              velocidad.y = random(50);
              ok = false;
            }
            else{
              velocidad.x = - random(50);
              velocidad.y = - random(50);
              ok = true;
            }
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p);
            
            //una pequeña explosión para simular el centro
            rad = random(5, 20);
            velocidad.x = sin(ang)*rad + random(2);
            velocidad.y = cos(ang)*rad + random(2);
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p2 = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p2);            
            ang += 2 * PI / 360;
          }            
          break;
          
        //--->COHETE CRUZ DE ELIPSES
        case 3:
          for (int i=0; i<360; i++){     
              rad = random(5, 50);
              //--->preparar una velocidad con una nueva direccion
               velocidad.x = sin(ang)*rad + random(2);
               velocidad.y = cos(ang)*5 + random(2);
              //--->anyadimos la particula creada
              //Particle(PVector l, PVector v, int time2live, String type, color c) 
              Particle p = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
              particles.add(p);  
              
              velocidad.x = sin(ang)*5 + random(2);
              velocidad.y = cos(ang)*rad + random(2);
              //--->anyadimos la particula creada
              //Particle(PVector l, PVector v, int time2live, String type, color c) 
              Particle p2 = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
              particles.add(p2); 
              
              ang += 2 * PI / 360;
          }
          break;
          //--->COHETE CRUZ DE ELIPSES
        case 4:
          rad = random(20, 70);
          ang = PI; //90 grados
          for (int i=0; i<400; i++){        
            //--->preparar una velocidad con una nueva direccion
             velocidad.x = sin(ang)*rad + random(2);
             velocidad.y = cos(ang)*rad + random(2);
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p);  
            
            //--->preparar una velocidad con una nueva direccion
             velocidad.x = sin(ang)*10 + random(2);
             velocidad.y = cos(ang)*rad + random(2);
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p2 = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p2);  
            
            if(ang >= (TWO_PI))//mitad
              ang = PI; //se reinicia
            else
              ang += 2 * PI / 360; //se aumenta en 1 ángulo
            
          }
          break;
          //--->COHETE ELIPSE
        case 5:        
          rad = random(5, 50);
          for (int i=0; i<700; i++){        
            //--->preparar una velocidad con una nueva direccion
             velocidad.x = sin(ang)*rad + random(2);
             velocidad.y = cos(ang)*rad + random(2);
            //--->anyadimos la particula creada
            //Particle(PVector l, PVector v, int time2live, String type, color c) 
            Particle p = new Particle (pos, velocidad, time2liveParticulas, "particula", colorParticulas);
            particles.add(p);              
            rad = rad + 0.5;
            ang += 2 * PI / 360;           
          }
          break;
    }
  }

//Funcion de control del cohete que no deberiais tocar
  void run() {    
    if (!carcasa.isDead()){ 
      //Simulacion carcasa
      carcasa.run();
    }
    else if(carcasa.isDead() && explotar){
     //Frame de preparacion de las particulas para la  explosion
      npart--;
      explotar = false;

      //aqui se reservan los objetos particula
      addParticles(carcasa.getLocation());
    }
    else{
      //Simulacion de la palmera pirot�cnica (sistema de particulas)
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.run();
        if (p.isDead()) {
          npart--;
          //Si la particula ha agotado su existencia,se elimina del vector usando el metodo remove() de la clase ArrayList
          particles.remove(i);
        }
      }
    }
   }
}




class Particle {
  PVector F;
  PVector acceleration;
  PVector velocity;
  PVector location;
  
  float masa;
  float lifespan;
  int ttl;
  boolean anyadida;

  //Hay dos tipos de particula identificada por una etiqueta
  //El tipo "carcasa" es una particula de gran tama�o que simular� en su ascensi�n la carcasa
  //El tipo "particula" que representa un punto de color cuando la carcasa haya explotado
  String tipo;

  color Color;

  Particle(PVector l, PVector v, int time2live, String type, color c) {
    F = new PVector(0,0);
    acceleration = new PVector(0,9.8);
    velocity = v.get();
    location = l.get();
    
    masa = 1;
   
    ttl = time2live;
    anyadida = false;
    tipo = type;
    Color = c;
  }


  void run() {
    //---> Solo la primera vez que se ejecute run(), se aumenta npart
   //para ello usar el atributo 'anyadida '  que se pondra a true la primera vez,cuando se cuenta la particula
   if(!anyadida){
     npart++;
     anyadida = true;
   } 
    
    update();
    display();
  }

  // Method to update location
  void update() {
    actualizaFuerza();
    
    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration.x = F.x / masa;
    acceleration.y = F.y / masa;
    
    //--->utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.x += acceleration.x * dt;
    velocity.y += acceleration.y * dt;
     
    location.x += velocity.x * dt;
    location.y += velocity.y * dt;

    ttl--;  //descuenta el tiempo de vida de la particula
  }
  
  void actualizaFuerza(){
     
   //--->la fuerza tiene dos componentes. En uno, siempre  actua la gravedad
   if(vientoFlag)
	 F.x = vientoVect.x;
   F.y = 9.8 * masa;
  //la fuerza del viento se puede acoplara la otra componente de la fuerza de la particula (o incluso a las dos)

  }
  
  PVector getLocation(){
    return location;
  }

  // Method to display
  void display() {
    if (tipo == "particula"){
       stroke(Color,ttl);
       fill(Color,ttl);
       ellipse(location.x,location.y,2,2);
    }
    else{
      stroke(255);
      fill(255);
      ellipse(location.x,location.y,5,5);
    }
    
  }
  
  // Sirve para eliminar de la clase cohete a dicha particula
  boolean isDead() {
    if (ttl < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}