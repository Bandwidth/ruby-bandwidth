module Bandwidth
  module Types
    class Bridge
      include Instance

      # @return [String] Bridge unique id
      attribute :id

      # @return [String] Bridge state
      # @see API::Bridges::States possible return values
      attribute :state

      # @return [TrueClass, FalseClass] Enable/Disable two way audio path
      attribute :bridge_audio, :boolean

      # @return [Time] The time when the bridge was completed
      attribute :completed_time, Time

      # @return [Time] The time that bridge was created
      attribute :created_time, Time

      # @return [Time] The time that the bridge got into active state
      attribute :activated_time, Time
    end
  end
end
