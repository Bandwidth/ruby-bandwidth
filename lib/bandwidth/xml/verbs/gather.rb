module Bandwidth
  module Xml
    module Verbs
      # The Gather verb is used to collect digits for some period of time
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
