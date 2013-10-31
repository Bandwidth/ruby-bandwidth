module Bandwidth
  class LazyArray
    include Enumerable

    DEFAULT_PAGE_SIZE = 25

    def initialize &block
      @pages = []
      @block = block
    end

    def each
      page = 0
      loop do
        on_page = page(page)
        yield nil if on_page.empty?

        on_page.each do |item|
          yield item if item
        end

        page = page + 1
      end
    end

    def [] index
      page = index / 25
      item = index % 25
      # FIXME: fail if index >= size
      page(page)[item]
    end

    # FIXME: highly ineffective. should either be:
    #   (preferrable) initialized from http header passing a total value. requires REST API changes
    #   fetch pages like expanding binary search for last non-empty page, fetch that page and calculate size
    def size
      page = 0
      total = 0
      @size ||= loop do
        size = page(page).size
        break total if size == 0
        total = total + size
        page = page + 1
      end
    end

    protected
    def page page
      @pages[page] ||= fetch_page(page)
    end

    def fetch_page page
      @block.call page, DEFAULT_PAGE_SIZE
    end
  end
end
