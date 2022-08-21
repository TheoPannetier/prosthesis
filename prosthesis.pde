int nb_cols = 50;
int nb_rows = 50;
int cell_width = 30;
int cell_height = 20;
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

void setup() {
  background(0); // but should not be seen
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
     color cell_colour = palette[grid[i][j]];
     stroke(cell_colour);
     fill(cell_colour);
     rect(i * cell_width, j * cell_height, cell_width, cell_height);
   }
 }
 //saveFrame("synthwave_grid.png");
}
