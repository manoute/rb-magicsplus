module MagicsPlus
  module CoreExtensions
    module Array
      def raw_params
        case
        when self[0].is_a?(String) 
          {:name => 'mag_set1c_array', 
            :params => [self, self.length]}
        when self[0].is_a?(Integer) 
          {:name => 'mag_set1i_array', 
            :params => [self.pack('i'* self.length), self.length]}
        when self[0].is_a?(Float) 
          {:name => 'mag_set1r_array', 
            :params => [self.pack('d'* self.length), self.length]}
        when self[0].respond_to?(:[]) && self[0][0].is_a?(Integer) 
          {:name => 'mag_set2i_array', 
            :params => [self.flatten.pack('i' * self.flatten.length), 
                        self[0].length, self.length]}
        when self[0].respond_to?(:[]) && self[0][0].is_a?(Float) 
          {:name => 'mag_set2r_array', 
            :params => [self.flatten.pack('d' * self.flatten.length), 
                        self[0].length, self.length]}
        else
          raise TypeError, "This array can't be used with magics_api."
        end
      end
      
      def magics_set_name
        case
        when self[0].is_a?(String) 
          :set_ary
        when self[0].is_a?(Integer) || self[0].is_a?(Float) 
          :set_ary
        when self[0].respond_to?(:[]) && self[0][0].is_a?(Integer) 
          :set_ary
        when self[0].respond_to?(:[]) && self[0][0].is_a?(Float) 
          :set_ary
        else
          raise TypeError, "This array can't be used with magics_api."
        end
      end
    end
  end
end

class Array
  include(MagicsPlus::CoreExtensions::Array)
end


