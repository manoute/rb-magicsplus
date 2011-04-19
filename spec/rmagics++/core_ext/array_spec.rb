require 'spec_helper'
require 'fileutils'

ENV["MAGPLUS_QUIET"] = "yes"
describe MagicsPlus::Base do
  before do
    @output_file = File.join(File.dirname(__FILE__),"../../data","sample.ps")
    @array2D_file = File.join(File.dirname(__FILE__),"../../data","2D.ps")
    @symb_file = File.join(File.dirname(__FILE__),"../../data","symb.ps")
  end

  after do
    File.delete @output_file if File.exists? @output_file
  end

  describe 'Ruby Array' do
    it '1D array of int and 1D array of float work' do
      set1d_helper({:output_file => @output_file, 
                    :ypos => [42.0, 52.0, 62.0],
                    :xpos => [22.0, 12.0, 2.0],
                    :markers => [3, 3, 3]})
      @output_file.should be_the_same_ps_file(@symb_file)
    end

    it '2D array of float and 1D array of string work' do
      data = []
      (0..180).each {|i| data << (360.times.inject([]){|r,e| r << (e*1.0)})}

      levels = 360.times.inject([]) {|a,e| a << (160.0 + e/4.0)}
      colors = 360.times.inject([]) {|a,e| a << "HSL(#{e}, 0.5, 0.5)"}

      set2d_helper({:output_file => @output_file, :levels => levels, 
                    :colors => colors, :data => data})
      @output_file.should be_the_same_ps_file(@array2D_file)
    end
  end
end
