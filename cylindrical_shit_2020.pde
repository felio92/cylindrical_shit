import themidibus.*; //Import the library
import controlP5.*;

ControlP5 cp5;
MidiBus LPD8;
MidiBus Kaossilator;

public Slider ampg_slider;
public Slider amp1_slider;
public Slider amp2_slider;
public Slider huerange_slider;
public Slider huestart_slider;
public Slider sat_slider;
public Slider n1_slider;
public Slider freq_z1_slider;
public Slider n2_slider;
public Slider freq_z2_slider;
public Slider vel_slider;
public Slider squeeze_slider;
public Slider q_slider;

public Button pulse_add_button;
public Button pulse_remove_button;

public float ampg = 500;
public float amp1 = 0;
public float freq_z1 = 0;
public int n1 = 0;
public int n1_new = 0;

public float amp2 = 150;
public float freq_z2 = 0;
public int n2 = 0;
public float vel = 1;
public float squeeze = 1;

public float huerange=350;
public float huestart=10;
public float sat=10;
public float winkelx = 0;
public float winkely = 0;
public float z_displ = 0;
public float q=40;

public float t0 = millis();
public boolean bpm_detected = true;
public float bpm = 140;
public float t_baseline = millis();

int itR = 200;
int itZ = 50;

ArrayList<PulsePreview> pulsepreviews;

FunkyCylinder cylinder = new FunkyCylinder(ampg, amp1, n1,freq_z1, huerange, huestart, sat, itZ, itR, q);
PulsePreview currentprev = new PulsePreview(ampg, amp2 , n2, vel, freq_z2, squeeze, itR);

void setup() {
  fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 0);
  stroke(0, 0, 100, 100);
  smooth(5);
  
  pulsepreviews = new ArrayList<PulsePreview> ();
  
  MidiBus.list();
  //LPD8 = new MidiBus(this, "LPD8", -1 );
  //Kaossilator = new MidiBus(this, "KAOSSILATOR PRO 1 PAD", -1);
  
  cp5 = new ControlP5(this);
 
  huerange_slider=cp5.addSlider("hue_range")
     .setRange(0, 360)
     .setPosition(20, 20)
     .setSize(100, 10)
     .setValue(50)
     ;
     
  huestart_slider=cp5.addSlider("hue_start")
     .setRange(0, 360)
     .setPosition(20, 40)
     .setSize(100, 10)
     .setValue(50)
     ;
  sat_slider=cp5.addSlider("set_sat")
     .setRange(0, 100)
     .setPosition(20, 60)
     .setSize(100, 10)
     .setValue(10)
     ;
  q_slider = cp5.addSlider("set_q")
     .setRange(1, 100)
     .setPosition(20, 100)
     .setSize(100, 10)
     .setValue(40)
     ;
  amp1_slider=cp5.addSlider("amplitude_1")
     .setRange(0, 200)
     .setPosition(20, 160)
     .setSize(100, 10)
     .setValue(0)
     ;
  
    ampg_slider = cp5.addSlider("amplitude_Main")
     .setRange(300, 500)
     .setPosition(20, 120)
     .setSize(100, 10)
     .setValue(500)
     ;

  n1_slider=cp5.addSlider("set_n1")
     .setRange(0, 20)
     .setPosition(20, 180)
     .setSize(100, 10)
     .setValue(0)
     ;
   freq_z1_slider = cp5.addSlider("set_freq_z1")
   .setRange(0, 200)
   .setPosition(20, 200)
   .setSize(100, 10)
   .setValue(0)
   ;
   amp2_slider=cp5.addSlider("amplitude_2")
     .setRange(0, 200)
     .setPosition(20, 240)
     .setSize(100, 10)
     .setValue(150)
     ;
   freq_z2_slider = cp5.addSlider("set_freq_z2")
   .setRange(0, 200)
   .setPosition(20, 260)
   .setSize(100, 10)
   .setValue(0)
   ;
   n2_slider=cp5.addSlider("set_n2")
     .setRange(0, 20)
     .setPosition(20, 280)
     .setSize(100, 10)
     .setValue(0)
     ;
  vel_slider=cp5.addSlider("set_vel")
     .setRange(0, 100)
     .setPosition(20, 300)
     .setSize(100, 10)
     .setValue(0)
     ;
   squeeze_slider=cp5.addSlider("set_squeeze")
     .setRange(1, 100)
     .setPosition(20, 320)
     .setSize(100, 10)
     .setValue(0)
     ;
  
  pulse_add_button=cp5.addButton("add_pulse")
          .setValue(0)
          .setPosition(20,340)
          .setSize(200, 19)
          ;
  pulse_remove_button=cp5.addButton("remove_pulse")
          .setValue(0)
          .setPosition(20,360)
          .setSize(200, 19)
          ;
          
}
void draw() {
  strokeWeight(2.);
  //Kaossilator.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  //Kaossilator.sendControllerChange(channel, number, value); // Send a controllerChange
  //LPD8.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  //LPD8.sendControllerChange(channel, number, value); // Send a controllerChange
  float t=millis()-t_baseline;
  float T_amp = 2*120000./bpm;
  
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateY(0*PI+1*PI/9*(sin(0.0001*millis())));
  rotateX(PI/9*cos(0.0001*millis()));
  rotateZ(0.00006*millis());
  translate(0, 0, -itZ*q);
  background(0);
  if ((n1!=n1_new)&&abs(sin(2*PI*t/T_amp))<0.1){
   n1 = n1_new; 
  }
  cylinder.set_parameters(ampg, amp1, n1, freq_z1, huerange, huestart, sat, itZ, itR, q);
  cylinder.display(t);
  popMatrix();
  
  
  pushMatrix();
  translate(250, 280);
  currentprev.set_parameters(ampg, amp2 , n2, vel/100., freq_z2/100., squeeze/100., itR);
  currentprev.display(t);
  popMatrix();
  
  pushMatrix();
  translate(width-200, 100, 0);
  for (int i=0; i<pulsepreviews.size(); i++) {
    pushMatrix();
    translate(0, 160*i, 0);
    pulsepreviews.get(i).display(t);
    popMatrix();
  }
  popMatrix();
  //LPD8.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
}



public void amplitude_Main(float newamp) {
  ampg = newamp;
}
 
public void amplitude_1(float newamp) {
  amp1 = newamp;
}

public void amplitude_2(float newamp) {
  amp2 = newamp;
}

public void hue_range(float hue) {
  huerange = hue;
}

public void hue_start(float hue) {
  huestart = hue;
}

public void set_sat(float satur) {
  sat = satur;
}

public void set_n1(int n) {
  n1_new = n;
}

public void set_freq_z1(float f) {
  freq_z1 = PI*f/200;
}

public void set_freq_z2(float fz) {
  freq_z2 = fz;
}

public void set_n2(int n) {
 n2 = n; 
}

public void set_vel(float v) {
  vel = v;
}

public void set_squeeze(float sq) {
 squeeze = sq; 
}

public void set_q(float new_q) {
 q = new_q; 
}

public void add_pulse() {
 if (pulsepreviews.size()>=9){
      pulsepreviews.remove(0);
    }
    pulsepreviews.add(new PulsePreview(ampg, amp2 , n2, vel/100., freq_z2/100., squeeze/100., itR));
    cylinder.add_pulse(amp2, n2, vel/100., freq_z2/100, squeeze/100); 
 n2_slider.setValue(0);
}

public void remove_pulse() {
  cylinder.remove_pulse();
   if (pulsepreviews.size()>0){
    pulsepreviews.remove(0); 
   }
}


void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  if (pitch==39) {
   if (bpm_detected){
    t0 = millis();
    bpm_detected=false;
   }
   else{
     float dt = millis()-t0;
     bpm = 60*1000/dt;
     println();
     println("BPM:"+bpm);
     bpm_detected=true;
   }
  }
  if (pitch==43) {
   println();
   println("Resetting t_baseline");
   t_baseline = millis(); 
  }
  if (pitch==40) {
   n1_slider.setValue(n1+1);
  }
  if (pitch==36) {
   n1_slider.setValue(n1-1);
  }
  if (pitch==42) {
    try{
   add_pulse(); 
     }
   catch(Exception e){
     println(e);
   }
  }
   if (pitch==38) {
    try{
   cylinder.remove_pulse(); 
     }
   catch(Exception e){
     println(e);
   }
  }
  if (pitch==41){n2_slider.setValue(n2+1);}
  if (pitch==37){n2_slider.setValue(n2-1);}
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOn
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if (number==1){ampg_slider.setValue(300+200*value/127);}
  if (number==2){amp1_slider.setValue(200*value/127);}
  if (number==3) {freq_z1_slider.setValue(200*value/127);}
  if (number==5) {amp2_slider.setValue(200*value/127);}
  if (number==4) {freq_z2_slider.setValue(200*value/127);}
  if (number==6) {vel_slider.setValue(100*value/127);}
  if (number==7) {squeeze_slider.setValue(1+99*value/127);}
  if (number==13){huerange_slider.setValue(360*value/127);}
  if (number==12){huestart_slider.setValue(360*value/127);}
  if (number==93){sat_slider.setValue(100*value/127);}
  if (number==94){q_slider.setValue(1+99*value/127);}
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
