module Bandwidth
  module Xml
    module Verbs
      # The SendMessage is used to send a text message
      class SendMessage
        include XmlVerb

        def to_xml(xml)
          warn "[DEPRECATION] Verb 'SendMessage' will be removed in Bandwidth XML v2"
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
