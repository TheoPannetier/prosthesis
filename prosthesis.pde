size(500, 500);
int nb_cols = width;
int nb_rows = height;
int[][] grid = new int[nb_cols][nb_rows];

//void setup() {
 //size(nb_cols, nb_rows);
 for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     grid[i][j] = int(random(0, 255));
   }
 }
//}

//void draw() {
  for (int i = 0; i < nb_cols; i++) {
   for (int j = 0; j < nb_rows; j++) {
     stroke(grid[i][j]);
     point(i, j);
   }
 }
//}
