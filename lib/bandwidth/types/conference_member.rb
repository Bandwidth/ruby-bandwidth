module Bandwidth
  module Types
    class ConferenceMember
      include Instance

      # @return [String] Conference member ID
      attribute :id

      # @return [Time] Date when the member was added to the conference
      attribute :added_time, Time

      # @return [Time] Date when member was removed from conference
      attribute :removed_time, Time

      # @return [String] The URL used to retrieve the call of the member
      attribute :call, :id

      # @return [TrueClass, FalseClass] Hold state. One of:
      #   true: member can't hear the conference
      #   false: member can hear the conference
      attribute :hold, :boolean

      # @return [TrueClass, FalseClass] Mute state. One of:
      #   true: member can't speak in the conference
      #   false: member can speak in the conference
      attribute :mute, :boolean

      # @return [String] Member state. One of:
      #   active: Active
      #   completed: Completed
      attribute :state
    end
  end
end
