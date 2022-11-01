class Feather {
  float[] m_root, m_tip;
  color m_rachis_color, m_vane_color;
  float m_vane_rel_origin;
  float m_vane_rel_length;
  float m_vane_rel_width;
  float m_rachis_length;
  float m_angle;

  Feather(float[] root, float[] tip, 
          color rachis_col, color vane_col,
          float vane_rel_origin,
          float vane_rel_length,
          float vane_rel_width
          )
  {
    m_root = root;
    m_tip = tip;
    m_rachis_color = rachis_col;
    m_vane_color = vane_col;
    m_rachis_length = dist(m_root[0], m_root[1], m_tip[0], m_tip[1]);
    m_angle = acos((m_tip[0] - m_root[0]) / m_rachis_length);
    m_vane_rel_origin = vane_rel_origin;
    m_vane_rel_length = vane_rel_length;
    m_vane_rel_width = vane_rel_width;
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
