module Bandwidth
  module Xml
    module Verbs
      class Hangup
        include XmlVerb

        def to_xml(xml)
          xml.Hangup()
        end
      end
    end
  end
end
