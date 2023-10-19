class FunkyCylinder {
  float r_main, r_wave;
  float hue_range, hue_start, sat;
  int n_circles; 
  int n_lines; 
  ArrayList<Pulse> pulses;
  float q;
  float freq_z;
  int n_pulses;
  int n1;
  FunkyCylinder(float r0, float r1, int n, float fz, float hueR, float hueS, float s, int nC, int nL, float dz ) {
    pulses = new ArrayList<Pulse>();
    this.set_parameters(r0, r1, n, fz, hueR, hueS, s, nC, nL, dz);
  }
  void set_parameters(float r0, float r1, int n, float fz, float hueR, float hueS, float s, int nC, int nL, float dz) {
    r_main = r0;
    r_wave = r1;
    hue_range = hueR;
    hue_start = hueS;
    sat = s;
    n_circles = nC;
    n_lines = nL;
    q = dz;
    freq_z = fz;
    n_pulses = 9;
    n1 = n;
  }

  void display(float t) {
    for (int i = 0; i<n_circles; i++) {
      stroke(huestart+huerange*noise(0.01*i, 0.0006*millis(), -0.00050*millis()), sat, 80, 100*(i/float(itZ)));
      float z = i/float(n_circles); 
      for (int j = 0; j<n_lines; j++) {
        float phi_i=2*PI*j/n_lines;
        float phi_f=2*PI*(j+1)/n_lines;
        float r_i = this.radius(t, z, phi_i);
        float r_f = this.radius(t, z, phi_f);
        line(r_i*cos(phi_i), r_i*sin(phi_i), q*i, r_f*cos(phi_f), r_f*sin(phi_f), q*i);
      }
    }
  }
  float radius(float t, float z, float phi) {
    float T_wave = 4000.;
    float T_amp =  2*120000./bpm;
    float r2 = r_wave*sin(2*PI*t/T_amp)*sin(n1*phi-t/T_wave+2*PI*freq_z1*z)*exp(-1/4*pow((z-sin(t/8000)),2) + noise(0.001*t,0.5*z));
    float r_pulses = 0;
      for (int i=0; i<pulses.size(); i++) {
       try{
       r_pulses = r_pulses + pulses.get(i).radius(t, z, phi);
       }
       catch(Exception e) {
        println(e); 
       }
      }
    
    return r_main + r2 + r_pulses + r_main*0.05*noise(0.001*millis(),5*z) ;
  }
  void add_pulse(float a, int n, float v, float f_z, float sq) {
    if (pulses.size()>=n_pulses){
      pulses.remove(0);
    }
    pulses.add(new Pulse(a, n, v, f_z, sq));
  }
  void remove_pulse() {
   if (pulses.size()>0){
    pulses.remove(0); 
   }
  }
}

class Pulse {
 float amp;
 float n_wave;
 float z_pos;
 float vel;
 float freq_z;
 float t_born;
 float squeeze;
 Pulse(float a, int n, float v, float f_z, float sq)
 {
  amp = a;
  n_wave = n;
  vel = v;
  freq_z = f_z;
  z_pos = 0;
  t_born = millis();
  squeeze = sq;
 }
 float radius(float t0, float z, float phi) {
  float t = t0-t_born;
  float r = amp*cos(n_wave*(phi+t/8000.)+2*PI*freq_z*z+5*noise(0.02*z+0.0001*t))*exp(-10*squeeze*pow((z-sin(vel*t/1000.)),2));
  return r; 
 }
}

class PulsePreview {
      float ampg;
      float amp;
      float n_wave;
      float z_pos;
      float vel;
      float freq_z;
      float squeeze;
      float n_lines;
      float t_born;
      PulsePreview(float ag, float a, float n, float v, float f_z, float sq, float n_l)
      {
        ampg = ag;
        amp = a;
        n_wave = n;
        vel = v;
        freq_z = f_z;
        z_pos = 0;
        squeeze = sq;
        n_lines = n_l;
        t_born = millis();
      }
      
      void set_parameters(float ag, float a, float n, float v, float f_z, float sq, float n_l) {
        ampg = ag;
        amp = a;
        n_wave = n;
        vel = v;
        freq_z = f_z;
        z_pos = 0.0;
        squeeze = sq;
        n_lines = n_l;
    }
      
      void display(float t0) {
        stroke(0, 0, 100, 100);
        float t = (t0-t_born);
        pushMatrix();
         rotateY(0*PI+1*PI/9*(sin(0.0001*millis())));
          rotateX(PI/9*cos(0.0001*millis()));
          rotateZ(0.00006*millis());
        for (int j = 0; j<n_lines; j++) {
          float phi_i=2*PI*j/n_lines;
          float phi_f=2*PI*(j+1)/n_lines;
          float r_i = this.radius(0, phi_i);
          float r_f = this.radius(0, phi_f);
          line(r_i*cos(phi_i), r_i*sin(phi_i), 0, r_f*cos(phi_f), r_f*sin(phi_f), 0);
        }
        popMatrix();
        for (int i = 0; i<100; i++) {
          float zi = i/100.;
          float zf = (i+1)/100.;
          line(60+50*exp(-30.0*squeeze*pow(zi-sin(vel*t/1000.),2)), (i-50), 60+50*exp(-30.0*squeeze*pow(zf-sin(vel*t/1000.),2)) ,((i+1)-50));
        }  
        for (int i = 0; i<100; i++) {
          float zi = i/100.;
          float zf = (i+1)/100.;
          line(160+25*cos(2*PI*freq_z*zi), (i-50), 160+25*cos(2*PI*freq_z*zf) ,((i+1)-50));
        }  
    }
      
      float radius(float z, float phi) {
        float r = (ampg + amp*cos(n_wave*(phi)+2*PI*freq_z*z+5*noise(0.02*z)));
        return 50*r/700; 
      }
}
