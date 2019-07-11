// Práctica 1 de Simulación
// Miguel Lozano
// Curso 13-14

final int EULER = 0;
final int EULER_SEMI = 1;
final int RK2 = 2;
final int HEUN = 3;
final int RK4 = 4;
final int REAL = 7;

final int AMORT = 5;
final int NAMORT = 6;

final int NATURAL = 10;
final int INTEGRA = 11;

float dt;
float t;

String intAct;
int intAct_num;

// Extremos 
Extremo[] vExtr = new Extremo[2];
Extremo[] vFijos = new Extremo[2];

Muelle muelle, muelleReal;

//Archivo para almacenar los datos de la curva a representar
//PrintWriter output, output2, output3;


void setup() {
  size(640, 360);
  textSize(17);
  frameRate(500);     
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
  text("Runge Kutta 2: pulse 3", 20, 80);
  text("Runge Kutta 4: pulse 4", 20, 100);
  text("Integración actual: " + intAct, 20, 120);
  text("dt + 0.001: pulse '+' ", 365, 20);
  text("dt - 0.001: pulse '-' ", 365, 40);
  text("dt: " + dt, 365, 60);
  fill(#610B0B);
  text("Muelle rojo: solución analítica", 365, 80);
  
  strokeWeight(2);
  stroke(0);
  line(62, 140, 62, 192);
  line(62, 192, 630, 192);
  line(10, 140, 62, 140);
  
  muelle.update();
  muelle.display();
   
  muelleReal.update();
  muelleReal.display();
  
    //al extremo movil se le habrán aplicado 2 fuerzas, de los 2 muelles
    //de lo que quiero calcular posición es de la masa del medio
 /* for (int i = 0; i < vExtr.length; i++){
    vExtr[i].update(intAct_num); //Aquí se decide entre EULER, EULER_SEMI, RK2 o RK4
    vExtr[i].display();
    vExtr[i].drag(mouseX);
  }*/
  vExtr[0].update(intAct_num); //Aquí se decide entre EULER, EULER_SEMI, RK2 o RK4
  vExtr[0].display();
  vExtr[0].drag(mouseX);
    
  vExtr[1].update(REAL); //Aquí se decide entre EULER, EULER_SEMI, RK2 o RK4
  vExtr[1].display();
  //vExtr[i].drag(mouseX);
  
  t = t + dt;
  
  
}

void mousePressed() {
  for (Extremo b : vExtr) {
    b.clicked(mouseX);
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
    output2.flush();
    output2.close();
    output3.flush();
    output3.close();
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
  if(key == '3'){
    intAct = "RK2";
    intAct_num = RK2;
    ini();
  }  
  if(key == '4'){
    intAct = "RK4";
    intAct_num = RK4;
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
  t = 0;
  // Create objects at starting location
  
     //extremo común (en situación de reposo)
     //Para cambiar entre amortiguamiento y no amortiguamiento, el último parámetro debe ser
     //AMORT o NAMORT
    vExtr[0] = new Extremo(width*0.5, 0.5*height, NAMORT, INTEGRA); 
    vExtr[1] = new Extremo(width*0.5, 0.5*height-20, NAMORT, NATURAL);   
    //fijo A    
    vFijos[0] =  new Extremo(width*0.1, 0.5*height, NAMORT, INTEGRA);
    vFijos[1] =  new Extremo(width*0.1, 0.5*height-20, NAMORT, NATURAL);
    //muelle Arriba
    muelle = new Muelle(vFijos[0], vExtr[0], (0.5)*width-(0.1)*width, INTEGRA);
    muelleReal = new Muelle(vFijos[1], vExtr[1], (0.5)*width-(0.1)*width, NATURAL);
    
    //Creacion del fichero
   /* output = createWriter("RK401.txt");
    output2 = createWriter("AnaliticRK401.txt");
    output3 = createWriter("ErrorRK401.txt");
	*/
}
  
  
  
class Extremo { 
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass = 10.0;
  PVector forceTot;
  // Arbitrary damping to simulate friction / drag 
  float damping = 0.5;

  // For mouse interaction
  PVector dragOffset;
  PVector amortiguamiento;
  boolean dragging = false;
  int amort;
  
  //Variables RK
  PVector location1;
  PVector velocity1;
  PVector acceleration1;
  PVector location2;
  PVector velocity2;
  PVector acceleration2;
  PVector location3;
  PVector velocity3;
  PVector acceleration3;
  PVector location4;
  PVector velocity4;
  PVector acceleration4;
  PVector velTot, accTot;
  
  float velIni, vel;
  float x = 0;
  boolean inAtras = false;
  int tipo;
  // Constructor
  Extremo(float x, float y, int amort_, int tipo_) {
    location = new PVector(x,y);
    velIni = 100;
    velocity = new PVector(velIni, 0); //con una velocidad inicial
    amort = amort_;
    acceleration = new PVector(0, 0);   
    forceTot = new PVector(0, 0);    
    dragOffset = new PVector();
    amortiguamiento = new PVector(0.99, 0.99);
    
    location1 = new PVector();
    velocity1 = new PVector();
    acceleration1 = new PVector();
    location2 = new PVector();
    velocity2 = new PVector();
    acceleration2 = new PVector();
    location3 = new PVector();
    velocity3 = new PVector();
    acceleration3 = new PVector();
    location4 = new PVector();
    velocity4 = new PVector();
    acceleration4 = new PVector();
    velTot = new PVector();
    accTot = new PVector();
    
    tipo = tipo_;
  } 
  
  //integration
  void update(int mode) { 
       
    //Considerar fuerza de amortiguamiento también
   
    if(!dragging){
      //Newton -> F = m * acc
      acceleration.x = forceTot.x / mass;
      acceleration.y = forceTot.y / mass;
      
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
          
        case RK2:
          location1 = location.get();
          velocity1 = velocity.get();
          acceleration1 = acceleration.get();
          
          location2 = PVector.add(location1, PVector.mult(velocity1, dt));
          velocity2 = PVector.add(velocity1,  PVector.mult(acceleration1, dt));
          acceleration2 = getAcc(location2, velocity2);
          
		  
		    PVector mix = new PVector();
			mix = velocity1.get();
			mix.add(velocity2);
			mix.mult(dt/2);		
			location = PVector.add(location1, mix);
		
			mix = acceleration1.get();
			mix.add(acceleration2);
			mix.mult(dt/2);	
			velocity = PVector.add(velocity1, mix);
		  
           
          break;
          
        case RK4:
          location1 = location.get();
          velocity1 = velocity.get();
          acceleration1 = acceleration.get();
          
          location2 = PVector.add(location1, PVector.mult(velocity1, dt/2));
          velocity2 = PVector.add(velocity1, PVector.mult(acceleration1, dt/2));
          acceleration2 = getAcc(location2, velocity2);
          
          location3 = PVector.add(location1, PVector.mult(velocity2, dt/2));
          velocity3 = PVector.add(velocity1, PVector.mult(acceleration2, dt/2));
          acceleration3 = getAcc(location3, velocity3);
          
          location4 = PVector.add(location1, PVector.mult(velocity3, dt/2));
          velocity4 = PVector.add(velocity1, PVector.mult(acceleration3, dt/2));
          acceleration4 = getAcc(location4, velocity4);
          
          velTot = PVector.add(velocity1, PVector.add(PVector.mult(velocity2, 2.0), PVector.add(PVector.mult(velocity3, 2.0), velocity4)));
          accTot = PVector.add(acceleration1, PVector.add(PVector.mult(acceleration2, 2.0), PVector.add(PVector.mult(acceleration3, 2.0), acceleration4)));
          
          location = PVector.add(location1, PVector.mult(velTot, dt/6));       
          
          velocity = PVector.add(velocity1, PVector.mult(accTot, dt/6));   
          
       case REAL:
         float k = 10.0;
         x = dist(0.5*width, 0.5*height, location.x,location.y);
         if(inAtras) //va hacia atrás
           velocity.x =- sqrt((-k/mass)*x*x + velIni*velIni);
         else
           velocity.x = sqrt((-k/mass)*x*x + velIni*velIni);
         if(isNaN(velocity.x)){ //en processing(no web): if(Float.isNaN(velocity.x)){
           if(inAtras){ //vuelve hacia delante
             inAtras = false;             
           }
           else{ //canvia hacia atrás
             inAtras = true;
           }
           velocity.x  =- vel;
         }
         else
           vel = velocity.x;
         
         velocity.y = 0.0;
         location.x += velocity.x * dt;
         location.y += velocity.y * dt;

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
  
  //Actualizamos la aceleración, según la posición y velocidad tomada
  PVector getAcc(PVector pos, PVector vel){
    PVector accPaso = new PVector();
    //dependiendo de la k y la long, calculara las fuerzas y las aplicará a cada extremo
    location = pos.get();
    muelle.update();  
    accPaso.x = forceTot.x / mass;
    accPaso.y = forceTot.y / mass;
    return accPaso;
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
    if(tipo == INTEGRA){
		fill(175,120);
		if (dragging) {
		  fill(50);
		}
	}
    else
      fill(#DF0101);
    
    ellipse(location.x,location.y,mass*2,mass*2);
   
    x = dist(0.5*width, 0.5*height, location.x,location.y);
    //Aquí se escriben los datos en el fichero
    //println(t + "  " + x + "  " + velocity.x + "  " + sqrt((-10.0/mass)*x*x + 100*100) );
    //output.println(velocity.x * velocity.x); //solución método
    //output2.println(abs((-10.0/mass)*x*x + 100*100)); //solución analítica   
    //output3.println(abs(abs(velocity.x) - abs(sqrt((-10.0/mass)*x*x + 100*100)))); //error
  } 

  // The methods below are for mouse interaction

  // This checks to see if we clicked on the mover
  void clicked(int mx) {
  
    float d = dist(mx,location.y,location.x,location.y);
    if (d < mass && tipo == INTEGRA) {
      dragging = true;
      dragOffset.x = location.x-mx;
    }
  }

  void stopDragging() {
  if(tipo == INTEGRA)
    dragging = false;
  }

  void drag(int mx) {
    if (dragging  && tipo == INTEGRA) {
      location.x = mx + dragOffset.x;
    }
  }
}




 class Muelle { 

 
  // Constantes de configuraci�n del muelle
  float len, lrep, fk;
  float k = 10.0, kd = 0.9;
  PVector vfkA, vfkB, vlen, vLenNorm;
  
  int tipo;
//Extremos del muelle
  Extremo a;
  Extremo b;

  // Constructor
  Muelle(Extremo a_, Extremo b_, float l, int tipo_) {
    a = a_;
    b = b_;
    len = l;
    lrep = l;    
    vfkA = new PVector();
    vfkB = new PVector();
    vlen = new PVector();
    vLenNorm = new PVector();
    tipo = tipo_;
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
    if(tipo == INTEGRA)
      stroke(0);
    else
      stroke(#610B0B);
    line(a.location.x, a.location.y, b.location.x, b.location.y);
    
    //pintar la fuerza: linea(extremoa, extremoa+fuerza)
    /*strokeWeight(1);
    stroke(#ff0000);
    line(a.location.x, a.location.y, a.location.x+vfkA.x, a.location.y+vfkA.y);*/
    
    
  }
}