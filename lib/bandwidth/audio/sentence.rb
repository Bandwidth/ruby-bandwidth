module Bandwidth
  module Audio
    class Sentence < Base
      # Sentence that can be used in speak functions
      #
      # @param [String] sentence Sentence to speak
      # @param [Hash] options Sentence options
      # @option options [String] :locale Locale to use
      # @option options [String] :gender Gender to use
      #
      def initialize sentence, options={}
        @sentence = sentence
        @options = options
      end

      # @api private
      def to_hash
        hash = super.merge!({ sentence: @sentence })
        hash.merge!({locale: @options[:locale]}) if @options[:locale]
        hash.merge!({gender: @options[:gender]}) if @options[:gender]
        hash
      end

      # @return US English locale
      LOCALE_EN = "en_US".freeze

      # @return Mexico Spanish locale
      LOCALE_ES = "es_MX".freeze

      # @return French locale
      LOCALE_FR = "fr_FR".freeze

      # @return German locale
      LOCALE_DE = "de_DE".freeze

      # @return Italian locale
      LOCALE_IT = "it_IT".freeze

      # @return Male voice
      MALE = "male".freeze

      # @return Female voice
      FEMALE = "female".freeze
    end
  end
end
