require 'spec_helper'
require 'fileutils'

ENV["MAGPLUS_QUIET"] = "yes"
describe MagicsPlus::Base do
  before do
    @grib_file = File.join(File.dirname(__FILE__),"../data","z500.grb")
    @output_file = File.join(File.dirname(__FILE__),"../data","sample.ps")
    @output_file1 = File.join(File.dirname(__FILE__),"../data","sample1.ps")
    @grib_visu = File.join(File.dirname(__FILE__),"../data","z500.ps")
    @array2D_file = File.join(File.dirname(__FILE__),"../data","2D.ps")
    @symb_file = File.join(File.dirname(__FILE__),"../data","symb.ps")
  end

  after do
    File.delete @output_file1 if File.exists? @output_file1
    File.delete @output_file if File.exists? @output_file
  end

  it "equivalent function of Raw mag_foo is foo" do
    MagicsPlus::Base.respond_to?(:plot).should be_true
  end

  describe 'except for mag_new' do
    it "mag_new equivalent isn't new" do
      MagicsPlus::Base.respond_to?(:new).should be_false
    end
    
    it 'new_page is equivalent to mag_new("page")' do
      MagicsPlus::Base.respond_to?(:new_page).should be_true
    end

    it 'new_subpage is equivalent to mag_new("subpage")' do
      MagicsPlus::Base.respond_to?(:new_subpage).should be_true
    end

    it 'new_super_page is equivalent to mag_new("super_page")' do
      MagicsPlus::Base.respond_to?(:new_super_page).should be_true
    end
  end

  describe "possibilities to set parameters" do
    before do
      MagicsPlus::Base.open do |m|
        m.setc("output_fullname",@output_file1)
        m.setr('subpage_upper_right_latitude',30.0)
        m.coast
      end
    end

    it "new_subpage (and others...) accept a hash" do
      MagicsPlus::Base.open do |m|
        m.setc("output_fullname",@output_file)
        m.new_subpage({:subpage_upper_right_latitude => 30.0})
        m.coast
      end
      @output_file.should be_the_same_ps_file(@output_file1)
    end

    it "param = foo act like set..('param',foo)" do
      MagicsPlus::Base.open do |m|
        m.setc("output_fullname",@output_file)
        m.subpage_upper_right_latitude = 30.0
        m.coast 
      end
      @output_file.should be_the_same_ps_file(@output_file1)
    end

    it "new_subpage (and others...) accept a block" do
      MagicsPlus::Base.open do |m|
        m.setc("output_fullname",@output_file)
        m.new_subpage do |c|
          c.subpage_upper_right_latitude = 30.0
        end
        m.coast
      end
      @output_file.should be_the_same_ps_file(@output_file1)
    end
  end

  describe 'Params hash'  do
    it 'is empty after first open and before any settings methods' do
      MagicsPlus::Base.open.params.should == {}
    end

    it 'is then filled with parameters settings provided to Magics++' do

      MagicsPlus::Base.open
      MagicsPlus::Base.setc("output_fullname",@output_file)
      MagicsPlus::Base.setr('subpage_lower_left_latitude', 30.0)
      MagicsPlus::Base.params.should == {:subpage_lower_left_latitude => 30.0,
        :output_fullname => @output_file} 
      MagicsPlus::Base.coast
      MagicsPlus::Base.close
    end

    context 'calling close' do
      it 'is empty just before close' do
        MagicsPlus::Base.open do |m|
          m.setc("output_fullname",@output_file)
          m.setr('subpage_lower_left_latitude', 30.0)
          m.coast
        end
        MagicsPlus::Base.params.should == {}
      end

      it 'all parameters are reset to their default value just before close' do
        MagicsPlus::Base.open do |m|
          m.setc("output_fullname",@output_file)
          m.subpage_upper_right_latitude = 30.0
          m.coast 
        end

        MagicsPlus::Base.open do |m|
          m.setc("output_fullname",@output_file1)
          m.coast 
        end
        @output_file.should_not be_the_same_ps_file(@output_file1)
      end
    end

    context 'calling close(false)' do
      it 'params hash is kept in memory' do
        MagicsPlus::Base.open(false) do |m|
          m.setc("output_fullname",@output_file)
          m.subpage_lower_left_latitude = 30.0
          m.coast
        end
        MagicsPlus::Base.params.should == {:subpage_lower_left_latitude => 30.0,
          :output_fullname => @output_file} 
        MagicsPlus::Base.open {|m| m.coast}
      end

      it 'parameters are not reset to their default value just before close' do
        MagicsPlus::Base.open(false) do |m|
          m.setc("output_fullname",@output_file)
          m.subpage_upper_right_latitude = 30.0
          m.coast 
        end

        MagicsPlus::Base.open do |m|
          m.setc("output_fullname",@output_file1)
          m.coast 
        end
        @output_file.should be_the_same_ps_file(@output_file1)
      end
    end
  end

  describe 'Ruby Array' do
    it '1D array of int and 1D array of float work' do
      MagicsPlus::Base.open do |m|
        m.page_id_line = 'off'
        m.output_fullname = @output_file
        m.subpage_lower_left_latitude = 30.0
        m.subpage_lower_left_longitude = -20.0
        m.subpage_upper_right_latitude = 70.0
        m.subpage_upper_right_longitude = 30.0
        m.symbol_type = 'marker'
        m.symbol_height = 1.5
        m.symbol_input_y_position = [42.0, 52.0, 62.0]
        m.symbol_input_x_position = [22.0, 12.0, 2.0]
        m.symbol_input_marker_list = [3, 3, 3]
        m.symb
        m.coast
      end
      @output_file.should be_the_same_ps_file(@symb_file)
    end

    it '2D array of float and 1D array of string work' do
      MagicsPlus::Base.open do |m|
        m.page_id_line = 'off'
        m.output_fullname = @output_file
        m.subpage_lower_left_latitude = 30.0
        m.subpage_lower_left_longitude = -20.0
        m.subpage_upper_right_latitude = 70.0
        m.subpage_upper_right_longitude = 30.0

        m.input_field_initial_longitude = -180.0
        m.input_field_longitude_step = 1.0
        m.input_field_initial_latitude = -90.0
        m.input_field_latitude_step = 1.0

        data = []
        (0..180).each {|i| data << (360.times.inject([]){|r,e| r << (e*1.0)})}

        m.input_field = data

        m.contour = "off"
        m.contour_label = "off"
        m.contour_shade = "on"
        m.contour_shade_method = "area_fill"

        levels = 360.times.inject([]) {|a,e| a << (160.0 + e/4.0)}
        colors = 360.times.inject([]) {|a,e| a << "HSL(#{e}, 0.5, 0.5)"}

        m.contour_level_selection_type =  "level_list"
        m.contour_shade = "on"
        m.contour_shade_method = "area_fill"
        m.contour_shade_colour_method = "list"
        m.contour_level_list =  levels
        m.contour_shade_colour_list = colors

        m.cont 
        m.coast
      end
      @output_file.should be_the_same_ps_file(@array2D_file)
    end

  end
  context "invalid array" do
    it "set_ary should raise an exception" do
      MagicsPlus::Base.open 
      MagicsPlus::Base.setc("output_fullname",@output_file)
      expect {
        MagicsPlus::Base.set_ary("contour_level_list",Object.new)
      }.to raise_error(TypeError)
      MagicsPlus::Base.coast
      MagicsPlus::Base.close
    end
  end

=begin
  if narray_installed
    context "NArray" do
      it "set1r should work with narray" do
        MagicsPlus::Base.open do |c|
          c.plot_basic(@output_file)
          c.plot_grib(@grib_file) do
            c.set1r("contour_level_list",NArray.float(40).indgen!(530,1))
          end
        end
        @output_file.should be_the_same_ps_file(@grib_visu)
      end

      it "set2r should work with narray" do
        MagicsPlus::Base.open do |c|
          c.plot_basic(@output_file)
          c.plot2D do
            data=NArray.float(360,181).indgen!
            (0..359).each do |x|
              (0..180).each {|y| data[x,y] = x}
            end
            c.set2r('input_field', data)
          end

        end
        @output_file.should be_the_same_ps_file(@array2D_visu)
      end

      it "set1i should work with narray" do
        MagicsPlus::Base.open do |c|
          c.plot_basic(@output_file)
          c.setc("symbol_type","marker")
          c.set1r("symbol_input_x_position",NArray.float(4).indgen!(1.0,1))
          c.set1r("symbol_input_y_position",NArray[44.0, 51.0,52.0,53.0])
          c.set1i("symbol_input_marker_list",NArray.int(4).fill(3))
          c.setr("symbol_height",1.0)
          c.symb
          c.coast
        end
        @output_file.should be_the_same_ps_file(@symb_visu)
      end
    end
  end

  context "Ruby Array" do
    it "set1r should work with ruby array" do
      MagicsPlus::Base.open do |c|
        c.plot_basic(@output_file)
        c.plot_grib(@grib_file) do
          c.set1r("contour_level_list",
            (530..569).inject([]) {|a,e| a << e })
        end
      end
      @output_file.should be_the_same_ps_file(@grib_visu)
    end

    it "set2r should work with ruby array" do
      MagicsPlus::Base.open do |c|
        c.plot_basic(@output_file)
        c.plot2D do
          data = []
          (0..180).each {|i| data << (360.times.inject([]){|r,e| r << e})}
          c.set2r('input_field', data)
        end

      end
      @output_file.should be_the_same_ps_file(@array2D_visu)
    end

    it "set1i should work with ruby array" do
      MagicsPlus::Base.open do |c|
        c.plot_basic(@output_file)
        c.setc("symbol_type","marker")
        c.set1r("symbol_input_x_position",[1.0, 2.0, 3.0,4.0])
        c.set1r("symbol_input_y_position",[44.0, 51.0,52.0,53.0])
        c.set1i("symbol_input_marker_list",[3,3,3,3])
        c.setr("symbol_height",1.0)
        c.symb
        c.coast
      end
      @output_file.should be_the_same_ps_file(@symb_visu)
    end
  end

=end
end
