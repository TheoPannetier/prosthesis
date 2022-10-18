// Arm parameters
float[] wing_origin = {0.0, 200.0};
float l_humerus = 100.0;
float l_ulna = 240.0;
float l_hand = 200.0;
float angle_shoulder = radians(45.0);
float angle_elbow = radians(-60.0);
float angle_wrist = radians(25.0);

// Feather parameters
float angle_hand_first_primary = radians(5.0);
float angle_ulna_last_secondary = radians(120.0);
int n_primaries = 10;
int n_secondaries = 10;
float l_primaries = 120.0;
float l_secondaries = 120.0;

// Colours
color col_humerus = #35bfd7;
color col_ulna = #e8656a;
color col_hand = #2d9003;
color col_rachis_primaries = #f15025;
color col_rachis_secondaries = #44cef6;
color col_vane_primaries = #657065;
color col_vane_secondaries = #b1c0bf;

Wing bird_wing;

void setup() {
  background(234);
  size(1000, 600);
  bird_wing = new Wing(
    wing_origin,
    l_humerus, l_ulna, l_hand,
    angle_shoulder, angle_elbow, angle_wrist,
    col_humerus, col_ulna, col_hand,
    n_primaries, n_secondaries,
    l_primaries, l_secondaries,
    col_rachis_primaries, col_rachis_secondaries,
    col_vane_primaries, col_vane_secondaries,
    angle_hand_first_primary, angle_ulna_last_secondary 
    );
}

void draw() {
  bird_wing.draw();
}

class Wing {
  float[] m_shoulder_position;
  float m_l_humerus, m_l_ulna, m_l_hand;
  float m_angle_humerus, m_angle_ulna, m_angle_hand;
  float[] m_elbow_position = new float[2];
  float[] m_wrist_position = new float[2];
  float[] m_phalanx_position = new float[2];
  color m_col_humerus, m_col_ulna, m_col_hand;

  Feather[] m_plumage;
  int m_n_primaries, m_n_secondaries, m_n_feathers;
  float m_angle_hand_first_primary, m_angle_ulna_last_secondary;
  float m_l_primaries, m_l_secondaries;
  color m_col_rachis_primaries, m_col_rachis_secondaries;
  color m_col_vane_primaries, m_col_vane_secondaries;

  Wing(float[] shoulder_position,
    float l_humerus, float l_ulna, float l_hand,
    float angle_shoulder, float angle_elbow, float angle_wrist,
    color col_humerus, color col_ulna, color col_hand,
    int n_primaries, int n_secondaries,
    float l_primaries, float l_secondaries,
    color col_rachis_primaries, color col_rachis_secondaries,
    color col_vane_primaries, color col_vane_secondaries,
    float angle_hand_first_primary, float angle_ulna_last_secondary
    )
  {
    // Build arm
    m_shoulder_position = shoulder_position;
    m_l_humerus = l_humerus;
    m_l_ulna = l_ulna;
    m_l_hand = l_hand;
    m_angle_humerus = angle_shoulder;
    m_angle_ulna = m_angle_humerus + angle_elbow;
    m_angle_hand = m_angle_ulna + angle_wrist;
    place_arm();
    
    m_col_humerus = col_humerus; 
    m_col_ulna = col_ulna; 
    m_col_hand = col_hand;
    
    // Build plumage
    m_n_primaries = n_primaries;
    m_n_secondaries = n_secondaries;
    m_n_feathers = m_n_primaries + m_n_secondaries;
    m_l_primaries = l_primaries;
    m_l_secondaries = l_secondaries;
    m_angle_hand_first_primary = angle_hand_first_primary;
    m_angle_ulna_last_secondary = angle_ulna_last_secondary;
    m_col_rachis_primaries = col_rachis_primaries;
    m_col_rachis_secondaries = col_rachis_secondaries;
    m_col_vane_primaries = col_vane_primaries;
    m_col_vane_secondaries = col_vane_secondaries;
    place_plumage();
  }
  
  void place_arm()
  {
    // Place elbow
    m_elbow_position[0] = m_shoulder_position[0] + m_l_humerus * cos(m_angle_humerus);
    m_elbow_position[1] = m_shoulder_position[1] + m_l_humerus * sin(m_angle_humerus);

    // Place wrist
    m_wrist_position[0] = m_elbow_position[0] + m_l_ulna * cos(m_angle_ulna);
    m_wrist_position[1] = m_elbow_position[1] + m_l_ulna * sin(m_angle_ulna);

    // Place phalanx tip
    m_phalanx_position[0] = m_wrist_position[0] + m_l_hand * cos(m_angle_hand);
    m_phalanx_position[1] = m_wrist_position[1] + m_l_hand * sin(m_angle_hand);
  }
  
  void place_plumage()
  {
    m_plumage = new Feather[m_n_feathers];
    
    float abs_angle_first = m_angle_hand + m_angle_hand_first_primary;
    float abs_angle_last = m_angle_ulna + m_angle_ulna_last_secondary;

    // Place primary feathers
    for (int i = 0; i < m_n_primaries; ++i) {

      float rel_spacing = float(i + 1) / float (m_n_primaries + 1);
      float l_spacing = lerp(m_l_hand, 0, rel_spacing);
      float[] feather_root = {
        m_wrist_position[0] + l_spacing * cos(m_angle_hand),
        m_wrist_position[1] + l_spacing * sin(m_angle_hand)
      };
      
      float angle_spacing = float(i) / float(m_n_feathers - 1);
      float angle_feather = lerp(abs_angle_first, abs_angle_last, angle_spacing);
      println(degrees(angle_feather));
      float[] feather_tip = {
        feather_root[0] + m_l_primaries * cos(angle_feather),
        feather_root[1] + m_l_primaries * sin(angle_feather)
      };
      m_plumage[i] = new Feather(
        feather_root, 
        feather_tip, 
        m_col_rachis_primaries, 
        m_col_vane_primaries
      );
    }
    
    // Place secondary feathers
    for (int i = 0; i < m_n_secondaries; ++i) {
      
      float rel_spacing = float(i) / float (m_n_secondaries - 1);
      float l_spacing = lerp(m_l_ulna, 0, rel_spacing);
      float[] feather_root = {
        m_elbow_position[0] + l_spacing * cos(m_angle_ulna),
        m_elbow_position[1] + l_spacing * sin(m_angle_ulna)
      };
      
      float angle_spacing = float(m_n_primaries + i) / float(m_n_feathers - 1);
      float angle_feather = lerp(abs_angle_first, abs_angle_last, angle_spacing);
      float[] feather_tip = {
        feather_root[0] + m_l_secondaries * cos(angle_feather),
        feather_root[1] + m_l_secondaries * sin(angle_feather)
      };
      m_plumage[m_n_primaries + i] = new Feather(
        feather_root, 
        feather_tip, 
        m_col_rachis_secondaries, 
        m_col_vane_secondaries
       );
    }
  }

  void draw()
  {
    // Draw arm
    stroke(m_col_humerus);
    line(
      m_shoulder_position[0], m_shoulder_position[1],
      m_elbow_position[0], m_elbow_position[1]
      );
    stroke(m_col_ulna);
    line(
      m_elbow_position[0], m_elbow_position[1],
      m_wrist_position[0], m_wrist_position[1]
      );
    stroke(m_col_hand);
    line(
      m_wrist_position[0], m_wrist_position[1],
      m_phalanx_position[0], m_phalanx_position[1]
      );

    // Draw feathers
    for (int i = 0; i < m_n_feathers; ++i) {
      m_plumage[i].draw();
    }
  }
}

class Feather {
  float[] m_root, m_tip;
  color m_rachis_color, m_vane_color;
  float m_vane_rel_origin = 0.2;
  float m_vane_rel_length = 1.5;
  float m_vane_rel_width= 0.3;
  float m_rachis_length;
  float m_angle;

  Feather(float[] root, float[] tip, color rachis_col, color vane_col)
  {
    m_root = root;
    m_tip = tip;
    m_rachis_color = rachis_col;
    m_vane_color = vane_col;
    m_rachis_length = dist(m_root[0], m_root[1], m_tip[0], m_tip[1]);
    m_angle = acos((m_tip[0] - m_root[0]) / m_rachis_length);
  }
  void draw()
  {
    /// Draw vane first
    stroke(m_vane_color);
    fill(m_vane_color);
    float[] vane_origin = {
      (1.0 - m_vane_rel_origin) * (m_root[0]) + m_vane_rel_origin * m_tip[0],
      (1.0 - m_vane_rel_origin) * (m_root[1]) + m_vane_rel_origin * m_tip[1]
    };
    float vane_length = m_vane_rel_length * m_rachis_length;
    float vane_width = m_rachis_length * m_vane_rel_width;
    float[] vane_center = {
      vane_origin[0] + vane_length * cos(m_angle) / 2.0,
      vane_origin[1] + vane_length * sin(m_angle) / 2.0
    };
    pushMatrix();
    translate(vane_center[0], vane_center[1]);
    rotate(m_angle);
    ellipse(0.0, 0.0, vane_length, vane_width);
    popMatrix();
    
    /// Draw rachis on top
    stroke(m_rachis_color);
    line(m_root[0], m_root[1], m_tip[0], m_tip[1]);
  }
}
