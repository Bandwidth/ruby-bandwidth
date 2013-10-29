module Bandwidth
  module API
    module Records

      # List a user's call records
      #
      # @return [Array<Types::Record>]
      #
      # @example
      #   records = bandwidth.records # => [#<Record:0xa798bf0>, ...]
      #
      #   record = records.first
      #   record.end_time # => 2013-02-08 13:15:47 UTC
      #   record.id # => "rec-togfrwqp2bxxezstzbzadra"
      #   record.media # => "c-bonay3r4mtwbplurq4nkt7q-1.wav"
      #   record.call # => "call": "c-bonay3r4mtwbplurq4nkt7q"
      #   record.start_time # => 2013-02-08 13:16:35 UTC
      #   record.state # => "complete"
      #
      # @note See [API::Media] on how to download records
      #
      def records
        records, _headers = get 'recordings'

        records.map do |record|
          Types::RecordWithCall.new record
        end
      end

      # Get recording information
      #
      # @param [String] record_id Record id
      #
      # @return [Types::Record]
      #
      # @example
      #   bandwidth.record "rec-togfrwqp2bxxezstzbzadra" # => #<Record:0xa798bf0>
      #
      def record record_id
        record, _headers = get "recordings/#{record_id}"
        Types::RecordWithCall.new record
      end
    end
  end
end
