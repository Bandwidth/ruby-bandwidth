module Bandwidth
  module Xml
    module Verbs
      # Send digits on a live call
      class SendDtmf
        include XmlVerb

        def to_xml(xml)
          xml.SendDtmf(digits)
        end
      end
    end
  end
end
