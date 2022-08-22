// Grid setup
int nb_cols = 40;
int nb_rows = 40;
int cell_width = 10;
int cell_height = 10;
int[][] grid = new int[nb_cols][nb_rows];

color[] palette = {
  // Retro synthwave
  #3F2A56,
  #E0457B,
  #ED9B33,
  #5461C8,
  #7A93DC,
  #051C2C
};

int nb_colours = palette.length;

void settings() {
  size(nb_cols * cell_width, nb_rows * cell_height);
}

// Landscape parameters
  float mu_x = width / 2.0;
  float mu_y = height / 2.0;
  float sigma_x = 10.0;
  float sigma_y = 10.0;
  float gaussian_h = nb_colours;

void setup() {
  background(234); // for debug, should not be seen
  
  // Fill cell heights
  for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     float c_avg_x = (i + 0.5) * cell_width;
     float c_avg_y = (j + 0.5) * cell_height;

     float c_h = gaussian_2d(c_avg_x, c_avg_y);
     //c_h *= palette.length; // scale t
     grid[i][j] = round(c_h);
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
 //saveFrame("synthwave_grid.png");
}

float gaussian_2d(float x, float y) {
  float x_kernel = sq(x - mu_x) / (2.0 * sq(sigma_x));
  float y_kernel = sq(y - mu_y) / (2.0 * sq(sigma_y));
  return gaussian_h * exp(-(x_kernel + y_kernel));
}
