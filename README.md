rb-magicsplus
=================
[homepage](https://github.com/manoute/rb-magicsplus)

DESCRIPTION
-----------

Ruby wrappers for magics++.
[Magics++](http://www.ecmwf.int/products/data/software/magics++.html) is the latest generation of the [ECMWF](http://www.ecmwf.int)'s Meteorological plotting software.
Works with Ruby 1.8.7 or 1.9.2 and Rubinius, but not with Jruby and others ruby implementations that don't support C extensions written for Ruby (for these, you can try ffi-magics++ that use ffi... however, this last gem is not always working...)

FEATURES
--------

**Close to Magics++ C api :** just remove mag_ from C functions : 

    // With C api
    mag_open  
    mag_coast 
    ...

    # With Ruby Api
    MagicsPlus::Base.open
    MagicsPlus::Base.coast
    ...

**Except :**

  - mag_new :

        // C api
        mag_new(superpage)
        mag_new(page)
        ...
        
        # Ruby api
        MagicsPlus::Base.new_page
        MagicsPlus::Base.new_super_page  
        ...

  - When setting array, use set_ary and don't provide dimensions :

        // C api
        mag_set1i("foo",array,12) 
        
        # Ruby api
        MagicsPlus::Base.set_ary("foo",array) 

  - After close, all parameters are reset to their default values, to avoid this behaviour, use close(false) or open(false) do ... end.

** Blocks can be given to open, enabling automatic close :**

        MagicsPlus::Base.open do |m|
          m.setc('output_filename','foo')
          ...
          m.coast
        end 

** Setting parameter can be done with = :**

        MagicsPlus::Base.subpage_upper_right_latitude = 30.0

** A hash and block can be given to methods :**
        
        # C-api like
        MagicsPlus::Base.setr('subpage_upper_right_latitude',30.0)
        MagicsPlus::Base.setr('subpage_upper_right_longitude',30.0)
        MagicsPlus::Base.new_subpage
        
        # Same thing with a hash
        MagicsPlus::Base.new_subpage({:subpage_upper_right_latitude => 30.0,
          :subpage_upper_right_longitude => 30.0})

        # Same thing with a block
        MagicsPlus::Base.new_subpage do |c|
          c.setr('subpage_upper_right_latitude',30.0)
          c.subpage_upper_right_longitude = 30.0
        end

** params hash is filled with the settings :**

        MagicsPlus::Base.open
        MagicsPlus::Base.subpage_lower_left_latitude = 30.0
        MagicsPlus::Base.params #  {:subpage_lower_left_latitude => 30.0}
        MagicsPlus::Base.reset_all # reset all parameters to their default value
        MagicsPlus::Base.params #  {}
    
** Works with ruby array or narray :**
    
        # With Ruby array
        MagicsPlus::Base.foo = [44.0, 51.0,52.0,53.0]

        # With NArray
        MagicsPlus::Base.foo = NArray[44.0, 51.0,52.0,53.0]

PROBLEMS
--------

Experimental.

Only tested with Magics++ Debian package and custom Archlinux package.


EXAMPLES
--------

Plotting an array of data

    require 'rubygems' # only with ruby 1.8
    require 'rmagics++'

    MagicsPlus::Base.open do |m|
     mc.setc("output_fullname",'2D.ps')

      # Block syntax
      m.new_subpage do |sub|
        sub.subpage_lower_left_latitude = 40.0
        sub.subpage_lower_left_longitude = -10.0
        sub.subpage_upper_right_latitude = 55.0
        sub.subpage_upper_right_longitude = 10.0
      end

      # C-api syntax
      m.setr("input_field_initial_longitude",-180.0)
      m.setr("input_field_longitude_step",1.0)
      m.setr("input_field_initial_latitude",-90.0)
      m.setr("input_field_latitude_step",1.0)
      data = []
      (0..180).each {|i| data << (360.times.inject([]){|r,e| r << e})}
      m.set_ary('input_field', data)

      # Hash syntax
      m.cont({:contour => 'off', :contour_label => 'off', 
        :contour_shade => 'on', :contour_shade_method => 'area_fill',
        :contour_level_count => 30})

      m.coast
    end


Using module as a mixing and plotting a grib file

    require 'rubygems' # optional, only with ruby 1.8.7
    require 'ffi-magics++'

    class Toto
      include MagicsPlus::Base

      def grib_plot
        open do
          self.output_fullname = 'foo.pdf'

          grib({:grib_input_type => 'file',
                :grib_input_file_name => 'foo.grb'})

          cont({:contour => 'on', :contour_shade => 'on',
                :contour_shade_method => 'area_fill'})
          
          coast
        end
      end
    end

    Toto.new.grib_plot



For other examples, see examples directory.

REQUIREMENTS
------------
* A ruby implementation ([RVM](http://rvm.beginrescueend.com) allows to easily install, manage and work with multiple ruby environments.)
* Magics++ must be installed :

      apt-get install magics++ 

      or have a look at Magics++ installation on their homepage.

* 'narray' is optionnal, but it needs to be installed before 'rb-magicsplus' if you want to use it.
* 'rake' is optional
* 'rspec' is optional 
* 'rake-compiler' is optional
* 'echoe' is optionnal

INSTALL
-------

If you want narray :

    [sudo] gem install narray

Then :

    [sudo] gem install rmagics++

 
RUNNING SPECS/TESTS
-------------------

'rspec' (version 2.xxx), 'rake'  and 'rake-compiler' are needed.
You may also have to had gem executable directory to $PATH (For exemple with debian ruby 1.8.7: export PATH=$PATH:/var/lib/gems/1.8/bin)

Somewhere within source tree :
* compile C extension :

    [RUBYOPT='rubygems'] rake compile
    
* Generate .ps files needed using C api :

    [RUBYOPT='rubygems'] rake test:generale_all_ps_files

* Run rspec :

    [RUBYOPT='rubygems'] rake test:spec

LICENSE
-------

(The MIT License)

Copyright (c) 2011 Mathieu Deslandes

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
