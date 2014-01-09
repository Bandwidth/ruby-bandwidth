module Bandwidth
  module Types
    class BaseCall
      include Instance

      # @return [String] Call id
      attribute :id

      # @return [String] Call direction. One of:
      #   in: Inbound call
      #   out: Outbound call
      attribute :direction

      # @return [String] Call source
      attribute :from

      # @return [String] Call destination
      attribute :to

      # @return [String] Call state. One of:
      #   started: Call is created but wasn't answered
      #   active: Call is answered and isn't finished
      #   completed: Call is finished
      #   transferring: Transferring call
      attribute :state

      # @return [Time] Time when the call was created
      attribute :start_time, Time

      # @return [Time] Time when the call was answered
      attribute :active_time, Time
    end

    class Call < BaseCall
      # @return [Time] Time when the call ended
      attribute :end_time, Time

      # @return [Integer] Seconds between call answer and call end
      attribute :chargeable_duration, Integer
    end

    class BridgedCall < BaseCall
      # @return [String] Unique bridge id
      attribute :bridge_id

      # @return [TrueClass, FalseClass] Recording status
      attribute :recording_enabled, :boolean
    end
  end
end
