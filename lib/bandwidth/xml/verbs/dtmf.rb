module Bandwidth
  module Xml
    module Verbs
      # Send digits on a live call
      class Dtmf
        include XmlVerb

        def to_xml(xml)
          xml.DTMF(digits)
        end
      end
    end
  end
end
