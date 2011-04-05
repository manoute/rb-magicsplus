require 'fileutils'
require 'rspec/core/rake_task'

namespace :test do 

  desc "Generate data needed for rspec then run rspec"
  task :all => [:generale_all_ps_files, :spec]

  desc "Run specs"
  RSpec::Core::RakeTask.new 

  desc "Generate all ps file needed for tests"
  task :generale_all_ps_files => [:generate_simple, :generate_symb, 
                                  :generate_2d]

  desc "Generate simple.ps" 
  task :generate_simple do |t|
    simple_c = <<-HERE
      int main()
      {
          mag_open ();
          mag_setc ("output_format","ps");
          mag_setc ("page_id_line","off");
          mag_setc ("output_name","simple");
          mag_setr ("subpage_lower_left_latitude",30.0);
          mag_coast ();
          mag_close ();

          return 0;
      }

    HERE
    File.open('simple.c','w') {|f| f << simple_c}
    `magics-config --compile=simple.c --suffix=c`
    `./simple`
    FileUtils.mv 'simple.ps', './spec/data/'
    File.delete 'simple.c'
    File.delete 'simple'
  end

  desc "Generate symb.ps" 
  task :generate_symb do |t|
    symb_c = <<-HERE
      int main()
      {
          double y_pos[3] = {42.0, 52.0, 62.0}; 
          double x_pos[3] = {22.0, 12.0, 2.0} ;
          int marks[3] = {3, 3, 3} ;
          mag_open ();
          mag_setc ("output_format","ps");
          mag_setc ("page_id_line","off");
          mag_setc ("output_name","symb");
          mag_setr ("subpage_lower_left_latitude",30.0);

          mag_setr ("subpage_lower_left_latitude",30.0);
          mag_setr ("subpage_lower_left_longitude",-20.0);
          mag_setr ("subpage_upper_right_latitude",70.0);
          mag_setr ("subpage_upper_right_longitude",30.0);
          mag_setc ("symbol_type","marker");
          mag_setr ("symbol_height",1.5);
          mag_set1r ("symbol_input_y_position", y_pos, 3);
          mag_set1r ("symbol_input_x_position", x_pos, 3);
          mag_set1i ("symbol_input_marker_list", marks, 3);
          mag_symb ();
     
          mag_coast ();
          mag_close ();

          return 0;
      }

    HERE
    File.open('symb.c','w') {|f| f << symb_c}
    `magics-config --compile=symb.c --suffix=c`
    `./symb`
    FileUtils.mv 'symb.ps', './spec/data/'
    File.delete 'symb.c'
    File.delete 'symb'
  end

  desc "Generate 2D.ps" 
  task :generate_2d do |t|
    two_dim_c = <<-HERE
      #include <stdio.h>
      int main()
      {
          int i,j;
          double data[181][360];
          char color_list[360][20];
          char *color[360] ;
          double level_list[360];

          for (j=0; j < 360; j++) {
            sprintf(color_list[j],"HSL(%d, 0.5, 0.5)", j) ;
            color[j] = color_list[j];
            level_list[j] = 160.0 + j/4.0;
          }

          for (i=0; i < 181; i++)
            for (j=0; j < 360; j++) {
              data[i][j] = j;
          }

          mag_open ();
          mag_setc ("output_format","ps");
          mag_setc ("page_id_line","off");
          mag_setc ("output_name","2D");

          mag_setr ("subpage_lower_left_latitude",30.0);
          mag_setr ("subpage_lower_left_longitude",-20.0);
          mag_setr ("subpage_upper_right_latitude",70.0);
          mag_setr ("subpage_upper_right_longitude",30.0);

          mag_setr ("input_field_initial_longitude",-180.0);
          mag_setr ("input_field_longitude_step",1.0);
          mag_setr ("input_field_initial_latitude",-90.0);
          mag_setr ("input_field_latitude_step",1.0);
          mag_set2r ("input_field", data, 360, 181);

          mag_setc ("contour","off");
          mag_setc ("contour_label","off");
          mag_setc ("contour_level_selection_type", "level_list");
          mag_setc ("contour_shade","on");
          mag_setc ("contour_shade_method","area_fill");
          mag_setc ("contour_shade_colour_method","list");
          mag_set1r("contour_level_list", level_list, 360);
          mag_set1c("contour_shade_colour_list",color, 360);
 
          mag_cont ();
          mag_coast ();
          mag_close ();

          return 0;
      }

    HERE
    File.open('two_dim.c','w') {|f| f << two_dim_c}
    `magics-config --compile=two_dim.c --suffix=c`
    `./two_dim`
    FileUtils.mv '2D.ps', './spec/data/'
    File.delete 'two_dim.c'
    File.delete 'two_dim'
  end
end



