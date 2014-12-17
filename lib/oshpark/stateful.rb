module Oshpark
  module Stateful
    def self.included base
      base.const_get(:STATES).each do |_state|
        define_method "#{_state.downcase}?" do
          state == _state
        end
      end
    end
  end
end
