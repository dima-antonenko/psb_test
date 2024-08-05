module Courses
  class SimpleSearch
    attr_accessor :search_query


    def initialize(search_query)
      @search_query = search_query
    end

    def call
      Course.visible.simple_search(search_query)
    end
  end
end
