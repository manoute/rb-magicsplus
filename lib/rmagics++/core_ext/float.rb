module MagPlus
  module CoreExtensions
    module Float
      def magics_set_name
        :setr
      end
    end
  end
end

class Float
  include(MagPlus::CoreExtensions::Float)
end


