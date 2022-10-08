float[] shoulder_origin = {0.0, 100.0};
float l_humerus = 100.0; 
//float l_ulna = 60.0; 
//float l_hand = 20.0;
float angle_shoulder = deg_to_rad(30.0);
//float angle_elbow = deg_to_rad();
//float angle_wrist = deg_to_rad();
//float angle_hand_first_feather = deg_to_rad();

color col_humerus = #35bfd7;

Wing bird_wing;

void setup() {
  background(234);
  size(400, 400);
  bird_wing = new Wing(
    shoulder_origin,
    l_humerus,
    angle_shoulder
  );
}

void draw() {
  bird_wing.draw();
}

class Wing {
  float[] m_shoulder_origin;
  float m_l_humerus;//, m_l_ulna, m_l_hand;
  // float m_l_feather;
  float m_angle_shoulder;//, m_angle_elbow, m_angle_wrist;
  //float m_angle_hand_first_feather;
  
  float[] m_humerus_end = new float[2];
  
  Wing(float[] shoulder_origin,
       float l_humerus, 
       //float l_ulna, 
       //float l_hand,
       float angle_shoulder
       //float angle_elbow,
       //float angle_wrist//,
       //float angle_hand_first_feather
       ) 
  {
    m_shoulder_origin = shoulder_origin;
    m_l_humerus = l_humerus;
    //m_l_ulna = l_ulna;
    //m_l_hand = l_hand;
    m_angle_shoulder = angle_shoulder;
    //m_angle_elbow = angle_elbow; 
    //m_angle_wrist = angle_wrist;
    //m_angle_hand_first_feather = angle_hand_first_feather;
    
    m_humerus_end[0] = m_shoulder_origin[0] + m_l_humerus * cos(m_angle_shoulder);
    m_humerus_end[1] = m_shoulder_origin[1] + m_l_humerus * sin(m_angle_shoulder);
  }
  
  void draw()
  {
     // Draw humerus
     stroke(col_humerus);
     line(
       m_shoulder_origin[0], m_shoulder_origin[1],
       m_humerus_end[0], m_humerus_end[1]
     );
 }
}

float deg_to_rad(float angle_degrees)
{
  return angle_degrees * PI / 180.0;
}
