module Bandwidth
  module Types
    class Record
      include Instance

      # @return [String] Record id
      attribute :id

      # @return [Time] Time when the record has started
      attribute :start_time, Time

      # @return [Time] Time when the record has ended
      attribute :end_time, Time

      # @return [String] Media URL
      attribute :media, :id

      # @return [String] Record state. One of:
      #   complete: Record complete
      attribute :state
    end

    class RecordWithCall < Record
      # @return [String] Call id
      attribute :call, :id
    end
  end
end
