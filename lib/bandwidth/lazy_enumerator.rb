module Bandwidth
  class LazyEnumerator < Enumerator

    def initialize(get_first_page, client = nil)
      @client = client || Client.new()
      get_data = get_first_page
      next_page_url = ''
      super() do |yielder|
        while true do
          data, headers = get_data.call()
          data.each do |item|
            if block_given?
              yield(yielder, item)
            else
              yielder << item
            end
          end
          link = headers[:link] || ''
          links = link.split(',') || []
          next_page_url = ''
          links.each do |link|
            values = link.split(';')
            if values.size() == 2 && values[1].strip() == 'rel="next"' then
              next_page_url = values[0].gsub(/[\<\>]/, '').strip()
              break
            end
          end
          break if next_page_url.size == 0
          get_data = Proc.new do
            @client.make_request(:get, next_page_url)
          end
        end
      end
    end

  end
end
