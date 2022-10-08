/*
  Processing port of http://www.playfuljs.com/realistic-terrain-in-130-lines/
  by Jerome Herr and Abe Pazos
*/

TerrainP5 t;

void setup() {
  size(900, 500);
  t = new TerrainP5(8);
  t.generate(0.7);
}

void draw() {
  background(#C1EDF2);
  t.draw();
}

void mousePressed() {
  t.generate(0.2);
}

void keyPressed() {
  if(key == 's') {
    saveFrame("####.jpg");
  }
}


class TerrainP5 {
  private final int tSize, tMax;
  private float[] tMap;
  private float tRoughness;

  TerrainP5(int detail) {
    tSize = int(pow(2, detail) + 1); // Array size in either dimension
    tMax = tSize - 1; // Array max index, also max height
    tMap = new float[tSize * tSize];
  }

  private float get_pix_val(int x, int y) {
    if (x < 0 || x > tMax || y < 0 || y > tMax) return -1;
    return tMap[x + tSize * y];
  }

  private void set_pix_val(int x, int y, float val) {
    tMap[x + tSize * y] = val;
  }

  public void generate(float roughness) {
    tRoughness = roughness;
    
    // Seed the algo by setting corner values
    set_pix_val(0, 0, tMax);
    set_pix_val(tMax, 0, tMax / 2);
    set_pix_val(tMax, tMax, 0);
    set_pix_val(0, tMax, tMax / 2);

    run_diamond_square_algo(tMax);
  }

  private void run_diamond_square_algo(int sz) {
    // The height-generating algo proper
    // it's a recursion
    int x, y, half = sz / 2;
    
    float scale = tRoughness * sz; // random height range
    // sz decreases with each call
    
    if (half < 1) return; // stop if can't divide anymore

    for (y = half; y < tMax; y += sz) {
      for (x = half; x < tMax; x += sz) {
        square(x, y, half, random(-scale, scale));
      }
    }
    for (y = 0; y <= tMax; y += half) {
      for (x = (y + half) % sz; x <= tMax; x += sz) {
        diamond(x, y, half, random(-scale, scale));
      }
    }
    run_diamond_square_algo(sz / 2);
  }

  private float average(float[] heights) {
    int nb_valid = 0;
    float sum = 0;
    for (int i = 0; i < heights.length; i++) {
      if (heights[i] != -1) {
        nb_valid++;
        sum += heights[i];
      }
    }
    return nb_valid == 0 ? 0 : sum / nb_valid;
  }

  private void square(int x, int y, int sz, float offset) {
    float avg_height = average(new float[] {
      get_pix_val(x - sz, y - sz), // upper left
      get_pix_val(x + sz, y - sz), // upper right
      get_pix_val(x + sz, y + sz), // lower right
      get_pix_val(x - sz, y + sz)  // lower left
    }
    );
    set_pix_val(x, y, avg_height + offset);
  }

  private void diamond(int x, int y, int sz, float offset) {
    float avg_height = average(new float[] {
      get_pix_val(x, y - sz), // top
      get_pix_val(x + sz, y), // right
      get_pix_val(x, y + sz), // bottom
      get_pix_val(x - sz, y)  // left
    }
    );
    set_pix_val(x, y, avg_height + offset);
  }

  public void draw() {
    float water_level = tSize * 0.3;

    for (int y = 0; y < tSize; y++) {
      for (int x = 0; x < tSize; x++) {
        float val = get_pix_val(x, y);
        PVector top = project(x, y, val);
        PVector bottom = project(x + 1, y, 0);
        PVector water = project(x, y, water_level);

        color c1 = tBrightness(x, y, get_pix_val(x + 1, y) - val);
        colorRect(top, bottom, c1);

        color water_colour = color(50, 150, 200, 256 * 0.15);
        colorRect(water, bottom, water_colour);
      }
    }
  }
  private void colorRect(PVector top, PVector bottom, color c) {
    if (bottom.y < top.y) return;
    noStroke();
    fill(c);
    rect(top.x, top.y, bottom.x - top.x, bottom.y - top.y);
  }

  private color tBrightness(float x, float y, float slope) {
    if (y == tMax || x == tMax) return color(0);
    return color(slope * 50 + 128);
  }

  private PVector iso(float x, float y) {
    return new PVector(0.5 * (tSize + x - y), 0.5 * (x + y));
  }

  private PVector project(float flatX, float flatY, float flatZ) {
    PVector point = iso(flatX, flatY);
    float x0 = width * 0.5;
    float y0 = height * 0.2;
    float z = tSize * 0.5 - flatZ + point.y * 0.75;
    float x = (point.x - tSize * 0.5) * 6;
    float y = (tSize - point.y) * 0.005 + 1;

    return new PVector(x0 + x/y, y0 + z/y);
  }
}
