module Bandwidth
  module Xml
    module Verbs
      class Record
        include XmlVerb

        def to_xml(xml)
          xml.Record(compact_hash({
           'requestUrl' => request_url,
           'requestUrlTimeout' => request_url_timeout,
           'terminatingDigits' => terminating_digits,
           'maxDuration' => max_duration,
           'transcribe' => transcribe,
           'transcribeCallbackUrl' => transcribe_callback_url
          }))
        end
      end
    end
  end
end
