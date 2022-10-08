float[] shoulder_position = {0.0, 100.0};
float l_humerus = 80.0; 
float l_ulna = 100.0; 
//float l_hand = 20.0;
float angle_shoulder = deg_to_rad(30.0);
float angle_elbow = deg_to_rad(-30.0);
//float angle_wrist = deg_to_rad();
//float angle_hand_first_feather = deg_to_rad();

color col_humerus = #35bfd7;
color col_ulna = #e8656a;

Wing bird_wing;

void setup() {
  background(234);
  size(400, 400);
  bird_wing = new Wing(
    shoulder_position,
    l_humerus,
    l_ulna,
    angle_shoulder,
    angle_elbow
  );
}

void draw() {
  bird_wing.draw();
}

class Wing {
  float[] m_shoulder_position;
  float m_l_humerus, m_l_ulna; //m_l_hand;
  // float m_l_feather;
  float m_angle_shoulder, m_angle_elbow;//, m_angle_wrist;
  //float m_angle_hand_first_feather;
  
  float[] m_elbow_position = new float[2];
  float[] m_wrist_position = new float[2];
  
  Wing(float[] shoulder_position,
       float l_humerus, 
       float l_ulna, 
       //float l_hand,
       float angle_shoulder,
       float angle_elbow//,
       //float angle_wrist//,
       //float angle_hand_first_feather
       ) 
  {
    m_shoulder_position = shoulder_position;
    m_l_humerus = l_humerus;
    m_l_ulna = l_ulna;
    //m_l_hand = l_hand;
    m_angle_shoulder = angle_shoulder;
    m_angle_elbow = angle_elbow; 
    //m_angle_wrist = angle_wrist;
    //m_angle_hand_first_feather = angle_hand_first_feather;
    
    // Find elbow
    m_elbow_position[0] = m_shoulder_position[0] + m_l_humerus * cos(m_angle_shoulder);
    m_elbow_position[1] = m_shoulder_position[1] + m_l_humerus * sin(m_angle_shoulder);
    
    // Find wrist
    m_wrist_position[0] = m_elbow_position[0] + m_l_ulna * cos(m_angle_elbow);
    m_wrist_position[1] = m_elbow_position[1] + m_l_ulna * sin(m_angle_elbow);
  }
  
  void draw()
  {
     // Draw humerus
     stroke(col_humerus);
     line(
       m_shoulder_position[0], m_shoulder_position[1],
       m_elbow_position[0], m_elbow_position[1]
     );
     // Draw ulna
     stroke(col_ulna);
     line(
       m_elbow_position[0], m_elbow_position[1],
       m_wrist_position[0], m_wrist_position[1]
     );
 }
}

float deg_to_rad(float angle_degrees)
{
  return angle_degrees * PI / 180.0;
}
