module MagPlus
  module CoreExtensions
    module NArray
      def raw_params
        case
        when self[0].is_a?(String) 
          {:name => 'mag_set1c_narray', 
            :params => [self]}
        when self.dim == 1 && self.typecode == 3
          {:name => 'mag_set1i_narray', 
            :params => [self]}
        when self.dim == 1 && self.typecode == 5
          {:name => 'mag_set1r_narray', 
            :params => [self]}
        when self.dim == 2 &&  self.typecode == 3 
          {:name => 'mag_set2i_narray', 
            :params => [self]}
        when self.dim == 2 && self.typecode == 5 
          {:name => 'mag_set2r_narray', 
            :params => [self]}
        else
          raise TypeError, "This array can't be used with magics_api."
        end
      end
 
      def magics_set_name
        case
        when self[0].is_a?(String) 
          :set_ary
        when self.dim == 1 && self.typecode == 3
          :set_ary
        when self.dim == 1 && self.typecode == 5
          :set_ary
        when self.dim == 2 &&  self.typecode == 3 
          :set_ary
        when self.dim == 2 && self.typecode == 5 
          :set_ary
        else
          raise TypeError, "This array can't be used with magics_api."
        end
      end
 
    end
  end
end

class NArray
  include(MagPlus::CoreExtensions::NArray)
end


