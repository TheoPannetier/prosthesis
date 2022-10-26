class Wing {
  float[] m_shoulder_position;
  float m_l_humerus, m_l_ulna, m_l_hand;
  float m_angle_humerus, m_angle_ulna, m_angle_hand;
  float[] m_elbow_position = new float[2];
  float[] m_wrist_position = new float[2];
  float[] m_phalanx_position = new float[2];
  color m_col_humerus, m_col_ulna, m_col_hand;

  Feather[] m_plumage, m_coverts;
  int m_n_primaries, m_n_secondaries, m_n_feathers;
  float m_angle_hand_first_primary, m_angle_ulna_last_secondary;
  float m_l_primaries, m_l_secondaries;
  color m_col_rachis_primaries, m_col_rachis_secondaries;
  color m_col_vane_primaries, m_col_vane_secondaries;
  float m_l_primary_coverts, m_l_secondary_coverts;
  color m_col_primary_coverts, m_col_secondary_coverts;

  Wing(float[] shoulder_position,
    float l_humerus, float l_ulna, float l_hand,
    float angle_shoulder, float angle_elbow, float angle_wrist,
    color col_humerus, color col_ulna, color col_hand,
    int n_primaries, int n_secondaries,
    float l_primaries, float l_secondaries,
    color col_rachis_primaries, color col_rachis_secondaries,
    color col_vane_primaries, color col_vane_secondaries,
    float angle_hand_first_primary, float angle_ulna_last_secondary,
    float l_primary_coverts, color col_primary_coverts, 
    float l_secondary_coverts, color col_secondary_coverts
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
    m_l_primary_coverts = l_primary_coverts;
    m_l_secondary_coverts = l_secondary_coverts;
    m_col_primary_coverts = col_primary_coverts;
    m_col_secondary_coverts = col_secondary_coverts;
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
    m_coverts = new Feather[m_n_feathers];

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
      
      float[] covert_tip = {
        feather_root[0] + m_l_primary_coverts * cos(angle_feather),
        feather_root[1] + m_l_primary_coverts * sin(angle_feather)
      };
      m_coverts[i] = new Feather(
        feather_root, 
        covert_tip, 
        m_col_primary_coverts, 
        m_col_primary_coverts
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
       
       float[] covert_tip = {
        feather_root[0] + m_l_secondary_coverts * cos(angle_feather),
        feather_root[1] + m_l_secondary_coverts * sin(angle_feather)
       };
       m_coverts[m_n_primaries + i] = new Feather(
        feather_root, 
        covert_tip, 
        m_col_secondary_coverts, 
        m_col_secondary_coverts
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
    for (int i = 0; i < m_n_feathers; ++i) {
      m_coverts[i].draw();
    }
  }
}
