require 'rmagics++/core_ext/array'
require 'rmagics++/core_ext/narray'
require 'rmagics++/core_ext/integer'
require 'rmagics++/core_ext/float'
require 'rmagics++/core_ext/string'
require 'rmagics_raw'

module MagicsPlus
  module Raw
    %W{page subpage super_page}.each do |p|
      define_method("mag_new_#{p}".to_sym) do 
        send(:mag_new,p)
      end
      module_function "mag_new_#{p}" 
    end
  end

  module Base
    module_function
    attr_accessor :params
    module_function :params

     
    def reset_all
      @params.each_key {|k| reset(k.to_s)}
      @params = {}
    end

    def close(params_reset = true)
      reset_all if params_reset
      Raw.mag_close
      self
    end

    def open(params_reset = true)
      Raw.mag_open
      @params ||= {}
      if block_given?
        begin
          yield self
          close(params_reset)
        rescue StandardError => e
          puts e.message
        end
      end
      self
    end

    def array_check(ary)
      unless ary.respond_to? :raw_params
        raise TypeError, "#{ary.class} need to respond to raw_params..."
      end
    end

    def set_ary(str,ary)
      array_check(ary)
      @params[str] = ary.raw_params[:params] 
      Raw.send(ary.raw_params[:name],str, *params[str])
      self
    end

    Raw.methods.each do |f|
      if f =~ /^mag_set(.*)$/ && !self.respond_to?("set#{$1}".to_sym) 
        define_method("set#{$1}".to_sym) do |*args|
          params[args[0].to_sym] = args[1]
          Raw.send(f.to_sym,*args)
          self
        end
        module_function("set#{$1}")
      end

      if f =~ /^mag_(.*)$/ && !self.respond_to?($1.to_sym) && $1 != 'new'
        define_method($1.to_sym) do |*args, &block|
          hash,*rest = *args
          if hash.respond_to? :each_pair
            hash.each_pair do |k,v|
              send(v.magics_set_name,k.to_s,v) 
            end
          else
            rest = args
          end
          block.call self if block
          Raw.send(f.to_sym,*rest)
          self
        end
        module_function("#{$1}")
      end
    end
    
    def method_missing(param,*args,&block)
      if (param.to_s =~ /=$/) && (args[0].respond_to? :magics_set_name)
        return send(args[0].magics_set_name,param.to_s.chop,args[0]) 
      end
      super
    end

  end
end
