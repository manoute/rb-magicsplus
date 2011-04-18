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
end
