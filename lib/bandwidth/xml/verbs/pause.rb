module Bandwidth
  module Xml
    module Verbs
      # Pause is a verb to specify the length of seconds to wait before executing the next verb
      class Pause
        include XmlVerb

        def to_xml(xml)
          xml.Pause(compact_hash({
           'duration' => duration
          }))
        end
      end
    end
  end
end
