require 'spec_helper'
require 'fileutils'

if narray_installed

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


    describe "NArray" do
      it '1D narray of int and 1D array of float work' do
        set1d_helper({:output_file => @output_file, 
                      :ypos => NArray[42.0, 52.0, 62.0],
                      :xpos => NArray[22.0, 12.0, 2.0],
                      :markers => NArray[3, 3, 3]})
        @output_file.should be_the_same_ps_file(@symb_file)
      end

      it '2D narray of float work' do
        data = NArray.float(360,181)
        (0..180).each {|j| (0...360).each {|i| data[i,j] = i }}

        levels = NArray.float(360)
        360.times {|e| levels[e] = (160.0 + e/4.0)}
        colors = NArray.object(360)
        360.times {|i| colors[i] = "HSL(#{i}, 0.5, 0.5)"}
        set2d_helper({:output_file => @output_file, :levels => levels, 
                      :colors => colors, :data => data})

        @output_file.should be_the_same_ps_file(@array2D_file)
      end
    end
  end
end
