module Courses
  class Destroy < BaseService
    include UserValidations
    include CourseValidations

    attr_accessor :user, :course, :request

    def initialize(user, course, request)
      @user = user
      @course = course
      @request = request
    end

    def call
      validate!
      course.assign_attributes({ deleted: true })
      save_course(course, request)
    end

    private

    def validate!
      user_active?(user)
      course_not_deleted?(course)
    end

    def save_course(course, request)
      return course.errors unless course.valid?
      ActiveRecord::Base.transaction do
        course.save
        course.network_logs.create(user_id: course.id,
                                   event_type: 'destroy_course',
                                   ip: request.remote_ip,
                                   user_agent: request.user_agent,
                                   logable_id: course.id)
      end
      course.reload

      course
    end
  end
end
