/*Clara Peñalva
Tema 1 - Ejercicio 10: Simular Péndulo.*/
 
final int EULER = 0;
final int RK2 = 1;
final int RK4 = 2;
final int SOLUTION = 3;
final int EULER_SIMIM = 4;

//variables
Pendul pE, pSEM, pS, pRK2, pRK4; 

float erE;
float erSEM;
float erRK2;
float erRK4;

void setup(){
  
  size(650,500);
  smooth(); 
  textSize(20);
  ini();
}
 
void draw(){
  background(#ffffff);
  fill(#000000);
  stroke(#000000);
  
  line(100, height/2, 550, height/2);
  pE.go();
  pSEM.go();
  pRK2.go();
  pRK4.go();
  pS.go();
  errores();
}

void ini(){
  pE = new Pendul(new PVector(width/2, height/2), 222.0, EULER, PI/4);
  pSEM = new Pendul(new PVector(width/2, height/2), 222.0, EULER_SIMIM, PI/4); 
  pRK2 = new Pendul(new PVector(width/2, height/2), 222.0, RK2, PI/4);
  pRK4 = new Pendul(new PVector(width/2, height/2), 222.0, RK4, PI/4);
  pS = new Pendul(new PVector(width/2, height/2), 222.0, SOLUTION, PI/4); 
}

void errores(){
  erE = abs(pE.theta - pS.theta);
  erSEM = abs(pSEM.theta - pS.theta);
  erRK2 = abs(pRK2.theta - pS.theta);
  erRK4= abs(pRK4.theta - pS.theta);
   
  fill(#000000);
  text("Volver a comenzar: 'espacio'.", 300, 40);
  text("Color solución analítca", 50, 50);
  fill(#ff0000);
  text(" Error Euler: " + erE, 50, 90);
  fill(#ffd400);
  text(" Error Euler_Semi: " + erSEM, 50, 120);
  fill(#00ff00);
  text(" Error RK2: " + erRK2 , 50, 150);
  fill(#00d4ff);
  text(" Error RK4: " + erRK4, 50, 180);

}

void keyPressed(){
   if(key == ' '){
     ini();
   }
}
class Pendul {
  PVector orig, theta_pos;
  float rad; 
  float theta, thetaIni, acc, theta_vel;
  int mode;
  float t, g, dt;
  
  float theta_k2, acc_k2, acc_fin, theta_vel_fin; 
  
  float theta_vel_k2, theta_k3, acc_k3, theta_vel_k3, theta_k4, theta_vel_k4, acc_k4;
  
  float theta_vel1 = 0, theta_vel2 = 0, theta1 = 0, theta2 = 0, acc1 = 0, acc2 = 0;
  
  Pendul(PVector or, float r, int m, float th){
    rad = r;
    mode = m;
    theta = th;
    orig = new PVector();
    orig = or.get();
    theta_pos = new PVector();
    theta_pos.x = (rad*sin(theta))+ orig.x;
    theta_pos.y = (rad*cos(theta))+ orig.y;
    
    theta_vel = 0.0f;
    t = 0.0;
    dt = 0.1;
    g = 9.8;
    acc = 0.0f;
    thetaIni = theta;
    
    
  }

 void go(){
   update();
   render();
   t += dt;
 }
 
  void update(){
    switch(mode){
      
      case EULER:        
        theta += theta_vel * dt; 
        theta_vel += acc*dt;
        acc = (-g / rad) * sin(theta);
        break;
        
      case EULER_SIMIM:
        acc = (-g / rad) * sin(theta);
        theta_vel += acc*dt;
        theta += theta_vel * dt; 
        break;
        
      case RK2:
        theta1 = theta;
        theta_vel1 = theta_vel;
        acc1 = acc;
        
        theta2 = theta1 + theta_vel1 * dt;        
        theta_vel2 = theta_vel1 +  (acc1 * dt);        
        acc2 = -g/rad*sin(theta2);
        
        theta = theta1 + (theta_vel1 + theta_vel2)* (dt/2);        
        theta_vel = theta_vel1 + (acc1 + acc2) * (dt/2);
        break;
        
      case RK4: 
        acc = g/rad*sin(theta); 
                
        theta_k2 = theta + theta_vel * dt/2;
        theta_vel_k2 = theta_vel + acc * dt/2;
        acc_k2 = -g / rad * sin(theta_k2);        
         
        theta_k3 = theta + theta_vel_k2 * dt/2;
        theta_vel_k3 = theta_vel + acc_k2 * dt/2;
        acc_k3 = -g / rad * sin(theta_k3);
              
        theta_k4 = theta + theta_vel_k3 * dt;
        theta_vel_k4 = theta_vel + acc_k3 * dt/2;
        acc_k4 = -g / rad * sin(theta_k4);
         
        theta_vel_fin = (theta_vel + (2*theta_vel_k2) + (2*theta_vel_k3) + theta_vel_k4) / 6;
        acc_fin = (acc + (2*acc_k2) + (2*acc_k3) + acc_k4) / 6;
        
        theta += theta_vel_fin * dt;
        theta_vel += acc_fin * dt;
        break; 
        
      case SOLUTION:
        theta = thetaIni * sin(sqrt(g/rad) * t + PI/2);
        break;
        
    }
    
   theta_pos.x = (rad*sin(theta))+ orig.x;
   theta_pos.y = (rad*cos(theta))+ orig.y;    
  }
  
  void render(){
    switch(mode){
      case EULER:
        stroke(250, 0, 0);
        fill(#ff0000);
        break;
      case EULER_SIMIM:
        stroke(250, 150, 0);
        fill(#ffd400);
        break;
      case RK2:
        stroke(0, 250, 0);
        fill(#00ff00);
        break;
      case RK4:
        stroke(0, 150, 250);
        fill(#00d4ff);
        break;  
      case SOLUTION:
        stroke(0, 0, 0);
        fill(#000000);
        break;
      
    }
    line(orig.x, orig.y,  theta_pos.x, theta_pos.y);
    ellipse(theta_pos.x, theta_pos.y, 20, 20);
  }
}