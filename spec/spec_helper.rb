require 'rspec' 
require 'rmagics++'

def narray_installed
  begin
    require 'narray'
    true
  rescue LoadError
    puts "\nnarray not found, narray tests won't be run."
    false
  end
end

RSpec::Matchers.define :be_the_same_ps_file do |file1|
  match do |file|
    output = open(file,"r") {|f| f.readlines} 
    expected = open(file1,"r") {|f| f.readlines} 
    ((output - expected).length <= 1) && ((expected - output).length <= 1) 
  end

  failure_message_for_should do |file|
    "expected file #{file} to be identical to #{file1}"
  end

  failure_message_for_should_not do |file|
    "expected file #{file} to be different from #{file1}"
  end
end

def set1d_helper(options)
  MagicsPlus::Base.open do |m|
    m.page_id_line = 'off'
    m.output_fullname = options[:output_file]
    m.subpage_lower_left_latitude = 30.0
    m.subpage_lower_left_longitude = -20.0
    m.subpage_upper_right_latitude = 70.0
    m.subpage_upper_right_longitude = 30.0
    m.symbol_type = 'marker'
    m.symbol_height = 1.5
    m.symbol_input_y_position = options[:ypos]
    m.symbol_input_x_position = options[:xpos]
    m.symbol_input_marker_list = options[:markers]
    m.symb
    m.coast
  end
end

def set2d_helper(options)
  MagicsPlus::Base.open do |m|
    m.page_id_line = 'off'
    m.output_fullname = options[:output_file]
    m.subpage_lower_left_latitude = 30.0
    m.subpage_lower_left_longitude = -20.0
    m.subpage_upper_right_latitude = 70.0
    m.subpage_upper_right_longitude = 30.0

    m.input_field_initial_longitude = -180.0
    m.input_field_longitude_step = 1.0
    m.input_field_initial_latitude = -90.0
    m.input_field_latitude_step = 1.0

    m.input_field = options[:data]

    m.contour = "off"
    m.contour_label = "off"
    m.contour_shade = "on"
    m.contour_shade_method = "area_fill"

    m.contour_level_selection_type =  "level_list"
    m.contour_shade = "on"
    m.contour_shade_method = "area_fill"
    m.contour_shade_colour_method = "list"
    m.contour_level_list =  options[:levels]
    m.contour_shade_colour_list = options[:colors]

    m.cont 
    m.coast
  end
end
