module MagPlus
  module CoreExtensions
    module Integer
      def magics_set_name
        :seti
      end
 
    end
  end
end

class Integer
  include(MagPlus::CoreExtensions::Integer)
end


