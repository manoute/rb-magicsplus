# Write rmagics_raw.c that is used by extconf to build rmagics_raw.so
class RMagicsRawCWriter
  def initialize(with_narray = true)  
    @c_file = File.join(File.dirname(__FILE__),'rmagics_raw.c')
    @with_narray = with_narray
  end
  
  def simple_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}(VALUE self)
      {
        mag_#{func} ();
        return self;
      }

      # # #
  end

  def simple_func_list
    if (`magics-config --version` =~ /2.12/)
      %w{ open close coast grib test odb bufr legend import netcdf cont 
        obs raw image plot text wind symb boxplot pie graph axis geo 
        eps print info 
      }
    else
      %w{ open close coast grib test odb import netcdf cont 
        obs raw image plot text wind symb boxplot pie graph axis geo 
        eps print info 
      }
    end
  end
  
  def one_string_arg_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}(VALUE self, VALUE param )
      {
        mag_#{func} (StringValuePtr(param));
        return self;
      }

      # # #
  end

  def one_string_arg_func_list
    %w{new reset}
  end

  def one_string_arg_func_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}", r_#{func}, 1);\n|
  end

  def string_int_args_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}(VALUE self, VALUE str, VALUE ivalue )
      {
        mag_#{func} (StringValuePtr(str), FIX2UINT(ivalue) );
        return self;
      }

      # # #
  end

  def string_double_args_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}(VALUE self, VALUE str, VALUE rvalue )
      {
        mag_#{func} (StringValuePtr(str), NUM2DBL(rvalue) );
        return self;
      }

      # # #
  end

  def string_double_args_func_list
    %w{setr enqr}
  end

  def string_int_args_func_list
    %w{seti enqi}
  end

  def two_string_args_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}(VALUE self, VALUE str1, VALUE str2 )
      {
        mag_#{func} (StringValuePtr(str1), StringValuePtr(str2));
        return self;
      }

      # # #
  end

  def two_string_args_func_list
    %w{setc enqc}
  end

  def array_1d_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}_array(VALUE self, VALUE param, VALUE cvalue, VALUE ivalue )
      {
        mag_#{func} (StringValuePtr(param), StringValuePtr(cvalue), FIX2UINT(ivalue));
        return self;
      }

      # # #
  end


  def array_1d_functions
    %w{set1i set1r}
  end

  def array_1D_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}_array", r_#{func}_array, 3);\n|
  end

  def narray_1d_func(func,type)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}_narray(VALUE self, VALUE param, VALUE na1value)
      {
        mag_#{func} (StringValuePtr(param), 
          NA_PTR_TYPE(na1value, #{type}*), NA_SHAPE0(na1value));
        return self;
      }

      # # #
  end


  def narray_1d_functions
    {'set1i' => 'int', 'set1r' => 'double'}
  end

  def narray_1D_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}_narray", r_#{func}_narray, 2);\n|
  end

  def narray_2d_func(func,type)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}_narray(VALUE self, VALUE param, VALUE na2value)
      {
        mag_#{func} (StringValuePtr(param), 
          NA_PTR_TYPE(na2value, #{type}*), 
          NA_SHAPE0(na2value), NA_SHAPE1(na2value));
        return self;
      }

      # # #
  end


  def narray_2d_functions
    {'set2i' => 'int', 'set2r' => 'double'}
  end

  def narray_2D_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}_narray", r_#{func}_narray, 2);\n|
  end



  def array_1d_string_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}_array(VALUE self, VALUE param, VALUE c1value, VALUE ivalue )
      {
        int size = FIX2UINT(ivalue);
        int i;
        VALUE *p;
        p = RARRAY_PTR(c1value);
        char **c1array = (char **) malloc((size+1)*sizeof(char *));
        for (i=0; i < size; i++, p++) {
          c1array[i] = StringValuePtr(*p);
        }
          mag_#{func} (StringValuePtr(param), c1array, size);
        return self;
      }

      # # #
  end

  def array_1d_string_functions
    %w{set1c}
  end

  def array_1D_string_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}_array", r_#{func}_array, 3);\n|
  end



  def array_2d_func(func)
    <<-"# # #".gsub(/^\s{6}/,"")
      VALUE r_#{func}_array(VALUE self, VALUE param, VALUE cvalue, VALUE ivalue, VALUE jvalue )
      {
        mag_#{func} (StringValuePtr(param), StringValuePtr(cvalue), FIX2UINT(ivalue), FIX2UINT(jvalue));
        return self;
      }

      # # #
  end

  def array_2d_functions
    %w{set2i set2r}
  end

  def array_2D_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}_array", r_#{func}_array, 4);\n|
  end



  def two_args_func_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}", r_#{func}, 2);\n|
  end

  def two_args_functions
    two_string_args_func_list + string_int_args_func_list + 
      string_double_args_func_list
  end

  def simple_func_define_method(func)
    %Q|  rb_define_module_function(mMagicsRaw, "mag_#{func}", r_#{func}, 0);\n|
  end

  def write_module_begin
    <<-"# # #".gsub(/^\s{6}/,"")
      void Init_rmagics_raw()
      {
        mMagics = rb_define_module("MagicsPlus");
        mMagicsRaw = rb_define_module_under(mMagics,"Raw");
    # # #
  end

  def write_module_end
    '}'
  end

  def write
    File.open(@c_file,'w') do |f|
      f << %Q{#include <string.h> \n#include <ruby.h> \n\n}
      if @with_narray
        f << %Q{#include <narray.h>  \n\n} 
      end
      f << %Q{static VALUE mMagics; \nstatic VALUE mMagicsRaw;\n\n}
      simple_func_list.each {|s| f << simple_func(s)}
      one_string_arg_func_list.each {|s| f << one_string_arg_func(s)}
      two_string_args_func_list.each {|s| f << two_string_args_func(s)}
      string_int_args_func_list.each {|s| f << string_int_args_func(s)}
      string_double_args_func_list.each {|s| f << string_double_args_func(s)}
      array_1d_functions.each {|s| f << array_1d_func(s)}      
      array_1d_string_functions.each {|s| f << array_1d_string_func(s)}      
      array_2d_functions.each {|s| f << array_2d_func(s)}      
      if @with_narray
        narray_1d_functions.each do |func,type|
          f << narray_1d_func(func, type) 
        end
        narray_2d_functions.each do |func,type|
          f << narray_2d_func(func, type) 
        end
      end
      f << write_module_begin 
      simple_func_list.each {|s| f << simple_func_define_method(s)}
      one_string_arg_func_list.each do |s| 
        f << one_string_arg_func_define_method(s)
      end
      two_args_functions.each do |s| 
        f << two_args_func_define_method(s)
      end
      array_1d_functions.each {|s| f << array_1D_define_method(s)}
      array_1d_string_functions.each {|s| f << array_1D_string_define_method(s)}
      array_2d_functions.each {|s| f << array_2D_define_method(s)}
      if @with_narray
        narray_1d_functions.each {|s,v| f << narray_1D_define_method(s)} 
        narray_2d_functions.each {|s,v| f << narray_2D_define_method(s)} 
      end
      f << write_module_end 
    end
  end
end


