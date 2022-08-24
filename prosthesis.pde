// Grid setup
int nb_cols = 400;
int nb_rows = 400;
int cell_width = 1;
int cell_height = 1;
int[][] grid = new int[nb_cols][nb_rows];

int window_width = nb_cols * cell_width;
int window_height = nb_rows * cell_height;

color[] palette = {
  // Retro synthwave
  #3B9AB2,
  #78B7C5,
  #EBCC2A,
  #E1AF00,
  #F21A00
};

int nb_colours = palette.length;

void settings() {
  size(window_width, window_height);
}

// Landscape parameters
  float mu_x = window_width / 2.0;
  float mu_y = window_height / 2.0;
  float sigma_x = 40.0;
  float sigma_y = 30.0;
  float gaussian_h = nb_colours - 1;
  float theta = 2.0 / 3.0 * PI;
  
void setup() {
  background(234); // for debug, should not be seen
  
  // Fill cell heights
  for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     float c_avg_x = (i + 0.5) * cell_width;
     float c_avg_y = (j + 0.5) * cell_height;

     float c_h = gaussian_2d(c_avg_x, c_avg_y);
     //c_h *= palette.length; // scale t
     int c_h_int =  round(c_h);
     grid[i][j] = c_h_int;
   }
 }
 
}

void draw() {
  for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     color cell_colour = palette[grid[i][j]];
     stroke(cell_colour);
     fill(cell_colour);
     rect(i * cell_width, j * cell_height, cell_width, cell_height);
   }
 }
 //saveFrame("gaussian_2d.png");
}

float gaussian_2d(float x, float y) {
  float x_diff = x - mu_x;
  float y_diff = y - mu_y;
  float fct_a = sq(cos(theta)) / (2 * sq(sigma_x)) + sq(sin(theta)) / (2 * sq(sigma_y));
  float fct_b = sin(2 * theta) / (4 * sq(sigma_x)) + sin(2 * theta) / (4 * sq(sigma_y));
  float fct_c = sq(sin(theta)) / (2 * sq(sigma_x)) + sq(cos(theta)) / (2 * sq(sigma_y));

  return gaussian_h * exp(-(fct_a * sq(x_diff) + 2 * fct_b * x_diff * y_diff + fct_c * sq(y_diff)));
}
