require 'builder'

module Bandwidth
  module Xml
    # Root class for Bandwidth XML
    class Response
      # Initializer
      # @param verbs [Array] optional list of verbs to include into response
      def initialize(verbs = nil)
        @verbs = verbs || []
      end

      # Return XML presentaion of this response
      def to_xml()
        xml = Builder::XmlMarkup.new()
        xml.instruct!(:xml, :version=>'1.0', :encoding=>'UTF-8')
        xml.Response do
          @verbs.each {|verb| verb.to_xml(xml)}
        end
        xml.target!()
      end

      # Add one or more verbs to this response
      def push(*verbs)
        @verbs.push(*verbs)
      end

      # Add a verb to this response
      def <<(verb)
        @verbs << verb
      end
    end
  end
end
