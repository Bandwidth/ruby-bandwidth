module Bandwidth
  module Xml
    module Verbs
      class SendMessage
        include XmlVerb

        def to_xml(xml)
          xml.SendMessage(text, compact_hash({
           'requestUrl' => request_url,
           'requestUrlTimeout' => request_url_timeout,
           'from' => from,
           'to' => to,
           'statusCallbackUrl' => status_callback_url
          }))
        end
      end
    end
  end
end
