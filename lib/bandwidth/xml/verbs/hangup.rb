module Bandwidth
  module Xml
    module Verbs
      # The Hangup verb is used to hangup current call
      class Hangup
        include XmlVerb

        def to_xml(xml)
          xml.Hangup()
        end
      end
    end
  end
end
