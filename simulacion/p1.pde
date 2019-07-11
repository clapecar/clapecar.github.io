// Práctica 1 de Simulación
// Miguel Lozano
// Curso 13-14

final int EULER = 0;
final int EULER_SEMI = 1;
final int RK2 = 2;
final int HEUN = 3;
final int RK4 = 4;

final int AMORT = 5;
final int NAMORT = 6;

float dt;
String intAct;
int intAct_num;
// Extremos 
Extremo[] vExtr = new Extremo[1];
Extremo[] vFijos = new Extremo[2];
Muelle[] vMuelles = new Muelle[2];

//Archivo para almacenar los datos de la curva a representar
//PrintWriter output;


void setup() {
  size(640, 360);
  textSize(16);
  // Create objects at starting location
  frameRate(120);     
  intAct_num = EULER; //valores iniciales
  intAct = "euler";
  dt = 0.01;
  
  ini();
}

void draw() {
  background(255); 
  fill(0);
  text("Para volver a comenzar, pulse 'espacio'", 20, 20);
  text("Euler: pulse 1", 20, 40);
  text("Euler semi-implícito: pulse 2", 20, 60);  
  text("Integración actual: " + intAct, 20, 80);
  
  text("dt + 0.001: pulse '+' ", 450, 20);
  text("dt - 0.001: pulse '-' ", 450, 40);
  text("dt: " + dt, 450, 60);
  
  line(width/2-30, 45, width/2+30, 45);
  line(width/2-30, 315, width/2+30, 315);
  for(int i = 0; i < 10; i++){
    for (Muelle s : vMuelles)
      s.update();
    for (int j = 0; j < vExtr.length; j++)
      vExtr[j].update(intAct_num); //Aquí se decide entre euler (EULER) o semimplicito (EULER_SEMI)
  }  
  
  for (Muelle s : vMuelles) {
    s.display();    
    //al extremo movil se le habrán aplicado 2 fuerzas, de los 2 muelles
    //de lo que quiero calcular posición es de la masa del medio
  }
 
  for (int i = 0; i < vExtr.length; i++){
    vExtr[i].display();
    vExtr[i].drag(mouseX, mouseY);
  }
  
  
}

void mousePressed() {
  for (Extremo b : vExtr) {
    b.clicked(mouseX, mouseY);
  }
}

void mouseReleased() {
  for (Extremo b : vExtr) {
    b.stopDragging();
  }
}
void keyPressed(){
  /*if(key == 'f' || key == 'F'){
    output.flush();
    output.close();
  }*/
  if(key == '1'){
    intAct = "euler";
    intAct_num = EULER;
    ini();
  } 
  if(key == '2'){
    intAct = "euler semi";
    intAct_num = EULER_SEMI;
    ini();
  }  
  
  if(key == '+'){
    dt += 0.001;
    ini();
  }  
  if(key == '-'){
    if(dt > 0.0019999999)
      dt -= 0.001;
    ini();
  } 
  if(key == ' '){
    dt = 0.01;
    intAct_num = EULER; //valores iniciales
    intAct = "euler";  
    ini();
  } 
}  
  
void ini(){
  //extremo común (en situación de reposo)
     //Para cambiar entre amortiguamiento y no amortiguamiento, el último parámetro debe ser
     //AMORT o NAMORT
     vExtr[0] = new Extremo(width*0.5, 0.5*height, NAMORT); 
       
    //fijo A    
     vFijos[0] =  new Extremo(width*0.5, 1.0/8.0 * height, NAMORT);
     
    //fijo B
     vFijos[1] =  new Extremo(width*0.5, 7.0/8.0 * height, NAMORT);
    
    
    //muelle Arriba
    vMuelles[0] = new Muelle(vFijos[0], vExtr[0], (0.5)*height-(1.0/8.0)*height);
    
    //muelle Abajo
    vMuelles[1] = new Muelle(vExtr[0], vFijos[1], (7.0/8.0)*height-(0.5)*height);
    
    //Creacion del fichero
    //output = createWriter("EulerS1.txt");

}





class Extremo { 
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass = 10.0;
  PVector gravity;
  PVector forceTot;
  // Arbitrary damping to simulate friction / drag 
  float damping = 0.5;

  // For mouse interaction
  PVector dragOffset;
  PVector amortiguamiento;
  boolean dragging = false;
  int amort;

  // Constructor
  Extremo(float x, float y, int amort_) {
    location = new PVector(x,y);
    velocity = new PVector(100, 0);
    amort = amort_;
    acceleration = new PVector(0, 0);
    gravity = new PVector(0, 9.8);    
    forceTot = new PVector(0, 0);    
    dragOffset = new PVector();
    amortiguamiento = new PVector(0.999, 0.999);
  } 
  
  //integration
  void update(int mode) { 
       
    //Considerar fuerza de amortiguamiento también
   
    if(!dragging){
      //Newton -> F = m * acc
      acceleration.x = forceTot.x / mass;
      acceleration.x += gravity.x; //se suma la acceleración de la gravedad
      acceleration.y = forceTot.y / mass;
      acceleration.y += gravity.y;
      
      switch(mode) {
        case EULER:
          location.x += velocity.x * dt;
          location.y += velocity.y * dt;
          
          velocity.x += acceleration.x * dt;
          velocity.y += acceleration.y * dt;         
          break;
          
        case EULER_SEMI:                  
          velocity.x += acceleration.x * dt;
          velocity.y += acceleration.y * dt;
         
          location.x += velocity.x * dt;
          location.y += velocity.y * dt;
          break;        
      }
      if(amort == AMORT){
         velocity.x = velocity.x * amortiguamiento.x;
         velocity.y = velocity.y * amortiguamiento.y;
      }
    }
    else{
      velocity.x = 0;
      velocity.y = 0;
      acceleration.x = 0;
      acceleration.y = 0;
    }
   //NO Vas a conservar la aceleración de un paso de simulación al siguiente
   //resetear a fueza 0
   forceTot.x = 0;
   forceTot.y = 0;
  }

  // Newton's law: F = M * A
  void applyForce(PVector force) {
   
   //Dado el vector fuerza, conseguir la aceleraci�n y aplicarla al extremo
   forceTot.x += force.x;
   forceTot.y += force.y;      
  }


  // Dibujo el extremo como un circulo de radio proporcional a su peso
  void display() { 
    stroke(0);
    strokeWeight(2);
    fill(175,120);
    if (dragging) {
      fill(50);
    }
    ellipse(location.x,location.y,mass*2,mass*2);
   
    //Aquí se escriben los datos en el fichero
   // output.println(dist(0.5*width, 0.5*height, location.x,location.y)); //PVector.sum() .amp
   // println(dist(0.5*width, 0.5*height, location.x,location.y));
  } 

  // The methods below are for mouse interaction

  // This checks to see if we clicked on the mover
  void clicked(int mx, int my) {
    float d = dist(mx,my,location.x,location.y);
    if (d < mass) {
      dragging = true;
      dragOffset.x = location.x-mx;
      dragOffset.y = location.y-my;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(int mx, int my) {
    if (dragging) {
      location.x = mx + dragOffset.x;
      location.y = my + dragOffset.y;
    }
  }
}




class Muelle { 

 
  // Constantes de configuraci�n del muelle
  float len, lrep, fk;
  float k = 15.0, kd = 0.9;
  PVector vfkA, vfkB, vlen, vLenNorm;
//Extremos del muelle
  Extremo a;
  Extremo b;

  // Constructor
  Muelle(Extremo a_, Extremo b_, float l) {
    a = a_;
    b = b_;
    len = l;
    lrep = l;    
    vfkA = new PVector();
    vfkB = new PVector();
    vlen = new PVector();
    vLenNorm = new PVector();
  } 

  // Calculate spring force
  void update() {
    
    //dependiendo de la k y la long, calculara las fuerzas y las aplicará a cada extremo
     
    //distancia entre ambos extremos = long del muelle actual
    len = dist(b.location.x, b.location.y, a.location.x, a.location.y);
    
    //aplicar la fuerza del muelle de acuerdo con la ley de Hook.    
    fk = k * (len - lrep);  
   
    //vlen = vector de distancia entre ambos extremo (Cambia segun si es para extremo A o B
    vlen.x = (b.location.x - a.location.x);
    vlen.y = (b.location.y - a.location.y);
    vLenNorm = vlen;
    vLenNorm.normalize();
      
    //cojo el vector que va de un extremo a otro y lo multiplico por la fuerza
    //así se obtiene la fuerza como vector
    //fuerza del extremo de arriba A
    vfkA.x =  vLenNorm.x * fk;
    vfkA.y =  vLenNorm.y * fk;
    
    
    //fuerza del extremo de abajo B (inversa al de arriba)
    vfkB.x =  -vLenNorm.x * fk;
    vfkB.y =  -vLenNorm.y * fk;
    
    
    //Aplico las fuerzas a cada extremo
    a.applyForce(vfkA);
    b.applyForce(vfkB);

  }

//dibuja una linea recta que representa al muelle
  void display() {
    strokeWeight(2);
    stroke(0);
    line(a.location.x, a.location.y, b.location.x, b.location.y);
    
    //pintar la fuerza: linea(extremoa, extremoa+fuerza)
    /*strokeWeight(1);
    stroke(#ff0000);
    line(a.location.x, a.location.y, a.location.x+vfkA.x, a.location.y+vfkA.y);*/
    
    
  }
}