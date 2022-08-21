int nb_cols;
int nb_rows;
int[][] grid;

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

void setup() {
  size(500, 500);
  nb_cols = width;
  nb_rows = height;
  grid = new int[nb_cols][nb_rows];

// Fill cell heights
 for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     grid[i][j] = int(random(nb_colours - 1));
   }
 }
 
}

void draw() {
  for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     int cell_height = grid[i][j];
     color cell_colour = palette[cell_height];
     stroke(cell_colour);
     point(i, j);
   }
 }
}
