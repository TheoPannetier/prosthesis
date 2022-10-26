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
float l_primary_coverts = 50.0;
float l_secondary_coverts = 50.0;

// Colours
color col_humerus = #35bfd7;
color col_ulna = #e8656a;
color col_hand = #2d9003;
color col_rachis_primaries = #f15025;
color col_rachis_secondaries = #44cef6;
color col_vane_primaries = #657065;
color col_vane_secondaries = #b1c0bf;
color col_primary_coverts = #0078d4;
color col_secondary_coverts = #ed2226;

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
    angle_hand_first_primary, angle_ulna_last_secondary,
    l_primary_coverts, col_primary_coverts, 
    l_secondary_coverts, col_secondary_coverts
    );
}

void draw() {
  bird_wing.draw();
}
