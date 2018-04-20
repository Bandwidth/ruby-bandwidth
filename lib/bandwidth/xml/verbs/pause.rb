module Bandwidth
  module Xml
    module Verbs
      # Pause the execution of an ongoing BXML document
      class Pause
        include XmlVerb

        def to_xml(xml)
          xml.Pause(compact_hash({
           'length' => length
          }))
        end
      end
    end
  end
end
