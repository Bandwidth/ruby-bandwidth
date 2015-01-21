module Bandwidth
  module Xml
    module Verbs
      class Gather
        include XmlVerb

        def to_xml(xml)
          xml.Gather(compact_hash({
           'requestUrl' => request_url,
           'requestUrlTimeout' => request_url_timeout,
           'terminatingDigits' => terminating_digits,
           'maxDigits' => max_digits,
           'interDigitTimeout' => inter_digit_timeout,
           'bargeable' => bargeable
          }))
        end
      end
    end
  end
end
