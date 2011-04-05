require 'rmagics++'

MagicsPlus::Base.open do |m|
  m.output_name = "graph"
  m.output_format = "pdf"

  m.new_subpage do |s|
    s.subpage_x_length = 10.0
    s.subpage_y_length = 10.0
    s.subpage_map_projection = "cartesian"
  end

  m.axis do 
    m.axis_orientation = 'horizontal'
    m.axis_position = 'bottom'
    m.axis_grid = 'on'
    m.axis_grid_colour = "grey"
    m.axis_grid_line_style = "dash"
    m.axis_min_value = 0.0
    m.axis_max_value = 10.0
  end

  m.axis do
    m.axis_orientation = 'vertical'
    m.axis_position = 'left'
    m.axis_grid = 'on'
    m.axis_min_value = 0.0
    m.axis_max_value = 100.0
  end

  m.graph do
    x=[]
    y=[]
    y2=[]
    (0..10).each do |v|
      x << v * 1.0
      y << v * v * 1.0
      y2 << v + 20.0
    end

    m.graph_type = "area"
    m.graph_line_colour = "red"
    m.graph_curve_x_values = x
    m.graph_curve_y_values = y
    m.graph_curve2_x_values = x
    m.graph_curve2_y_values = y2
  end
end
