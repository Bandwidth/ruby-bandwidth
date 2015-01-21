require 'builder'

module Bandwidth
  module Xml
    class Response
      def initialize(verbs = nil)
        @verbs = verbs || []
      end

     def to_xml()
       xml = Builder::XmlMarkup.new()
       xml.instruct!(:xml, :version=>'1.0', :encoding=>'UTF-8')
       xml.Response do
         @verbs.each {|verb| verb.to_xml(xml)}
       end
       xml.target!()
     end

     def push(*verbs)
       @verbs.push(*verbs)
     end

     def <<(verb)
       @verbs << verb
     end
    end
  end
end
