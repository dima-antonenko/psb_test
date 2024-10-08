module Courses
  class Update < BaseService
    include UserValidations
    include AuthorValidations
    include CourseValidations
    attr_accessor :user, :params, :course, :request, :author


    def initialize(user, course, params, request)
      @user = user
      @params = params
      @course = course
      @author = User.find_by(id: params[:user_id])
      @request = request
    end

    def call
      validate!
      assign!
      save_course(course, request)
    end

    private

    def validate!
      user_active?(user)
      author_not_deleted?(author) if params[:user_id]
      course_not_deleted?(course)
    end

    def assign!
      course.assign_attributes(params)
      course.expertise_ids = Expertise.visible.where(id: params[:expertise_ids]).pluck(:id)
    end

    def save_course(course, request)
      return course.errors unless course.valid?
      ActiveRecord::Base.transaction do
        course.save!
        course.network_logs.create(user_id: user.id,
                                   event_type: 'update_course',
                                   ip: request.remote_ip,
                                   user_agent: request.user_agent,
                                   logable_id: course.id)
      end
      course.reload
      course
    end
  end
end
