module Bandwidth
  module Types
    class Conference
      include Instance

      # @return [String] Conference unique ID
      attribute :id

      # @return [Integer] Number of active conference members
      attribute :active_members, Integer

      # @return [Time] The time that the Conference was completed
      attribute :completed_time, Time

      # @return [Time] The time that the Conference was created
      attribute :created_time, Time

      # @return [String] The number that will host the conference
      attribute :from

      # @return [String] Conference state. Possible values:
      #   created: Created
      #   active: Active
      #   completed: Completed
      attribute :state
    end
  end
end
