module MagPlus
  module CoreExtensions
    module String
      def magics_set_name
        :setc
      end
 
    end
  end
end

class String
  include(MagPlus::CoreExtensions::String)
end


