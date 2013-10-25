module Bandwidth
  module API
    module Records

      def records
        records, _headers = get 'recordings'

        records.map do |record|
          Types::RecordWithCall.new record
        end
      end

      def record record_id
        record, _headers = get "recordings/#{record_id}"
        Types::RecordWithCall.new record
      end
    end
  end
end
