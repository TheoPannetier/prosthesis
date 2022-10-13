// Arm parameters
float[] wing_origin = {0.0, 100.0};
float l_humerus = 100.0;
float l_ulna = 240.0;
float l_hand = 200.0;
float angle_shoulder = deg_to_rad(60.0);
float angle_elbow = deg_to_rad(-90.0);
float angle_wrist = deg_to_rad(50.0);

// Feather parameters
float angle_hand_first_primary = deg_to_rad(5.0);
float angle_hand_last_primary = deg_to_rad(100.0);
float angle_wrist_first_secondary = deg_to_rad(0.0);
float angle_elbow_last_secondary = deg_to_rad(0.0);

int n_primaries = 4;
int n_secondaries = 4;
float l_primaries = 100.0;
float l_secondaries = 150.0;

// Colours
color col_humerus = #35bfd7;
color col_ulna = #e8656a;
color col_hand = #2d9003;
color col_primaries = #f15025;
color col_secondaries = #44cef6;

Wing bird_wing;

void setup() {
  background(234);
  size(1000, 600);
  bird_wing = new Wing(
    wing_origin,
    l_humerus,
    l_ulna,
    l_hand,
    angle_shoulder,
    angle_elbow,
    angle_wrist
    );
}

void draw() {
  bird_wing.draw();
}

class Wing {
  float[] m_shoulder_position;
  float m_l_humerus, m_l_ulna, m_l_hand;
  float m_angle_shoulder, m_angle_elbow, m_angle_wrist;
  float m_angle_ulna, m_angle_hand;

  float[] m_elbow_position = new float[2];
  float[] m_wrist_position = new float[2];
  float[] m_phalanx_position = new float[2];

  Feather[] m_plumage;

  Wing(float[] shoulder_position,
    float l_humerus,
    float l_ulna,
    float l_hand,
    float angle_shoulder,
    float angle_elbow,
    float angle_wrist
    )
  {
    m_shoulder_position = shoulder_position;
    m_l_humerus = l_humerus;
    m_l_ulna = l_ulna;
    m_l_hand = l_hand;
    m_angle_shoulder = angle_shoulder;
    m_angle_elbow = angle_elbow;
    m_angle_wrist = angle_wrist;
    m_angle_ulna = m_angle_shoulder + m_angle_elbow;
    m_angle_hand = m_angle_ulna + m_angle_wrist;

    // Find elbow
    m_elbow_position[0] = m_shoulder_position[0] + m_l_humerus * cos(m_angle_shoulder);
    m_elbow_position[1] = m_shoulder_position[1] + m_l_humerus * sin(m_angle_shoulder);

    // Find wrist
    m_wrist_position[0] = m_elbow_position[0] + m_l_ulna * cos(m_angle_ulna);
    m_wrist_position[1] = m_elbow_position[1] + m_l_ulna * sin(m_angle_ulna);

    // Find phalanx tip
    m_phalanx_position[0] = m_wrist_position[0] + m_l_hand * cos(m_angle_hand);
    m_phalanx_position[1] = m_wrist_position[1] + m_l_hand * sin(m_angle_hand);

    place_plumage();
  }

  void place_plumage()
  {
    int n_feathers = n_primaries + n_secondaries;
    m_plumage = new Feather[n_feathers];
    float[][] roots = new float[n_feathers][2];
    float[][] tips = new float[n_feathers][2];

    // Place primary feather roots
    for (int i = 0; i < n_primaries; ++i) {
      float spacing = m_l_hand / (n_primaries + 1);
      float[] feather_root = {
        m_wrist_position[0] + (i + 1) * spacing * cos(m_angle_hand),
        m_wrist_position[1] + (i + 1) * spacing * sin(m_angle_hand)
      };
      roots[i] = feather_root;
    }

    // Place secondary feather roots
    for (int i = 0; i < n_secondaries; ++i) {
      float spacing = m_l_ulna / (n_secondaries + 1);
      float[] feather_root = {
        m_elbow_position[0] + (i + 1) * spacing * cos(m_angle_ulna),
        m_elbow_position[1] + (i + 1) * spacing * sin(m_angle_ulna)
      };
      roots[n_primaries + i] = feather_root;
    }
    
    // Place primary feather tips
    float[] first_tip = {
      roots[n_primaries - 1][0] + l_primaries * cos(m_angle_hand + angle_hand_first_primary),
      roots[n_primaries - 1][1] + l_primaries * sin(m_angle_hand + angle_hand_first_primary)
    };
    tips[n_primaries - 1] = first_tip;
    
    float[] last_tip = {
      roots[0][0] + l_primaries * cos(m_angle_hand + angle_hand_last_primary),
      roots[0][1] + l_primaries * sin(m_angle_hand + angle_hand_last_primary)
    };
    tips[0] = last_tip;
    
    for (int i = n_primaries - 2; i > 0; --i) {      
      float[] feather_tip = {
        roots[i][0] + l_primaries * cos(deg_to_rad(90.0)),
        roots[i][1] + l_primaries * sin(deg_to_rad(90.0))
      };
      tips[i] = feather_tip;
    }
    
    // Place secondary feather tips
    for (int i = 0; i < n_secondaries; ++i) {
      float[] feather_tip = {
        roots[n_primaries + i][0] + l_secondaries * cos(deg_to_rad(90.0)),
        roots[n_primaries + i][1] + l_secondaries * sin(deg_to_rad(90.0))
      };
      tips[n_primaries + i] = feather_tip;
    }

    for (int i = 0; i < n_feathers; ++i) {
      m_plumage[i] = new Feather(roots[i], tips[i]);
    }
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
    // Draw hand
    stroke(col_hand);
    line(
      m_wrist_position[0], m_wrist_position[1],
      m_phalanx_position[0], m_phalanx_position[1]
      );

    stroke(col_primaries);
    for (int i = 0; i < n_primaries; ++i) {
      m_plumage[i].draw();
    }
    stroke(col_secondaries);
    for (int i = 0; i < n_secondaries; ++i) {
      m_plumage[n_primaries + i].draw();
    }
  }
}

class Feather {
  float[] m_root, m_tip;
  Feather(float[] root, float[] tip)
  {
    m_root = root;
    m_tip = tip;
  }
  void draw()
  {
    line(m_root[0], m_root[1], m_tip[0], m_tip[1]);
  }
}

float deg_to_rad(float angle_degrees)
{
  return angle_degrees * PI / 180.0;
}
