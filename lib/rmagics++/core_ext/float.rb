module MagicsPlus
  module CoreExtensions
    module Float
      def magics_set_name
        :setr
      end
    end
  end
end

class Float
  include(MagicsPlus::CoreExtensions::Float)
end


