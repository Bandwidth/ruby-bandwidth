require 'uri'

module Bandwidth
  module API
    module Media

      # Get a list of your media files
      #
      # @return [Array<Types::Medium>]
      #
      # @example
      #   media = bandwidth.media # => [#<Medium:0xa3e7948>, ...]
      #
      #   medium = media.first
      #   medium.content_length # => 2703360
      #   medium.media_name # => "mysong.mp3"
      #
      def media
        LazyArray.new do |page, size|
          media, _headers = get 'media', page: page, size: size

          media.map do |medium|
            Types::Medium.new medium
          end
        end
      end

      # Uploads a media file to the name you choose
      #
      # @param [String] name Custom media name
      # @param [IO, File, StringIO] io Media contents
      #
      # @example
      #   bandwidth.upload "greeting.mp3", file.new("greeting.mp3")
      #
      # @example
      #   bandwidth.upload "greeting.mp3", stringio.new(some_binary_data_here)
      #
      def upload name, io
        # FIXME don't read the whole file, it may be up to 50MB, stream
        put_with_body "media/#{URI.encode(name)}", io.read

        nil
      end

      # Download media file
      #
      # @param [String] name Custom media name
      #
      # @return [String] Binary downloaded data
      #
      # @example
      #   bandwidth.download "recording.mp3"
      #
      def download name
        medium, _headers = get_raw "media/#{URI.encode(name)}"

        medium
      end

      # Permanently deletes a media file you uploaded
      #
      # @param [String] name Custom media name
      #
      # @example
      #   bandwidth.delete_media "greeting.mp3"
      #
      def delete_media name
        delete "media/#{URI.encode(name)}"

        nil
      end
    end
  end
end
