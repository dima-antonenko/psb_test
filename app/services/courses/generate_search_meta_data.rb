module Courses
  class GenerateSearchMetaData

    attr_accessor :course

    def initialize(course)
      @course = course
    end

    def call
      course.update_attribute(:search_meta_data, meta_data)
    end

    private

    def meta_data
      expertises_meta =  course.expertises.pluck(:title).join(', ')
      course.title + course.description + expertises_meta
    end
  end
end
